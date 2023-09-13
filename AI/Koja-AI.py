import base64
import datetime
import json
import os
import time

import numpy as np
import pandas as pd
import requests
import schedule as schedule
import tensorflow as tf
import tensorflow_recommenders as tfrs
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from dotenv import load_dotenv
from flask import Flask, request, jsonify

from CryptoService import CryptoService
from main import CategoryRecommender, task

app = Flask(__name__)
load_dotenv()
crypto_service = CryptoService()
user_model_file_location = "AI/Models/user_model"
category_model_file_location = "AI/Models/category_model"
weekday_model_file_location = "AI/Models/weekday_model"
time_frame_model_file_location = "AI/Models/time_frame_model"


def load_data_and_models():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(dir_path, 'test.json')
    f = open(file_path)
    data = json.load(f)
    all_events = []

    for block in data:
        expanded_events = []
        for event in block['training'] + block['testing']:
            for time_frame in event['timeFrame']:
                new_event = event.copy()
                new_event['startTime'] = time_frame['first'].strip()
                new_event['endTime'] = time_frame['second'].strip()
                new_event['category'] = event['category'].strip()
                new_event['weekday'] = event['weekday'].strip()
                new_event['userID'] = event['userID'].strip()
                new_event['timeFrame'] = f"{new_event['startTime']}-{new_event['endTime']}"
                expanded_events.append(new_event)

        all_events += expanded_events

    all_df = pd.DataFrame(all_events)
    time_frames = all_df['timeFrame'].values

    user_dataset = tf.data.Dataset.from_tensor_slices(np.unique(all_df['userID'].values))
    category_dataset = tf.data.Dataset.from_tensor_slices(np.unique(all_df['category'].values))
    weekday_dataset = tf.data.Dataset.from_tensor_slices(np.unique(all_df['weekday'].values))
    time_frame_dataset = tf.data.Dataset.from_tensor_slices(np.unique(time_frames))

    user_model = tf.keras.models.load_model(user_model_file_location)
    category_model = tf.keras.models.load_model(category_model_file_location)
    weekday_model = tf.keras.models.load_model(weekday_model_file_location)
    time_frame_model = tf.keras.models.load_model(time_frame_model_file_location)

    user_model_index = tfrs.layers.factorized_top_k.BruteForce(user_model)
    user_model_index.index_from_dataset(
        tf.data.Dataset.zip((category_dataset.batch(100), category_dataset.batch(100).map(category_model)))
    )

    weekday_model_index = tfrs.layers.factorized_top_k.BruteForce(weekday_model)
    weekday_model_index.index_from_dataset(
        tf.data.Dataset.zip((weekday_dataset.batch(100), weekday_dataset.batch(100).map(weekday_model)))
    )

    time_frame_model_index = tfrs.layers.factorized_top_k.BruteForce(time_frame_model)
    time_frame_model_index.index_from_dataset(
        tf.data.Dataset.zip((time_frame_dataset.batch(100), time_frame_dataset.batch(100).map(time_frame_model)))
    )

    return user_model_index, weekday_model_index, time_frame_model_index


user_model_index, weekday_model_index, time_frame_model_index = load_data_and_models()


def clean_training_data(training_data):
    training_data = crypto_service.decrypt_data(training_data)
    all_events = []

    for block in training_data:
        expanded_events = []
        for event in block['training'] + block['testing']:
            for time_frame in event['timeFrame']:
                new_event = event.copy()
                new_event['startTime'] = crypto_service.decrypt_data(time_frame['first']).strip()
                new_event['endTime'] = crypto_service.decrypt_data(time_frame['second']).strip()
                new_event['category'] = crypto_service.decrypt_data(event['category']).strip()
                new_event['weekday'] = crypto_service.decrypt_data(event['weekday']).strip()
                new_event['userID'] = crypto_service.decrypt_data(event['userID']).strip()
                new_event['timeFrame'] = f"{new_event['startTime']}-{new_event['endTime']}"
                expanded_events.append(new_event)

        all_events += expanded_events

    return all_events


@app.route('/train/new-user', methods=['POST'])
def train_for_new_user():
    data = os.getenv("KOJA_ID_SECRET")
    if request.method == 'POST':
        public_key = request.POST.get("publicKey")
        koja_id_secret = request.POST.get("kojaIDSecret")
        CryptoService.decrypt_private_key(public_key, koja_id_secret)
        if koja_id_secret == data:
            retrain_for_new_users()
            return "Successfully Trained", 200
        else:
            return "Unknown source", 400
    else:
        return "Request was not POST", 400


@app.route('/train/all', methods=['POST'])
def train_for_all_user_endpoint():
    if request.is_json:
        retrain_for_all_users()
        return "Successfully Trained", 200
    else:
        return "Request was not JSON", 400


def retrain_for_new_users(training_data):
    events_data = clean_training_data(training_data)
    loaded_user_model = tf.keras.models.load_model(user_model_file_location)
    loaded_category_model = tf.keras.models.load_model(category_model_file_location)
    loaded_weekday_model = tf.keras.models.load_model(weekday_model_file_location)
    loaded_time_frame_model = tf.keras.models.load_model(time_frame_model_file_location)
    model = CategoryRecommender(loaded_user_model, loaded_category_model, loaded_weekday_model, loaded_time_frame_model,
                                task)
    model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))
    model.fit(events_data.batch(128), epochs=50)


