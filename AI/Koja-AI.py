import base64
import datetime
import json
import logging
import os
import time

import requests
import schedule as schedule
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from dotenv import load_dotenv
from flask import Flask, request, jsonify

from CryptoService import CryptoService
from EventClassifier import EventClassifier

from EventRecommender import EventRecommender

app = Flask(__name__)
load_dotenv()
crypto_service = CryptoService()
classifier = EventClassifier()
event_recommender = EventRecommender()

USER_MODEL_FILE_LOCATION = "AI/Models/user_model"
CATEGORY_MODEL_FILE_LOCATION = "AI/Models/category_model"
WEEKDAY_MODEL_FILE_LOCATION = "AI/Models/weekday_model"
TIME_FRAME_MODEL_FILE_LOCATION = "AI/Models/time_frame_model"


def clean_training_data(training_data):
    all_events = []

    for block in training_data[:3]:
        expanded_events = []
        for event in block["training"] + block["testing"]:
            for time_frame in event["timeFrame"]:
                new_event = event.copy()
                new_event["startTime"] = crypto_service.decrypt_data(
                    time_frame["first"]
                ).strip()
                new_event["endTime"] = crypto_service.decrypt_data(
                    time_frame["second"]
                ).strip()
                new_event["category"] = classifier.classify_event(
                    crypto_service.decrypt_data(event["category"]).strip()
                )
                new_event["weekday"] = crypto_service.decrypt_data(
                    event["weekday"]
                ).strip()
                new_event["userID"] = crypto_service.decrypt_data(
                    event["userID"]
                ).strip()
                new_event[
                    "timeFrame"
                ] = f"{new_event['startTime']}-{new_event['endTime']}"
                expanded_events.append(new_event)

        all_events += expanded_events

    return all_events


@app.route("/train/new-user", methods=["POST"])
def train_for_new_user():
    try:
        if request.method == "POST" and request.is_json:
            data = request.get_json()
            request_koja_id_secret = data.get("kojaIDSecret")
            decrypted_koja_id = crypto_service.decrypt_data(request_koja_id_secret)
            if os.getenv("KOJA_ID_SECRET") == decrypted_koja_id:
                try:
                    return "Successfully started training", 200
                finally:
                    retrain_for_new_users()
            else:
                return "Unauthorised request", 401
        else:
            return "Request was not POST", 400
    except Exception as e:
        logging.error(f"An error occurred in `train_for_all_user_endpoint`: {e}")
        return "Server error occurred, please try again later", 500


@app.route("/train/all-users", methods=["POST"])
def train_for_all_user_endpoint():
    try:
        if request.method == "POST" and request.is_json:
            data = request.get_json()
            request_koja_id_secret = data.get("kojaIDSecret")
            decrypted_koja_id = crypto_service.decrypt_data(request_koja_id_secret)
            if os.getenv("KOJA_ID_SECRET") == decrypted_koja_id:
                try:
                    return "Successfully started training", 200
                finally:
                    retrain_for_all_users()
            else:
                return "Unauthorised request", 401
        else:
            return "Request was not POST", 400
    except Exception as e:
        logging.error(f"An error occurred in `train_for_all_user_endpoint`: {e}")
        return "Server error occurred, please try again later", 500


@app.route("/public-key", methods=["GET"])
def get_ai_public_key():
    try:
        public_key = crypto_service.get_public_key()
        return jsonify({"public-key": public_key}), 200
    except Exception as e:
        logging.error(f"An error occurred in `get_ai_public_key`: {e}")
        return "Server error occurred, please try again later", 500


def retrain_for_new_users():
    try:
        training = True
        account_events_endpoint = f"{os.getenv('SERVER_ADDRESS')}:{os.getenv('SERVER_PORT')}/api/v1/ai/get-account-events"
        new_users_emails = get_new_users_emails()

        user_account_events = [None] * len(new_users_emails)

        koja_public_key = get_koja_public_key()
        public_key = crypto_service.get_public_key()
        encrypted_koja_secret_id = crypto_service.encrypt_data(
            data=os.getenv("KOJA_ID_SECRET"), public_key=koja_public_key
        )

        request_payload = {
            "publicKey": public_key,
            "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode("ascii"),
        }

        request_json_str = json.dumps(request_payload)

        for i in range(len(new_users_emails)):
            encrypted_email = base64.b64encode(
                crypto_service.encrypt_data(
                    data=new_users_emails[i], public_key=get_koja_public_key()
                )
            ).decode("ascii")
            user_account_events[i] = requests.get(
                account_events_endpoint,
                params={"request": request_json_str, "userEmail": encrypted_email},
            )

        usable_events = []
        for user_event_set in user_account_events:
            if user_event_set.status_code == 200:
                usable_events += user_event_set.json()

        events_data = clean_training_data(usable_events)
        if len(events_data) > 0:
            event_recommender.refit_model(events_data)

    finally:
        training = False


