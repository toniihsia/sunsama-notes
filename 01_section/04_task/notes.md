### Notes
- "We want to quickly search for documents inside of `main_db.calendarEvents` based on an **exact match** to an invitee's name which can be found here: `inviteeList.name`."
  - Does every calendarEvent have an inviteeList?
  - Is the name describing the name of the inviteeList?
  - What is an example of an inviteeList name? (i.e. what is the purpose of having an inviteeList name?)


### General Approach to Task 4
1. `main_db.calendarEvents.createIndex( {inviteeList.name: 1})`
