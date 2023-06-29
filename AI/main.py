import pandas as pd
import tensorflow as tf
import tensorflow_recommenders as tfrs

# Load dataframe
df = pd.read_csv('weekly_schedule_dataset.csv')
# print(df)

# Define the user and item feature columns
user_col = 'userID'
item_col = 'description'

# Create tensorflow dataset

dataset = tf.data.Dataset.from_tensor_slices(dict(df))

train_size = int(len(df) * 0.8)  # 80% for training, 20% for testing
train_dataset = dataset.take(train_size)
test_dataset = dataset.skip(train_size)

user_ids = df[user_col].unique().tolist()
item_ids = df[item_col].unique()
items = tf.data.Dataset.from_tensor_slices(item_ids)

item_model = tf.keras.Sequential([
    tf.keras.layers.StringLookup(
        vocabulary=item_ids, mask_token=None
    ),
    tf.keras.layers.Embedding(len(item_ids) + 1, 32)
])

user_model = tf.keras.Sequential([
    tf.keras.layers.StringLookup(
        vocabulary=user_ids, mask_token=None
    ),
    tf.keras.layers.Embedding(len(item_ids) + 1, 32)
])

metrics = tfrs.metrics.FactorizedTopK(
    candidates=items.batch(16).map(item_model)
)

task = tfrs.tasks.Retrieval(
    metrics=metrics
)
class EventRecommenderModel(tfrs.Model):
    def __init__(self, user_model, item_model):
        super().__init__()
        self.user_model: tf.keras.Model = user_model
        self.item_model: tf.keras.Model = item_model
        self.task: tf.keras.layers.Layer = task

    def compute_loss(self, features, training=False):
        user_embeddings = self.user_model(features[user_col])
        item_embeddings = self.item_model(features[item_col])
        return self.task(user_embeddings, item_embeddings)
    def call(self, inputs):
        return self.user_model(inputs)


model = EventRecommenderModel(user_model, item_model)

model.compile(optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.1))

train_dataset = train_dataset.shuffle(1000).batch(16)
test_dataset = test_dataset.batch(16)

model.fit(train_dataset, epochs=10)
# Get recommendations for a single user
user_id = tf.constant(['3A'])  # Example user ID

# Encode the user ID
encoded_user_id = user_model(user_id).numpy()

# Get item embeddings
item_embeddings = item_model(item_ids).numpy()

# Retrieve the top-k recommendations for the user
user_embeddings = tf.repeat(encoded_user_id, repeats=len(item_ids), axis=0)
scores = tf.linalg.matmul(user_embeddings, item_embeddings, transpose_b=True)
top_k = tf.argsort(scores, direction='DESCENDING')[:1]
recommended_items = tf.gather(item_ids, top_k)

print("Recommended items for user", user_id, ":")
for item in recommended_items:
    print(item)


