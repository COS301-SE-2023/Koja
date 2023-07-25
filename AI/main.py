import json
from typing import Dict, Text
import requests
import pandas as pd
import tensorflow as tf
import tensorflow_recommenders as tfrs
import numpy as np

f = open('test.json')

# returns JSON object as
# a dictionary
data = json.load(f)

# # Define the URL
# url = "http://192.168.50.5:8080/api/v1/ai/all-users-events"

# headers = {
#     "Authorisation": "secret"
# }

# response = requests.get(url, headers=headers)
# data = response.json()

# Define the URL
# url = "http://192.168.50.5:8080/api/v1/ai/all-users-events"

# headers = {
#     "Authorisation": "secret"
# }

# response = requests.get(url, headers=headers)
# data = response.json()

# For every block of data
for block in data:
    # Training block
    expanded_training_events = []
    for event in block['training']:
        for time_frame in event['timeFrame']:
            new_event = event.copy()
            new_event['startTime'] = time_frame['first'].strip()
            new_event['endTime'] = time_frame['second'].strip()
            new_event['category'] = event['category'].strip()
            new_event['weekday'] = event['weekday'].strip()
            new_event['userID'] = event['userID'].strip()
            expanded_training_events.append(new_event)
    # Testing block
    expanded_testing_events = []
    for event in block['testing']:
        for time_frame in event['timeFrame']:
            new_event = event.copy()
            new_event['startTime'] = time_frame['first'].strip()
            new_event['endTime'] = time_frame['second'].strip()
            new_event['category'] = event['category'].strip()
            new_event['weekday'] = event['weekday'].strip()
            new_event['userID'] = event['userID'].strip()
            expanded_testing_events.append(new_event)

    # Concatenate training and testing data
    all_events = expanded_training_events + expanded_testing_events

all_df = pd.DataFrame(all_events)

# Extract user_ids and category_ids as numpy arrays
user_ids = all_df['userID'].values
category_ids = all_df['category'].values
weekdays = all_df['weekday'].values
time_frames = []

for timeFrame in all_df[['startTime', 'endTime']].values:
    time_frames.append(f"{timeFrame[0]}-{timeFrame[1]}")

# Create TensorFlow dataset from pandas DataFrame
all_data = tf.data.Dataset.from_tensor_slices({
    "user_id": user_ids,
    "category_id": category_ids,
    "weekday": weekdays,
    "time_frames": time_frames
})
#
# # We will also need a dataset of all unique user ids and category ids for model fitting
user_dataset = tf.data.Dataset.from_tensor_slices(np.unique(user_ids))
category_dataset = tf.data.Dataset.from_tensor_slices(np.unique(category_ids))
weekday_dataset = tf.data.Dataset.from_tensor_slices(np.unique(weekdays))
time_frame_dataset = tf.data.Dataset.from_tensor_slices(np.unique(time_frames))

user_ids_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
user_ids_vocabulary.adapt(user_dataset)

categories_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
categories_vocabulary.adapt(category_dataset)

weekday_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
weekday_vocabulary.adapt(weekday_dataset)

time_frame_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
time_frame_vocabulary.adapt(time_frame_dataset)

# # Define user and category models
user_model = tf.keras.Sequential([
    user_ids_vocabulary,
    tf.keras.layers.Embedding(user_ids_vocabulary.vocab_size() + 1, 16),
])

category_model = tf.keras.Sequential([
    categories_vocabulary,
    tf.keras.layers.Embedding(categories_vocabulary.vocab_size() + 1, 16),
])

weekday_model = tf.keras.Sequential([
    weekday_vocabulary,
    tf.keras.layers.Embedding(weekday_vocabulary.vocab_size() + 1, 16),
])

time_frame_model = tf.keras.Sequential([
    time_frame_vocabulary,
    tf.keras.layers.Embedding(time_frame_vocabulary.vocab_size() + 1, 16),
])

category_candidates = category_dataset.batch(128).map(category_model)
weekday_candidates = weekday_dataset.batch(128).map(weekday_model)
time_frame_candidates = time_frame_dataset.batch(128).map(time_frame_model)

all_candidates = category_candidates.concatenate(weekday_candidates).concatenate(time_frame_candidates)

# # Define the task as retrieval (recommendation)
task = tfrs.tasks.Retrieval(metrics=tfrs.metrics.FactorizedTopK(
    candidates=all_candidates
))

# # Create a TFRS model
class CategoryRecommender(tfrs.models.Model):
    def __init__(self, user_model, category_model, weekday_model, time_frame_model, task):
        super().__init__()
        self.user_model = user_model
        self.category_model = category_model
        self.weekday_model = weekday_model
        self.time_frame_model = time_frame_model
        self.task = task

    def compute_loss(self, features, training=False):
        user_embeddings = self.user_model(features["user_id"])
        category_embeddings = self.category_model(features["category_id"])
        weekday_embeddings = self.weekday_model(features["weekday"])
        time_frame_embeddings = self.time_frame_model(features["time_frames"])

        # Compute losses for each type of embeddings
        user_loss = self.task(user_embeddings, category_embeddings)
        category_loss = self.task(category_embeddings, category_embeddings)
        weekday_loss = self.task(weekday_embeddings, category_embeddings)
        time_frame_loss = self.task(time_frame_embeddings, category_embeddings)

        # Combine these losses
        return user_loss + category_loss + weekday_loss + time_frame_loss

model = CategoryRecommender(user_model, category_model, weekday_model, time_frame_model, task)

# # Configure and train the model
model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))

# # Train the model
model.fit(all_data.batch(128), epochs=10000)

index = tfrs.layers.factorized_top_k.BruteForce(model.user_model)
index.index_from_dataset(
    tf.data.Dataset.zip((category_dataset.batch(100), category_dataset.batch(100).map(model.category_model)))
)

# # Get recommendations.
user_id = "502"  # change this to the user id you want to recommend for
_, titles = index(np.array([user_id]))

print(f"Recommendations for user {user_id}: {titles[0][:10]}")