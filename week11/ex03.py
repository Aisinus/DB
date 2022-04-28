from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost:27017/")
db = client["test"]

def delete_one_manhattan():
    db.dataset.delete_one({"borough": "Manhattan"})

def delete_all_thai():
    db.dataset.delete_many({"cuisine": "Thai"})

delete_one_manhattan()
delete_all_thai()