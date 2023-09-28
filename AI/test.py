import os
import json

from EventRecommender import EventRecommender

dir_path = os.path.dirname(os.path.realpath(__file__))
file_path = os.path.join(dir_path, 'test.json')
f = open(file_path)

er = EventRecommender()
# er.train_model_on_json(f)
user_recommendations = er.get_user_recommendation('652')
json_obj = json.dumps(user_recommendations, indent=2)
print(json_obj)
print("\n\nRefitting model...\n")
er.refit_model(f)
user_recommendations = er.get_user_recommendation('502')
json_obj = json.dumps(user_recommendations, indent=2)
print(json_obj)
