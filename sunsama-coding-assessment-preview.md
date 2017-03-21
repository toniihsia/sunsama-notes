# Sunsama Developer Assessment

### Section I. Databases and Command Line Work

**Objectives**

* Comfort and familiarity with basic database operations: queries, updates, and aggregates.  
* Comfort and familiarity using basic command line tools and the UNIX shell.

**Background Information**

Sunsama uses MongoDB for its database. For architectural reasons (and some side effects of Meteor), we have two separate databases. In our production environment the first is called "PROD\_MAIN" and the other one is called "PROD\_ALT". We will refer to them as `main_db` and `alt_db` from here on out.

The `main_db` contains collections (and documents) that are updated at "user speed" e.g. users, templates, groups. Basically updates to these collections happen when a user takes an action e.g. clicks something.

The `alt_db` contains collections (and documents) that are updated at "machine speed" e.g. calendarEvents, recurringEvents, etc. Basically updates to these collections happen via long running tasks e.g. syncing with every calendar event from a google account.

_Optional note: For the curious, this is because Meteor depends on oplog tailing the database. When you programatically insert or update thousands of documents very quickly this floods the oplog with operations and causes Meteor to crash because it can't keep up. This is a flaw with Meteor that we had to work around. An example of this type of operation would be when a new user signs up and we sync thousands of their calendar events into our database._

**Task Overview and Starter Info**

You will write a very simple bash script that takes a dump of Sunsama's staging databases (`alt_db` and `main_db`) and then restores it. Then you will perform a few basic operations on the dataset.

Here are the basic commands for dumping the staging database to your local machine. These commands use `mongodump` to connect to our staging databases and exports all the collections in gzipped format to the following directory on your local machine: `~/MONGODUMP/staging-03-07-2017`

*Dumping Remote Mongo Databases to your local machine*

~~~bash
# Dump the `main_db`. Note that we call it `sift` for legacy reasons in our staging environment.
$ mongodump --host ec2-xx-xx-xxx-xxx.us-west-2.compute.amazonaws.com:27000 --username ******** --password ******** --gzip --db ******** --authenticationDatabase admin --out ~/MONGODUMP/staging-03-07-2017

# Dump the `alt_db`. Note that we call it `alt_data` for some legacy reasons in our staging environment.
$ mongodump --host ec2-xx-xx-xxx-xxx.us-west-2.compute.amazonaws.com:27000 --username xxxxxxxx --password xxxxxxxx --gzip --db alt_data --authenticationDatabase admin --out ~/MONGODUMP/staging-03-07-2017
~~~

*Restoring Mongo Databases into your local machine*

Here are the basic commands for restoring the staging database into the mongo instance that is running locally on your machine at port 27017. These will take the two gzipped files `sift` and `alt_data` from `~/MONGODUMP/staging-03-07-2017` and restore into the local database with names `staging_main_db_03_07_2017` and `staging_alt_db_03_07_2017`.

```bash
# Restore the dump of `main_db` into localhost mongo.
$ mongorestore --noIndexRestore --host localhost --db staging_main_db_03_07_2017 --port 27017 --gzip  ~/MONGODUMP/staging-03-07-2017/sift
# Restore the dump of `alt_db` into localhost mongo.
$ mongorestore --noIndexRestore --host localhost --db staging_alt_db_03_07_2017 --port 27017 --gzip  ~/MONGODUMP/staging-03-07-2017/alt_data
```

**Task 1: Write bash script(s) that dumps and restores with the appropriate dates.**

In the above section you have concrete, working examples that you should be able to copy and paste directly into your command line to dump the databases and then restore them.

We want to generalize these commands so that we don't need to type in those messy, long date strings everytime we take a dump. We want a generic `sunsama_staging_dump.sh` file that will automatically create a dump to the local machine with today's date (in `MM-DD-YYYY` format) in the gzipped files name and the restored databases' name.

You have flexibility in three matters:

