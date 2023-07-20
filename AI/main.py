import json
import numpy as np
import pandas as pd
import tensorflow as tf
import tensorflow_recommenders as tfrs
from sklearn.preprocessing import OneHotEncoder

# Load data
f = open('test.json')
data = json.load(f)

# For every block of data
for block in data:
    # Training block
    expanded_training_events = []
    for event in block['training']:
        for time_frame in event['timeFrame']:
            new_event = event.copy()
            new_event['startTime'] = time_frame['first']
            new_event['endTime'] = time_frame['second']
            expanded_training_events.append(new_event)
    # Testing block
    expanded_testing_events = []
    for event in block['testing']:
        for time_frame in event['timeFrame']:
            new_event = event.copy()
            new_event['startTime'] = time_frame['first']
            new_event['endTime'] = time_frame['second']
            expanded_testing_events.append(new_event)

    # Concatenate training and testing data
    all_events = expanded_training_events + expanded_testing_events

print(len(all_events))

# Create pandas DataFrame
all_df = pd.DataFrame(all_events)

# Extract user_ids, category_ids and weekdays as numpy arrays
user_ids = all_df['userID'].values
category_ids = all_df['category'].values
weekdays = all_df['weekday'].values

# Convert weekdays to one-hot encoding
enc = OneHotEncoder(sparse=False)
weekdays_one_hot = enc.fit_transform(weekdays.reshape(-1, 1))

# Create TensorFlow datasets
all_data = tf.data.Dataset.from_tensor_slices({
    "user_id": user_ids,
    "category_id": category_ids,
    "weekday": weekdays_one_hot
})
user_dataset = tf.data.Dataset.from_tensor_slices(np.unique(user_ids))
category_dataset = tf.data.Dataset.from_tensor_slices(np.unique(category_ids))

# Define user, category and weekday models
user_model = tf.keras.Sequential([
    tf.keras.layers.StringLookup(vocabulary=np.unique(user_ids), mask_token=None),
    tf.keras.layers.Embedding(len(np.unique(user_ids)) + 1, 5),
])

category_model = tf.keras.Sequential([
    tf.keras.layers.StringLookup(vocabulary=np.unique(category_ids), mask_token=None),
    tf.keras.layers.Embedding(len(np.unique(category_ids)) + 1, 10),
])

weekday_model = tf.keras.Sequential([
    tf.keras.layers.Dense(7, activation='relu'),  # Fully connected layer for one-hot encoded input
    tf.keras.layers.Flatten(),  # Flatten the output
    tf.keras.layers.Dense(5),  # Final embedding size
])

# Define the task as retrieval (recommendation)
task = tfrs.tasks.Retrieval(metrics=tfrs.metrics.FactorizedTopK(
    candidates=category_dataset.batch(128).map(category_model)
))

# Create a TFRS model
class CategoryRecommender(tfrs.models.Model):
    def __init__(self, user_model, category_model, weekday_model, task):
        super().__init__()
        self.user_model = user_model
        self.category_model = category_model
        self.weekday_model = weekday_model
        self.task = task

    def compute_loss(self, features, training=False):
        user_embeddings = self.user_model(features["user_id"])
        category_embeddings = self.category_model(features["category_id"])
        weekday_embeddings = self.weekday_model(features["weekday"])
        return self.task(tf.concat([user_embeddings, weekday_embeddings], axis=1), category_embeddings)

model = CategoryRecommender(user_model, category_model, weekday_model, task)

# Configure and train the model
model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.008))

# Train the model
model.fit(all_data.batch(128), epochs=100)

index = tfrs.layers.factorized_top_k.BruteForce(model.user_model)
index.index_from_dataset(
    tf.data.Dataset.zip((category_dataset.batch(100), category_dataset.batch(100).map(model.category_model)))
)

# Get recommendations.
user_id = "502"  # change this to the user id you want to recommend for
_, titles = index(np.array([user_id]))

print(f"Recommendations for user {user_id}: {titles[0][:10]}")
