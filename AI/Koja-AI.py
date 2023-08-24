import requests
import schedule as schedule
from flask import Flask, request, jsonify
import numpy as np
import pandas as pd
import tensorflow as tf
import tensorflow_recommenders as tfrs
import json
import time
import schedule
import datetime

import os

app = Flask(__name__)


def load_data_and_models():
    f = open('test.json')
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

    user_model = tf.keras.models.load_model("user_model")
    category_model = tf.keras.models.load_model("category_model")
    weekday_model = tf.keras.models.load_model("weekday_model")
    time_frame_model = tf.keras.models.load_model("time_frame_model")

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
    data = json.load(training_data)
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

        return all_events


def retrain_for_new_users(training_data):
    events_data = clean_training_data(training_data)


def auto_train_new(training_data):
    now = datetime.datetime.now()
    next_retrain_time = now.replace(hour=23, minute=59, second=0, microsecond=0)
    if now > next_retrain_time:
        next_retrain_time += datetime.timedelta(days=1)

    schedule.every().day.at(next_retrain_time.strftime("%H:%M")).do(retrain_for_new_users(training_data))

    while True:
        schedule.run_pending()
        time.sleep(1)


def auto_train_all(training_data):
    now = datetime.datetime.now()
    next_retrain_time = now.replace(hour=23, minute=59, second=0, microsecond=0)
    if now > next_retrain_time:
        next_retrain_time += datetime.timedelta(days=1)

    schedule.every().day.at(next_retrain_time.strftime("%H:%M")).do(retrain_for_new_users(training_data))

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


@app.route('/training-data')
def get_training_data():
    api_url = "koja api endpoint"
    headers = {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'}
    response = requests.get(api_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return jsonify(data)
    else:
        return jsonify({'error': 'Failed to fetch data'}), 500


if __name__ == "__main__":
    auto_train_new(get_training_data())
    port = int(os.getenv("PORT", 6000))
    app.run(host='0.0.0.0', port=port, debug=True)
