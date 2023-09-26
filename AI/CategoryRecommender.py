import tensorflow_recommenders as tfrs
import tensorflow as tf

KOJA_MODEL_FILE_LOCATION = "AI/Models/koja_model"
USER_MODEL_FILE_LOCATION = "AI/Models/user_model"
CATEGORY_MODEL_FILE_LOCATION = "AI/Models/category_model"
WEEKDAY_MODEL_FILE_LOCATION = "AI/Models/weekday_model"
TIME_FRAME_MODEL_FILE_LOCATION = "AI/Models/time_frame_model"


class CategoryRecommender(tf.keras.Model):
    def __init__(self):
        super().__init__()

        self.task = None
        self.user_ids_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
        self.categories_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
        self.weekday_vocabulary = tf.keras.layers.StringLookup(mask_token=None)
        self.time_frame_vocabulary = tf.keras.layers.StringLookup(mask_token=None)

        self.user_model = tf.keras.Sequential()
        self.category_model = tf.keras.Sequential()
        self.weekday_model = tf.keras.Sequential()
        self.time_frame_model = tf.keras.Sequential()

        self.vocab_filepaths = {
            "user": f"{KOJA_MODEL_FILE_LOCATION}_user_ids_vocabulary.txt",
            "category": f"{KOJA_MODEL_FILE_LOCATION}_categories_vocabulary.txt",
            "weekday": f"{KOJA_MODEL_FILE_LOCATION}_weekday_vocabulary.txt",
            "time_frame": f"{KOJA_MODEL_FILE_LOCATION}_time_frame_vocabulary.txt",
        }

    def create_vocabularies(
        self, user_dataset, category_dataset, weekday_dataset, time_frame_dataset
    ):
        self.user_ids_vocabulary.adapt(user_dataset)
        self.categories_vocabulary.adapt(category_dataset)
        self.weekday_vocabulary.adapt(weekday_dataset)
        self.time_frame_vocabulary.adapt(time_frame_dataset)

    def create_models(self, category_dataset, weekday_dataset, time_frame_dataset):

        self.user_model.add(self.user_ids_vocabulary)
        self.user_model.add(
            tf.keras.layers.Embedding(
                self.user_ids_vocabulary.vocabulary_size() + 1, 16
            )
        )

        self.category_model.add(self.categories_vocabulary)
        self.category_model.add(
            tf.keras.layers.Embedding(
                self.categories_vocabulary.vocabulary_size() + 1, 16
            )
        )

        self.weekday_model.add(self.weekday_vocabulary)
        self.weekday_model.add(
            tf.keras.layers.Embedding(self.weekday_vocabulary.vocabulary_size() + 1, 16)
        )

        self.time_frame_model.add(self.time_frame_vocabulary)
        self.time_frame_model.add(
            tf.keras.layers.Embedding(
                self.time_frame_vocabulary.vocabulary_size() + 1, 16
            )
        )

        category_candidates = category_dataset.batch(128).map(self.category_model)
        weekday_candidates = weekday_dataset.batch(128).map(self.weekday_model)
        time_frame_candidates = time_frame_dataset.batch(128).map(self.time_frame_model)
        
        all_candidates = category_candidates.concatenate(weekday_candidates).concatenate(
            time_frame_candidates
        )
        
        self.task = tfrs.tasks.Retrieval(
            metrics=tfrs.metrics.FactorizedTopK(candidates=all_candidates)
        )

    def save_vocabulary(self, vocab_layer, vocab_type):
        filepath = self.vocab_filepaths[vocab_type]
        vocab = vocab_layer.get_vocabulary()
        with open(filepath, "w") as f:
            for item in vocab:
                f.write(f"{item}\n")

    def load_vocabulary(self, vocab_type):
        filepath = self.vocab_filepaths[vocab_type]
        vocab = []
        with open(filepath, "r") as f:
            for line in f:
                vocab.append(line.strip())
        return vocab

    def save_all_vocabularies(self):
        self.save_vocabulary(self.user_ids_vocabulary, "user")
        self.save_vocabulary(self.categories_vocabulary, "category")
        self.save_vocabulary(self.weekday_vocabulary, "weekday")
        self.save_vocabulary(self.time_frame_vocabulary, "time_frame")

    def load_all_vocabularies(self):
        user_vocab = self.load_vocabulary("user")
        category_vocab = self.load_vocabulary("category")
        weekday_vocab = self.load_vocabulary("weekday")
        time_frame_vocab = self.load_vocabulary("time_frame")

        self.user_ids_vocabulary.set_vocabulary(user_vocab)
        self.categories_vocabulary.set_vocabulary(category_vocab)
        self.weekday_vocabulary.set_vocabulary(weekday_vocab)
        self.time_frame_vocabulary.set_vocabulary(time_frame_vocab)

    def call(self, inputs):
        user_features = self.user_model(inputs["user_id"])
        category_features = self.category_model(inputs["category_id"])
        weekday_features = self.weekday_model(inputs["weekday"])
        time_frame_features = self.time_frame_model(inputs["time_frames"])

        return tf.concat(
            [user_features, category_features, weekday_features, time_frame_features],
            axis=1,
        )

    def compute_loss(self, *args, **kwargs):
        features = args[0]
        training = kwargs.get("training", False)

        user_embeddings = self.user_model(features["user_id"])
        category_embeddings = self.category_model(features["category_id"])
        weekday_embeddings = self.weekday_model(features["weekday"])
        time_frame_embeddings = self.time_frame_model(features["time_frames"])

        user_loss = self.task(user_embeddings, category_embeddings)
        category_loss = self.task(user_embeddings, category_embeddings)
        weekday_loss = self.task(weekday_embeddings, category_embeddings)
        time_frame_loss = self.task(time_frame_embeddings, category_embeddings)

        return user_loss + category_loss + weekday_loss + time_frame_loss

    def save_model(self):
        # Save the model's architecture and weights
        self.save_weights(KOJA_MODEL_FILE_LOCATION + "_weights")

        # Save all vocabularies
        self.save_all_vocabularies()

    @classmethod
    def load_model(cls):
        loaded_model = cls()
        loaded_model.load_weights(KOJA_MODEL_FILE_LOCATION + "_weights")
        loaded_model.load_all_vocabularies()

        return loaded_model

