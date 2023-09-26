import json
import os

import pandas as pd
import tensorflow as tf
import tensorflow_recommenders as tfrs
import numpy as np

from CategoryRecommender import CategoryRecommender

KOJA_MODEL_FILE_LOCATION = "AI/Models/koja_model"
USER_MODEL_FILE_LOCATION = "AI/Models/user_model"
CATEGORY_MODEL_FILE_LOCATION = "AI/Models/category_model"
WEEKDAY_MODEL_FILE_LOCATION = "AI/Models/weekday_model"
TIME_FRAME_MODEL_FILE_LOCATION = "AI/Models/time_frame_model"


class EventRecommender:
    all_events = []

    def train_model_on_json(self, json_data):
        data = json.load(json_data)
        for block in data:
            expanded_training_events = []
            for event in block["training"]:
                for time_frame in event["timeFrame"]:
                    new_event = event.copy()
                    new_event["startTime"] = time_frame["first"].strip()
                    new_event["endTime"] = time_frame["second"].strip()
                    new_event["category"] = event["category"].strip()
                    new_event["weekday"] = event["weekday"].strip()
                    new_event["userID"] = event["userID"].strip()
                    expanded_training_events.append(new_event)
            expanded_testing_events = []
            for event in block["testing"]:
                for time_frame in event["timeFrame"]:
                    new_event = event.copy()
                    new_event["startTime"] = time_frame["first"].strip()
                    new_event["endTime"] = time_frame["second"].strip()
                    new_event["category"] = event["category"].strip()
                    new_event["weekday"] = event["weekday"].strip()
                    new_event["userID"] = event["userID"].strip()
                    expanded_testing_events.append(new_event)

            self.all_events = expanded_training_events + expanded_testing_events

        all_df = pd.DataFrame(self.all_events)

        user_ids = all_df["userID"].values
        category_ids = all_df["category"].values
        weekdays = all_df["weekday"].values
        time_frames = []

        for time_frame in all_df[["startTime", "endTime"]].values:
            time_frames.append(f"{time_frame[0]}-{time_frame[1]}")

        all_data = tf.data.Dataset.from_tensor_slices(
            {
                "user_id": user_ids,
                "category_id": category_ids,
                "weekday": weekdays,
                "time_frames": time_frames,
            }
        )

        # Preparing the datasets
        user_dataset = tf.data.Dataset.from_tensor_slices(np.unique(user_ids))
        category_dataset = tf.data.Dataset.from_tensor_slices(np.unique(category_ids))
        weekday_dataset = tf.data.Dataset.from_tensor_slices(np.unique(weekdays))
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(np.unique(time_frames))

        model = CategoryRecommender()

        model.create_vocabularies(
            user_dataset, category_dataset, weekday_dataset, time_frame_dataset
        )
        model.create_models(category_dataset, weekday_dataset, time_frame_dataset)

        model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))

        model.fit(all_data.batch(128), epochs=3)

        model.save_model()

    def refit_model(self, training_data):
        model = CategoryRecommender.load_model()
        model.fit(training_data.batch(128), epochs=3)
        model.save_model()

    def get_user_recommendation(self, user_id):
        model = CategoryRecommender.load_model()

        user_id_tensor = tf.constant([user_id])

        category_recommendations = model.category_model(user_id_tensor)
        top_10_category_ids = category_recommendations.numpy()[0][:10]

        recommendations = {}

        for category_id in top_10_category_ids:
            category_id_tensor = tf.constant([category_id])

            weekday_recommendations = model.weekday_model(category_id_tensor)
            timeframe_recommendations = model.time_frame_model(category_id_tensor)

            weekday_ids, _ = weekday_recommendations
            timeframe_ids, _ = timeframe_recommendations

            top_10_weekday_ids = weekday_ids.numpy()[0][:10]
            top_10_timeframe_ids = timeframe_ids.numpy()[0][:10]

            week_days = {}
            for weekday_id, timeframe_id in zip(
                top_10_weekday_ids, top_10_timeframe_ids
            ):
                if weekday_id not in week_days:
                    week_days[weekday_id] = []
                week_days[weekday_id].append(timeframe_id)

            if category_id not in recommendations:
                recommendations[category_id] = []
            recommendations[category_id].append({"week_days": week_days})

        return recommendations

    def get_stored_models(self):
        model = tf.keras.models.load_model(
            KOJA_MODEL_FILE_LOCATION,
            custom_objects={
                "CategoryRecommender": CategoryRecommender,
                "Retrieval": tfrs.tasks.Retrieval,
            },
        )
        # Load the user model and its index
        user_model = tf.keras.models.load_model(USER_MODEL_FILE_LOCATION)
        user_model_index = tf.keras.models.load_model(
            USER_MODEL_FILE_LOCATION + "_index"
        )
        # Load the category model
        category_model = tf.keras.models.load_model(CATEGORY_MODEL_FILE_LOCATION)
        # Load the weekday model and its index
        weekday_model = tf.keras.models.load_model(WEEKDAY_MODEL_FILE_LOCATION)
        weekday_model_index = tf.keras.models.load_model(
            WEEKDAY_MODEL_FILE_LOCATION + "_index"
        )
        # Load the time frame model and its index
        time_frame_model = tf.keras.models.load_model(TIME_FRAME_MODEL_FILE_LOCATION)
        timeframe_model_index = tf.keras.models.load_model(
            TIME_FRAME_MODEL_FILE_LOCATION + "_index"
        )
        return (
            category_model,
            model,
            time_frame_model,
            timeframe_model_index,
            user_model,
            user_model_index,
            weekday_model,
            weekday_model_index,
        )
