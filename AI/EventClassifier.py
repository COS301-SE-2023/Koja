from transformers import BertTokenizer, TFBertModel
from joblib import load
import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer


class EventClassifier:
    def __init__(self, classifier_path="KOJA-CR.joblib"):
        self.tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
        self.model = TFBertModel.from_pretrained("bert-base-uncased")

        nltk.download("punkt")
        nltk.download("stopwords")

        self.classifier = load(classifier_path)

    def bert_feature_extraction(self, text):
        inputs = self.tokenizer.encode_plus(
            text,
            return_tensors="tf",
            add_special_tokens=True,
            max_length=50,
            truncation=True,
            padding="max_length",
        )
        outputs = self.model(inputs)
        return outputs.last_hidden_state[:, 0, :].numpy()

    def preprocess_text(self, text):
        if not isinstance(text, str):
            text = str(text)

        tokens = word_tokenize(text)

        stop_words = set(stopwords.words("english"))
        tokens = [word for word in tokens if word.lower() not in stop_words]

        ps = PorterStemmer()
        tokens = [ps.stem(word) for word in tokens]

        return " ".join(tokens)

    def classify_event(self, sentence):
        preprocessed_sentence = self.preprocess_text(sentence)
        features = self.bert_feature_extraction(preprocessed_sentence)
        features = features.reshape(1, -1)

        return self.classifier.predict(features)[0]
