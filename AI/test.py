import os

from EventRecommender import EventRecommender

dir_path = os.path.dirname(os.path.realpath(__file__))
file_path = os.path.join(dir_path, 'test.json')
f = open(file_path)

er = EventRecommender()
er.train_model_on_json(f)
print(er.get_user_recommendation('502'))
