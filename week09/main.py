import psycopg2
import geopy

with open("ex01.sql") as sql:
    script = "".join(sql.readlines())
    scripts = script.split("\n\n")
create_function, get_addresses, update_lat_long, = scripts

connection = psycopg2.connect(database="ex01", user="postgres", password="123", host="127.0.0.1", port="5432")

cursor = connection.cursor()
cursor.execute(create_function)
connection.commit()

print("Created function")

cursor = connection.cursor()
cursor.execute(get_addresses)
rows = cursor.fetchall()
geocoder = geopy.Nominatim(user_agent="test1")

for row in rows:
    address_id, city, address, country = row
    print(address, city, country)

    try:
        location = geocoder.geocode(address)
        longitude, latitude = location.longitude, location.latitude
    except Exception:
        longitude, latitude = 0, 0
    print(longitude, latitude)
    cursor.execute(update_lat_long.format(longitude, latitude, address_id))
connection.commit()
connection.close()
print("Successfully updated lat-long")
