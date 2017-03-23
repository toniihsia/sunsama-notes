# Sunsama Questions // Tonia Hsia
You will find some questions I had while going through the prep document below. They are organized by Section and Task.

## Section I
### Task 1
##### Question 1.
The document mentions that the database should be dumped into a directory called `staging-MM-DD-YYYY`. However, it should be restored as `staging_main_db_MM_DD_YYYY`. I am wondering whether the underscores in the restoration names are intentional or whether they should still be hyphens (e.g. `staging-main-db-MM-DD-YYYY`).

##### Answer 1.
*They are intentional but we don't really care if you restore it as hyphens or dashes or even just get rid of them. That's not really the point of the exercise! You can do whatever you want with the file name formats.*


##### Question 2.
The document mentions that database restoration into the local database should be done with names like `staging_main_db_MM_DD_YYYY`. However, you mention that passing in your own `MM_DD_YYYY` such as `joes-dump-MM-DD--YYYY` may be a good option for making meaningful directory names when dumping. If a database is dumped with a _meaningful name_, should the restoration name still be `staging_main_db_MM_DD_YYYY` or `joes_dump_staging_main_db_MM_DD_YYYY`?

##### Answer 2.
This also doesn't really matter. This question is pretty open ended. At the end of the day I want to basically be able to dump and restore with only two commands and I'd like to be able to "label"/"name" those dumps and restores in some kind of sensible fashion.


### Task 2
##### Question 1.
Is title a top-level field and how is time being stored? E.g.
```javascript
{
    title: "Title",
    scheduledTo: [
        {
            "calendarId" : "travis@sunsama.com",
            "userId" : "CcAWZyrLX6tsw85xN"
        },
        {
            "calendarId" : "ashutosh@sunsama.com",
            "userId" : "xakCKSyDzNgGR7Ss2"
        }
    ],
    time: "???"
}
```

##### Answer 1.
`title` is a top lvel field
There is no field called `time`, but there is a top level field called `date` which is an object that specifies the `startDate` and then `endDate` which are each ISODates e.g.

```
date: {

    "startDate" : ISODate("2015-01-29T00:00:00.000+0000"),
    "endDate" : ISODate("2015-01-29T01:00:00.000+0000")
}
```


#### Question 2.
I'm assuming that one will query `main_db` to find Jeremiah's user id. However, we will be using that user id to query `alt_db` and match on userId. I am curious about the nature of subqueries and cross-database queries. (Perhaps this would be a question best answered in person.)

##### Answer 2.
Very good question. Yes, if you were writing a .js script to do this inside the mongo shell you'll have to do a cross database query. For that you can use `db.getSiblingDb`.

If you were in the shell for the `main_db` and wanted to connect to `alt_db` you could create a handle to the second database by doing:

```
// db in this case is main_db, alt_db is a handle to the second db.
var alt_db = db.getSiblingDB("alt_data")
```
The good news is, that's not what this question is about. You can grab the result of one query and then open up the shell/interactive mongo UI in "3T" and just copy and paste stuff! If you're curious, that's how you'd do it.

## Task 4
#### Question 1.
Does every calendarEvent have an inviteeList?

##### Answer 1.
Yes. It will at least be an empty array.

#### Question 2.
Is the name describing the name of the inviteeList?

##### Answer 2.
It describes the invitee's name. See below.

#### Question 3.
What is an example of an inviteeList name? (i.e. what is the purpose of having an inviteeList name?)

##### Answer 3.

Here is an example of a real inviteeList for an event I had with one other person:

```
[
    {
        "email" : "ashutosh@sunsama.com",
        "name" : "Ashutosh Priyadarshy",
        "profilePicture" : "https://s3-us-west-2.amazonaws.com/sunsama-image-uploads/users/ashutosh.priyadarshy/ashutosh-prof-option.jpg",
        "requirement" : "org",
        "status" : "confirmed",
        "type" : {
            "admin" : true,
            "guest" : false
        },
        "userId" : ""
    },
    {
        "email" : "dmdmtriou@gmail.com",
        "name" : "Demetris M. Demetriou",
        "profilePicture" : "https://lh5.googleusercontent.com/-GJWnTBlFx0A/AAAAAAAAAAI/AAAAAAAAA1g/uth6CyG9pN0/photo.jpg",
        "requirement" : "req",
        "status" : "pending",
        "type" : {
            "admin" : false,
            "guest" : true
        },
        "userId" : "kSTfTcQciz4c2eZfr"
    }
]
```

## Section II
### Task 1
#### Question 1.
The document mentions that Sunsama's source code will be found in `/Users/sunsamaguest/sunsamadev/meteor` and asks me to create my own branch. WIll this directory already be git init-ed and if so, will the dev branch exist yet?

##### Answer 1.
Yes and yes.

#### Question 2.
I just wanted to confirm that the new branch's name should indeed be `experiment/hostile_takeover_by_{your_name}`. (Just want to make sure since it seems like a long name for a branch :))

##### Answer 2.
You can name it anything you want! The rules aren't really hard and fast here.

## Section III
#### Question 1.
Is `calendars` a top-level field for every user in `main_db.users`? If not, where is it nested?

##### Answer 1.
Yes.

#### Question 2.
![Filter Panel Design Question](https://s3-us-west-1.amazonaws.com/sunsama-hiring/front-end-design-description.png)
Figure 1 shows two sub-calendars while Figure 2 shows four sub-calendars. I am just wondering whether there are some calendars that shouldn't be counted or whether they are just two different screenshots.

##### Answer 2.

Oops, that's my fault. The first screenshot should say 4 subcalendars. These were drawings from Sketch that I put here, not actual functional screenshots. Nothing complex going on here, just a mistake.

#### Question 3.
You mentioned in your doc that you need to
> "... add info/hint about where to start in the code base."

I was wondering whether these hints will be provided onsite or might be available on a more recent doc.

##### Answer 3.
I will be sitting with you and can help you navigate to the code base etc. Do *not* stress about this one.

#### Question 4.
Is the entire user doc being pulled and stored in the state/store per teammate? (i.e. will each teammate's sub-calendar data be available in the store already?)

##### Answer 4.
The entire user doc is not being pulled down to the client but the `calendar` field is published. So you should have what you need.
