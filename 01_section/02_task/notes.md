### Notes on Querying MongoDB
1. `mongo`: brings you into the Mongo shell.
2. `show dbs`: shows you the databases.
3. `use db`: uses the particular database you want.
4. `show collections`: shows all collections (tables) in that database.
5. `db.collection.find()`: shows every entry in that collection
 -  `db.collection.find().pretty()`: formats the entries for readability
 -  `db.collection.find().count()`: gives you total documents (entries)
6. `db.collection.find({criteria}, {projection})`
 - `db.collection.find({}, {name: 1, email: 1, _id: 0})`: returns all entries in collection with name and email, but no ID (if ID is not specified, it will automatically be returned)


### General Approach to Task 2
1. Obtain userId.
  - Query `main_db.users`.
  - `db.main_db.users.find( { "aka": "jeremiah.grant.test@gmail.com" }, { _id: 1 } )`
2. Query `alt_db` with newly obtainer userId.
  - `db.alt_db.calendarEvent.find( { "scheduledTo.userId": userId }, {_title: 1} )`
  - `db.alt_db.calendarEvents.find(
    { $and: [
      { "scheduledTo.userId": userId },
      { "time": { $lte: UTCFriday } },
      { "time": { $gte: UTCMonday } }
      ]
    },
    { _title: 1 }`
  - _ask Ashutosh about how time is stored_
