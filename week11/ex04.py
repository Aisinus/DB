from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost:27017/")
db = client["test"]


def grade_c_rogers_avenue():
    restaurants = db.dataset.find({"address.street": "Rogers Avenue"})

    for restaurant in restaurants:
        if any(map(lambda x: x["grade"] == 'C', restaurant["grades"])):
            db.dataset.delete_one({"_id": restaurant["_id"]})
        else:
            db.dataset.update_one(
                {"_id": restaurant["_id"]},
                {"$set": {"grades": restaurant["grades"] + [{"grade": "C", "date": datetime.datetime.now()}]}},
                upsert=False
            )

grade_c_rogers_avenue()