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

    def train_model_on_json(self, cleaned_data):
        (
            all_data,
            all_df,
            category_ids,
            time_frames,
            user_ids,
            weekdays,
        ) = self.get_training_data_from_cleaned_data(cleaned_data)

        # Preparing the datasets
        user_dataset = tf.data.Dataset.from_tensor_slices(np.unique(user_ids))
        category_dataset = tf.data.Dataset.from_tensor_slices(np.unique(category_ids))
        weekday_dataset = tf.data.Dataset.from_tensor_slices(np.unique(weekdays))
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(np.unique(time_frames))

        model = CategoryRecommender()

        model.create_vocabularies(
            user_dataset, category_dataset, weekday_dataset, time_frame_dataset
        )

        category_dataset = tf.data.Dataset.from_tensor_slices(category_ids)
        weekday_dataset = tf.data.Dataset.from_tensor_slices(weekdays)
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(time_frames)

        model.create_models(category_dataset, weekday_dataset, time_frame_dataset)

        model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))

        model.fit(all_data.batch(128), epochs=3)

        model.save_model()
        self.save_dataframe(all_df)

    def get_training_data_from_cleaned_data(self, cleaned_data):
        self.all_events = cleaned_data
        all_df = pd.DataFrame(self.all_events)
        user_ids = all_df["userID"].values
        category_ids = all_df["category"].values
        weekdays = all_df["weekday"].values
        time_frames = all_df["timeFrame"].values
        all_data = tf.data.Dataset.from_tensor_slices(
            {
                "user_id": user_ids,
                "category_id": category_ids,
                "weekday": weekdays,
                "time_frames": time_frames,
            }
        )
        return all_data, all_df, category_ids, time_frames, user_ids, weekdays

    def refit_model(self, cleaned_data):
        old_df = self.load_dataframe()

        (
            _,
            all_df,
            _,
            _,
            _,
            _,
        ) = self.get_training_data_from_cleaned_data(cleaned_data)

        merged_df = pd.concat([old_df, all_df]).reset_index(drop=True)

        model = CategoryRecommender.load_model()

        user_ids = merged_df["userID"].values.astype(str)
        category_ids = merged_df["category"].values.astype(str)
        weekdays = merged_df["weekday"].values.astype(str)
        time_frames = []

        for time_frame in merged_df[["startTime", "endTime"]].values.astype(str):
            time_frames.append(f"{time_frame[0]}-{time_frame[1]}")

        unique_user_ids = np.unique(user_ids)
        unique_category_ids = np.unique(category_ids)
        unique_weekdays = np.unique(weekdays)
        unique_time_frames = np.unique(time_frames)

        # Load the datasets
        user_dataset = tf.data.Dataset.from_tensor_slices(unique_user_ids)
        category_dataset = tf.data.Dataset.from_tensor_slices(unique_category_ids)
        weekday_dataset = tf.data.Dataset.from_tensor_slices(unique_weekdays)
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(unique_time_frames)

        model.create_vocabularies(
            user_dataset, category_dataset, weekday_dataset, time_frame_dataset
        )

        user_dataset = tf.data.Dataset.from_tensor_slices(user_ids)
        category_dataset = tf.data.Dataset.from_tensor_slices(category_ids)
        weekday_dataset = tf.data.Dataset.from_tensor_slices(weekdays)
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(time_frames)

        model.create_models(category_dataset, weekday_dataset, time_frame_dataset)

        training_data = tf.data.Dataset.from_tensor_slices(
            {
                "user_id": user_ids,
                "category_id": category_ids,
                "weekday": weekdays,
                "time_frames": time_frames,
            }
        )

        model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))

        model.fit(training_data.batch(128), epochs=3)

        model.save_model()
        self.save_dataframe(merged_df)

    def get_user_recommendation(self, user_id):
        model = CategoryRecommender.load_model()
        all_df = self.load_dataframe()

        user_ids = all_df["userID"].values
        category_ids = all_df["category"].values
        weekdays = all_df["weekday"].values
        time_frames = []

        for time_frame in all_df[["startTime", "endTime"]].values:
            time_frames.append(f"{time_frame[0]}-{time_frame[1]}")

        unique_user_ids = np.unique(user_ids)
        unique_category_ids = np.unique(category_ids)
        unique_weekdays = np.unique(weekdays)
        unique_time_frames = np.unique(time_frames)

        # Load the datasets
        user_dataset = tf.data.Dataset.from_tensor_slices(unique_user_ids)
        category_dataset = tf.data.Dataset.from_tensor_slices(unique_category_ids)
        weekday_dataset = tf.data.Dataset.from_tensor_slices(unique_weekdays)
        time_frame_dataset = tf.data.Dataset.from_tensor_slices(unique_time_frames)

        model.create_models(category_dataset, weekday_dataset, time_frame_dataset)

        # Create indexing layers
        user_model_index = tfrs.layers.factorized_top_k.BruteForce(model.user_model)
        user_model_index.index_from_dataset(
            tf.data.Dataset.zip(
                (
                    category_dataset.batch(100),
                    category_dataset.batch(100).map(model.category_model),
                )
            )
        )

        weekday_model_index = tfrs.layers.factorized_top_k.BruteForce(
            model.weekday_model
        )
        weekday_model_index.index_from_dataset(
            tf.data.Dataset.zip(
                (
                    weekday_dataset.batch(100),
                    weekday_dataset.batch(100).map(model.weekday_model),
                )
            )
        )

        timeframe_model_index = tfrs.layers.factorized_top_k.BruteForce(
            model.time_frame_model
        )
        timeframe_model_index.index_from_dataset(
            tf.data.Dataset.zip(
                (
                    time_frame_dataset.batch(100),
                    time_frame_dataset.batch(100).map(model.time_frame_model),
                )
            )
        )

        # Get top 10 category recommendations
        _, category_recommendations = user_model_index(tf.constant([user_id]))
        top_10_category_ids = category_recommendations[0][:10].numpy()

        recommendations = {}

        for category_id in top_10_category_ids:
            category_id_tensor = tf.constant([category_id])

            _, weekday_recommendations = weekday_model_index(category_id_tensor, k=7)
            _, timeframe_recommendations = timeframe_model_index(category_id_tensor)

            top_10_weekday_ids = weekday_recommendations[0][:10].numpy()
            top_10_timeframe_ids = timeframe_recommendations[0][:10].numpy()

            week_days = {}
            for weekday_id, timeframe_id in zip(
                top_10_weekday_ids, top_10_timeframe_ids
            ):
                weekday_id = weekday_id.decode("utf-8")
                timeframe_id = timeframe_id.decode("utf-8")

                if weekday_id not in week_days:
                    week_days[weekday_id] = []
                week_days[weekday_id].append(timeframe_id)

            category_id = category_id.decode("utf-8")
            if category_id not in recommendations:
                recommendations[category_id] = []
            recommendations[category_id].append({"week_days": week_days})

        return recommendations

    def save_datasets(
        self, user_dataset, category_dataset, weekday_dataset, time_frame_dataset
    ):
        tf.data.experimental.save(user_dataset, "AI/Datasets/user_dataset")
        tf.data.experimental.save(category_dataset, "AI/Datasets/category_dataset")
        tf.data.experimental.save(weekday_dataset, "AI/Datasets/weekday_dataset")
        tf.data.experimental.save(time_frame_dataset, "AI/Datasets/time_frame_dataset")

    def load_datasets(self):
        user_dataset = tf.data.experimental.load("AI/Datasets/user_dataset")
        category_dataset = tf.data.experimental.load("AI/Datasets/category_dataset")
        weekday_dataset = tf.data.experimental.load("AI/Datasets/weekday_dataset")
        time_frame_dataset = tf.data.experimental.load("AI/Datasets/time_frame_dataset")

        return user_dataset, category_dataset, weekday_dataset, time_frame_dataset

    def save_dataframe(self, df):
        os.makedirs("AI/Data", exist_ok=True)
        if os.path.exists("AI/Data/all_df.csv"):
            df.to_csv("AI/Data/all_df.csv", mode="a", header=False, index=False)
        else:
            df.to_csv("AI/Data/all_df.csv", index=False)

    def load_dataframe(self):
        return pd.read_csv("AI/Data/all_df.csv")