* You can write two separate functions for restoring and dumping or you can paramaterize your one function based on which action you are taking.
* You can pass in the date in `MM-DD-YYYY` format into your command line function or you can generate it programatically. It might be better if you pass it in that way you can customize it futher like with other meaningful names like `joes-dump-MM-DD-YYYY` etc.
* The entire internet is at your disposal.


**Task 2: Basic Querying**

Now that we've restored the dump, we can run some queries on it. We are going to find all the event's scheduled onto a user's calendar between Monday and Friday of the next full week. The user in question is Jeremiah Grant: `jeremiah.grant.test@gmail.com`.

Every `alt_db.calendarEvent` has a top-level array field called `scheduledTo`. Here's an example of what the `scheduledTo` array looks like. In this example, this event is scheduled to Travis and Ashutosh's calendars because their userIds are set in the `scheduledTo.userId` field. You should ignore the `calendarId` field as it's often the user's email but not the case in general. Don't use it in your query.

```javascript
scheduledTo: [
    {
        "calendarId" : "travis@sunsama.com",
        "userId" : "CcAWZyrLX6tsw85xN"
    },
    {
        "calendarId" : "ashutosh@sunsama.com",
        "userId" : "xakCKSyDzNgGR7Ss2"
    }
]
```

Every document in the collection `main_db.users` corresponds with a single user. The `_id` field is what we call the "user id" and in other collections we refer to it as `userId`. A single user e.g. Ashutosh Priyadarshy might have multiple e-mail addresses associated with their account, you can see a full list of their account emails in the top level field `aka` which is a simple array of e-mail addresses.

Your task is to find Jeremiah Grant's userId based on his e-mail `jeremiah.grant.test@gmail.com` and then return just the event `title` of all of his events in the next week between Monday and Friday inclusive. You can ignore timezones and just query between the start of Monday and end of Friday in UTC for now.

We've installed `3T Studio` on your machine, you can use that to browse your dump of the database and run queries. Ashutosh can show you around the UI of the tool if you've never used it before. Mongo should already be running at 27017.

**Task 3: Basic Aggregate**

Next, we want to find documents in the `alt_db.calendarEvents` collection organized by `streamId` that have non-placeholder agendas.

Next, we want to find all `agenda` items associated with a document in the `alt_db.calendarEvents` collection that are non-placeholders. We'd also like to group these agenda items by `streamId`.

Some basics about the data model. Each document in `alt_db.calendarEvents` has a top-level array field called `agenda`. Each item in `agenda` array is an object. In that object, the `_id` field corresponds to the the `_id` of a document in the `alt_db.tasks` collection. Inside the app, documents in the `alt_db.tasks` collection are a generic wrapper document that we use to represent both agenda items and action items on a calendar event. Some objects in this array have the field `placeholder` set to `true`. This means you are dealing with an empty agenda item that has no meaningful text content. We want to ignore any agenda items where the `placeholder` is set to `true`. Here is an example of what that looks like in the app and in the database:

