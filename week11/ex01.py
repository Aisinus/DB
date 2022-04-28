from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["test"]

def all_indian_cusines():
    return db.restaurants.find({"cuisine": "Indian"})

def all_indian_and_thai_cuisines():
    return db.restaurants.find({"cuisine": {"$regex": "(Indian|Thai)"}})

def following_address_rogers():
    return db.restaurants.find_one({"address.building": "1115", "address.street": "Rogers Avenue", "address.zipcode": "11226"})


print("all Indian cuisines: ",list(all_indian_cusines()))
print("all Indian and Thai cuisines", list(all_indian_and_thai_cuisines()))
print("Find a restaurant with the following address: 1115 Rogers Avenue, 11226", following_address_rogers())
