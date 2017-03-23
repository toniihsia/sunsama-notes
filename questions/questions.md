# Sunsama Questions // Tonia Hsia
You will find some questions I had while going through the prep document below. They are organized by Section and Task.

## Section I
### Task 1
##### Question 1.
The document mentions that the database should be dumped into a directory called `staging-MM-DD-YYYY`. However, it should be restored as `staging_main_db_MM_DD_YYYY`. I am wondering whether the underscores in the restoration names are intentional or whether they should still be hyphens (e.g. `staging-main-db-MM-DD-YYYY`).
##### Question 2.
The document mentions that database restoration into the local database should be done with names like `staging_main_db_MM_DD_YYYY`. However, you mention that passing in your own `MM_DD_YYYY` such as `joes-dump-MM-DD--YYYY` may be a good option for making meaningful directory names when dumping. If a database is dumped with a _meaningful name_, should the restoration name still be `staging_main_db_MM_DD_YYYY` or `joes_dump_staging_main_db_MM_DD_YYYY`?

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

#### Question 2.
I'm assuming that one will query `main_db` to find Jeremiah's user id. However, we will be using that user id to query `alt_db` and match on userId. I am curious about the nature of subqueries and cross-database queries. (Perhaps this would be a question best answered in person.)

## Task 4
#### Question 1.
Does every calendarEvent have an inviteeList?

#### Question 2.
Is the name describing the name of the inviteeList?

#### Question 3.
What is an example of an inviteeList name? (i.e. what is the purpose of having an inviteeList name?)

## Section II
### Task 1
#### Question 1.
The document mentions that Sunsama's source code will be found in `/Users/sunsamaguest/sunsamadev/meteor` and asks me to create my own branch. WIll this directory already be git init-ed and if so, will the dev branch exist yet?

#### Question 2.
I just wanted to confirm that the new branch's name should indeed be `experiment/hostile_takeover_by_{your_name}`. (Just want to make sure since it seems like a long name for a branch :))

## Section III
#### Question 1.
Is `calendars` a top-level field for every user in `main_db.users`? If not, where is it nested?

#### Question 2.
![Filter Panel Design Question](https://s3-us-west-1.amazonaws.com/sunsama-hiring/front-end-design-description.png)
Figure 1 shows two sub-calendars while Figure 2 shows four sub-calendars. I am just wondering whether there are some calendars that shouldn't be counted or whether they are just two different screenshots.

#### Question 3.
You mentioned in your doc that you need to
> "... add info/hint about where to start in the code base."
I was wondering whether these hints will be provided onsite or might be available on a more recent doc.

#### Question 4.
Is the entire user doc being pulled and stored in the state/store per teammate? (i.e. will each teammate's sub-calendar data be available in the store already?)