![MacDown Screenshot](https://s3-us-west-1.amazonaws.com/sunsama-hiring/tasks-placeholder.png)


```javascript
// The relevant sections of what the above calendar event's `agenda` and `streamIds` field would look like.
    "agenda" : [
        {
            "_id" : "mDxENnvaam4bD5rNv"
        },
        {
            "_id" : "xvGo9qmWThtjusDEy"
        },
        {
            "_id" : "oLL8KjiwXa7Dohxe8",
            "placeholder" : true
        }
    ],
    "streamIds" : [
        "gfxGWgbH6EuBpjDoh",
        "FSqo6ehZGp6CB7Dgh"
    ],
```

Inside of the app you can tag calendar events and tasks into "projects". We used to call the projects feature "streams" and that's why the data model relies on a collection called `main_db.streams`. Each document in the `main_db.calendarEvents` collection also has a top level array field called `streamIds` where each element is a single string representing all the projects/streams that a given event is tagged in.  

Given all the documents in the collection `main_db.calendarEvents` write a MongoDB aggregate that will map `streamIds` to the `_id` field inside the of the agenda.

The result should have one object for each unique `streamId` you find in the `alt_db.calendarEvents` collection and each of those objects should have an array of `taskIds` that correspond to non-placeholder tasks. You should omit any streams/projects from the result set that don't have any tasks. For the above example we'd want an output like so.

```javascript
[
	{
		_id: "gfxGWgbH6EuBpjDoh",
		// Note that task "oLL8KjiwXa7Dohxe8" isn't included as it's a placeholder.
		taskIds: ["xvGo9qmWThtjusDEy", "mDxENnvaam4bD5rNv"]
	},
	{
		_id: "FSqo6ehZGp6CB7Dgh",
		// Note that we've seen these taskIds before in the previous item, that's okay, we want to group uniquely by streamId.
		taskIds: ["xvGo9qmWThtjusDEy", "mDxENnvaam4bD5rNv"]
	}
]
```

**Task 4: Index a collection**

We want to quickly search for documents inside of `main_db.calendarEvents` based on an **exact match** to an invitee's name  which can be found here: `inviteeList.name`. Add an index to the collection to do this. Hint: _do not_ create a text index.

**Task 5: Explain this Index**

The `alt_db.tasks` collection contains documents that represent tasks. Tasks can be agenda items, tasks or action items. Basically things you can check off. If they're "checked off" in the UI this means the field `completed` is set to `true` and the `completeDate` is the `ISODate` on which this happened.

There is an index on the `alt_db.tasks` collection that was created with the following command:

```javascript
db.tasks.createIndex({completed: 1, completeDate: 1})
```
Can you explain this form of indexing in MongoDB and how this indexing operation might be useful in the application?


### Section II: Working with Git and the Command Line

Objectives:

* Check your understanding of git (and revision control).
* Assess your comfort using the command line.
* Assess your ability to work in brand new environments and figure things out.

Background:
We've configured the machine you are working on to have an up-to-date copy of Sunsama's source code. You'll find it in the directory `/Users/sunsamaguest/sunsamadev/meteor`

**Task 1: Create a branch off of `dev` to prepare for your next task**

You can call the branch `experiment/hostile_takeover_by_{your_name}` e.g. `experiment/hostile_takeover_by_ashutosh`

**Task 2: Change the splash page**

On the splash page, you'll see that we call Sunsama `The calendar for teams` please find this and change it to anything you'd like.

**Task 3: Run the app and ensure your takeover is complete**
Make sure you are inside of `~/sunsamadev/meteor` and then run this to start your app server.

```
cd sunsama-app
meteor
```

**Task 4: Commit your changes to your local branch**

Save your changes to the splash page to the branch you created.

### Section III: Working with React, HTML and CSS

Objectives:

* Assess your ability to write modular, reusable, well-designed React inside of a complex app.
* anything else?


Background:

We've given you a test account that's preloaded with lots of delicious data. You can use this Google account to create a Sunsama account on your local machine.

```
email: jeremiah.grant.test@gmail.com`
password: captainplanet
```
One of our biggest product development tasks in the coming months will be to allow you to quickly and easily toggle which of your subcalendars are showing in your calendar.

If you aren't familiar with the world of multiple calendars here's a quick example of what it all looks like.

Let's start with Jeremiah Grant \<jermiah.grant.test@gmail.com\>'s Google Calendar. Here's what it looks like:

![Jeremiah Grant's Google Calendar](https://s3-us-west-1.amazonaws.com/sunsama-hiring/google-calendar-basic.png)

In this view Jeremiah has 6 calendars shared and accessible to his account that's associated with `jeremiah.grant.test@gmail.com`:

* Jeremiah Grant
* ASU Faculty
* Jeremiah Grant (Personal)
* Ministry Work
* Nike OOO
* Reminders (note this is a Google default)

Inside of Sunsama we store all this information about how Jermiah's calendars are organized within the top level field `calendars`. You will see each calendar above inside the `calendars.items` field. Here's the relevant snippet of Jeremiah's user doc.

```javascript
{
    "kind" : "calendar#calendarList",
    "etag" : "\"p320cvr62uj6t40g\"",
    "nextSyncToken" : "CIDP7ML0zdICEh1qZXJlbWlhaC5ncmFudC50ZXN0QGdtYWlsLmNvbQ==",
    "items" : [
        {
            "id" : "82pi33fg16sn5livdhutlasggg@group.calendar.google.com",
            "google" : {
                "kind" : "calendar#calendarListEntry",
                "etag" : "\"1489215048466000\"",
                "summary" : "Nike OOO",
                "description" : "Who isn't coming to work today!",
                "timeZone" : "America/Los_Angeles",
                "colorId" : "22",
                "backgroundColor" : "#f691b2",
                "foregroundColor" : "#000000",
                "selected" : true,
                "accessRole" : "owner",
                "defaultReminders" : [

                ]
            },
            "sunsama" : {
                "selected" : false,
                "primary" : false
            }
        },
        /*
        *
        *    ... truncated ...
        *
        */
        {
            "id" : "a7tr7orree545afcq3qv3b2t8g@group.calendar.google.com",
            "google" : {
                "kind" : "calendar#calendarListEntry",
                "etag" : "\"1489215030174000\"",
                "summary" : "Jeremiah Grant (Personal)",
                "timeZone" : "America/Los_Angeles",
                "colorId" : "4",
                "backgroundColor" : "#fa573c",
                "foregroundColor" : "#000000",
                "selected" : true,
                "accessRole" : "owner",
                "defaultReminders" : [

                ]
            },
            "sunsama" : {
                "selected" : false,
                "primary" : false
            }
        },
		"key" : "jeremiah.grant.test@gmail.com"
}
```

Currently, the Sunsama calendar panel doesn't show these sub-calendars. Given Jeremiah's account, please build the front-end with basic toggling interactions as described in the image below.

Need to add info/hint about where to start in the code base.

![Filter Panel Design Question](https://s3-us-west-1.amazonaws.com/sunsama-hiring/front-end-design-description.png)

### IV. Design and Architecture

**Objectives:**
- Assess your ability to think through the creation and implementation of scalable and modular backend services.
- Assess your ability to balance UX considerations with architectural decisions at a high level.
- Check that we jive when whiteboarding together.

**Background:**

Sunsama has a notion of tasks. Tasks can be standalone entities, or they can be attached to a calendar event in which case we refer to them as "action items". Many users and teams have requested that we be able to export, import, and synchronize their tasks with the other services that they use e.g. Trello, Jira and Asana.

Trello, JIRA, and Asana are the services we'd like to integrate with first. Here are links to their developer docs and APIs: [Trello] (https://developers.trello.com/), [Asana] (https://asana.com/developers/), [JIRA] (https://docs.atlassian.com/jira/REST/cloud/)

We'll design a simplistic integration with these product. Users will be allowed to export a single task (or action item) at a time from Sunsama into Trello, Asana, or JIRA. Once a task is exported to a given service, we'd like to keep the tasks' data synchronized with Sunsama (in both directions).

**Task 1: Read over the documentation**

Take some time to read and understand how these three applications model their data and what they make accessible to developers. Don't worry about the details of specifc endpoints.

**Task 2: Get on the same page**

Let's talk through any assumptions or questions you might have about how this feature can/should work so that we can start sketching out the actual architecture.  

**Task 3: Block Diagram (sketch) of this feature**:

Let's whiteboard a block diagram of what this feature looks like and make sure we agree on the overall structure of the feature.

**Task 4: Sketch out data-model**

Together on a whiteboard, let's sketch out how we might extend our task data model to handle the tracking and synchronization of tasks that have been pushed to any of these three services.

**Task 5: Identify Issues**

What could go wrong? Where might we run into performance and scaling issues?

### V. Devops

Objectives:

- Assess your comfort working with AWS, ECS and Docker.

**Task 1**: Deploy a Node "Hello World" Server to Amazon ECS with Docker

Ashutosh will have an AWS account ready for you to login to so that you can create instances etc.