def retrain_for_all_users():
    account_events_endpoint = f"{os.getenv('SERVER_ADDRESS')}:{os.getenv('SERVER_PORT')}/api/v1/ai/get-account-events"

    all_user_emails = get_all_users_emails()

    user_account_events = [None] * len(all_user_emails)

    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"), public_key=koja_public_key
    )

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode("ascii"),
    }

    request_json_str = json.dumps(request_payload)

    for i in range(len(all_user_emails)):
        encrypted_email = base64.b64encode(
            crypto_service.encrypt_data(
                data=all_user_emails[i], public_key=get_koja_public_key()
            )
        ).decode("ascii")
        user_account_events[i] = requests.get(
            account_events_endpoint,
            params={"request": request_json_str, "userEmail": encrypted_email},
        )

    usable_events = []
    for user_event_set in user_account_events:
        if user_event_set.status_code == 200:
            usable_events += user_event_set.json()

    events_data = clean_training_data(usable_events)
    if len(events_data) > 0:
        event_recommender.refit_model(events_data)


def auto_train_new():
    now = datetime.datetime.now()
    next_retrain_time = now.replace(hour=23, minute=59, second=0, microsecond=0)
    if now > next_retrain_time:
        next_retrain_time += datetime.timedelta(days=1)

    schedule.every().day.at(next_retrain_time.strftime("%H:%M")).do(
        retrain_for_new_users
    )

    while True:
        schedule.run_pending()
        time.sleep(1)


def auto_train_all():
    now = datetime.datetime.now()
    next_retrain_time = now.replace(
        hour=23, minute=59, second=0, microsecond=0
    ) + datetime.timedelta(days=7)

    # Schedule the retraining to occur every 7 days
    schedule.every(7).days.at(next_retrain_time.strftime("%H:%M")).do(
        retrain_for_all_users
    )

    # Start the scheduling loop
    while True:
        schedule.run_pending()
        time.sleep(1)


def get_training_data():
    api_url = "localhost:8080/api/v1/ai/all-users-events"
    headers = {"Authorization": "Access token"}
    response = requests.get(api_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return jsonify(data)
    else:
        return jsonify({"error": "Failed to fetch data"}), 500


def get_koja_public_key():
    api_url = f"{os.getenv('SERVER_ADDRESS')}:{os.getenv('SERVER_PORT')}/api/v1/auth/koja/public-key"
    response = requests.get(api_url)

    if response.status_code == 200:
        data = response.json()
        public_key_bytes = base64.b64decode(data)
        public_key = serialization.load_der_public_key(
            public_key_bytes, backend=default_backend()
        )
        return public_key
    else:
        return jsonify({"error": "Failed to fetch data"}), 500


def get_new_users_emails():
    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"), public_key=koja_public_key
    )

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode("ascii"),
    }

    request_json_str = json.dumps(request_payload)

    api_url = f"{os.getenv('SERVER_ADDRESS')}:{os.getenv('SERVER_PORT')}/api/v1/ai/get-new-user-emails"
    response = requests.get(api_url, params={"request": request_json_str})

    return response.json()


def get_all_users_emails():
    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"), public_key=koja_public_key
    )

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode("ascii"),
    }

    request_json_str = json.dumps(request_payload)

    api_url = f"{os.getenv('SERVER_ADDRESS')}:{os.getenv('SERVER_PORT')}/api/v1/ai/get-all-user-emails"
    response = requests.get(api_url, params={"request": request_json_str})

    encrypted_emails = response.json()
    emails = []

    for email in encrypted_emails:
        emails.append(crypto_service.decrypt_data(encoded_string=email))

    return emails


if __name__ == "__main__":
    # auto_train_new(get_training_data())
    # auto_train_new(get_training_data())
    load_dotenv()
    port = int(os.getenv("PORT", 6000))
    koja_id_secret = os.getenv("KOJA_ID_SECRET")
    app.run(host="0.0.0.0", port=port, debug=True)
