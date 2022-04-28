from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost:27017/")
db = client["test"]


def insert():
    return db.dataset.insert_one({
        "address.building": "1480",
        "address.street": "2 Avenue",
        "address.zipcode": "10075",
        "address.coord": [-73.9557413, 40.7720266],
        "borough": "Manhattan",
        "cuisine": "Italian",
        "name": "Vella",
        "restaurant_id": "41704620",
        "grades": [{
            "date": datetime.datetime(2014, 10, 11),
            "grade": "A",
            "score": 10
            # in lab no info about score
        }],
    })

insert()