@app.route('/train/all', methods=['POST'])
def train_for_new_user():
    if request.is_json:
        retrain_for_all_users()
        return "Successfully Trained", 200
    else:
        return "Request was not JSON", 400


def retrain_for_all_users():
    account_events_endpoint = f"{koja_server_address}:{koja_server_port}/api/v1/ai/get-account-events"

    all_user_emails = get_all_users_emails()

    user_account_events = [None] * len(all_user_emails)

    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"),
        public_key=koja_public_key
    )

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode('ascii')
    }

    request_json_str = json.dumps(request_payload)

    for i in range(len(all_user_emails)):
        encrypted_email = base64.b64encode(
            crypto_service.encrypt_data(data=all_user_emails[i], public_key=get_koja_public_key())).decode('ascii')
        user_account_events[i] = requests.get(account_events_endpoint,
                                              params={"request": request_json_str, "userEmail": encrypted_email})

    usable_events = []
    for user_event_set in user_account_events:
        if user_event_set.status_code == 200:
            usable_events += user_event_set.json()

    events_data = clean_training_data(usable_events)
    loaded_user_model = tf.keras.models.load_model(user_model_file_location)
    loaded_category_model = tf.keras.models.load_model(category_model_file_location)
    loaded_weekday_model = tf.keras.models.load_model(weekday_model_file_location)
    loaded_time_frame_model = tf.keras.models.load_model(time_frame_model_file_location)
    model = CategoryRecommender(loaded_user_model, loaded_category_model, loaded_weekday_model, loaded_time_frame_model,
                                task)
    model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))
    model.fit(events_data.batch(128), epochs=50)


def auto_train_new(training_data):
    now = datetime.datetime.now()
    next_retrain_time = now.replace(hour=23, minute=59, second=0, microsecond=0)
    if now > next_retrain_time:
        next_retrain_time += datetime.timedelta(days=1)

    schedule.every().day.at(next_retrain_time.strftime("%H:%M")).do(retrain_for_new_users, training_data)

    while True:
        schedule.run_pending()
        time.sleep(1)


def auto_train_all(training_data):
    now = datetime.datetime.now()
    next_retrain_time = now.replace(hour=23, minute=59, second=0, microsecond=0) + datetime.timedelta(days=7)

    # Schedule the retraining to occur every 7 days
    schedule.every(7).days.at(next_retrain_time.strftime("%H:%M")).do(retrain_for_all_users, training_data)

    # Start the scheduling loop
    while True:
        schedule.run_pending()
        time.sleep(1)


@app.route('/recommendations', methods=['POST'])
def recommend_categories():
    if request.is_json:
        data = request.get_json()
        user_id = data['userID']

        max_output = 7
        _, titles = user_model_index(np.array([user_id]))

        recommendations = []
        for category_id in titles[0][:10]:
            # Convert TensorFlow EagerTensor to numpy array
            category_id_np = category_id.numpy().decode("utf-8")
            _, weekdays = weekday_model_index(np.array([category_id_np]), k=max_output)
            _, time_frames = time_frame_model_index(np.array([category_id_np]))

            recommendations.append({
                "category": category_id_np,
                "weekdays": [weekday.numpy().decode("utf-8") for weekday in weekdays[0]],
                "time_frames": [time_frame.numpy().decode("utf-8") for time_frame in time_frames[0]],
            })

        return jsonify(recommendations)
    else:
        return "Request was not JSON", 400


@app.route('/api/v1/auth/ai/public-key')
def get_ai_public_key():
    return jsonify(CryptoService.get_public_key())


def get_training_data():
    api_url = "localhost:8080/api/v1/ai/all-users-events"
    headers = {'Authorization': 'Access token'}
    response = requests.get(api_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return jsonify(data)
    else:
        return jsonify({'error': 'Failed to fetch data'}), 500


def get_koja_public_key():
    api_url = f"{koja_server_address}:{koja_server_port}/api/v1/auth/koja/public-key"
    response = requests.get(api_url)

    if response.status_code == 200:
        data = response.json()
        public_key_bytes = base64.b64decode(data)
        public_key = serialization.load_der_public_key(public_key_bytes, backend=default_backend())
        return public_key
    else:
        return jsonify({'error': 'Failed to fetch data'}), 500


def get_new_users_emails():
    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"),
        public_key=koja_public_key)

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode('ascii')
    }

    request_json_str = json.dumps(request_payload)

    api_url = f"{koja_server_address}:{koja_server_port}/api/v1/ai/get-new-user-emails"
    response = requests.get(api_url, params={"request": request_json_str})

    return response.json()


def get_all_users_emails():
    koja_public_key = get_koja_public_key()
    public_key = crypto_service.get_public_key()
    encrypted_koja_secret_id = crypto_service.encrypt_data(
        data=os.getenv("KOJA_ID_SECRET"),
        public_key=koja_public_key
    )

    request_payload = {
        "publicKey": public_key,
        "kojaIDSecret": base64.b64encode(encrypted_koja_secret_id).decode('ascii')
    }

    request_json_str = json.dumps(request_payload)

    api_url = f"{koja_server_address}:{koja_server_port}/api/v1/ai/get-all-user-emails"
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
    koja_server_address = os.getenv("SERVER_ADDRESS")
    koja_server_port = os.getenv("SERVER_PORT")
    retrain_for_all_users()
    app.run(host='0.0.0.0', port=port, debug=True)
