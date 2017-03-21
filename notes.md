# Sunsama Developer Assessment Notes
## by Tonia Hsia

### Section 1. Databases and Command Line Work
**Objectives**
* Comfort and familiarity with basic database operations: queries, updates, and aggregates.
* Comfort and familiarity using basic command line tools and the UNIX shell.

**Background Information**
* Sunsama uses MongoDB for its database.
* There are two databases:
  * "PROD\_MAIN" which is referred to as `main_db`.
    * Contains collections (and docs) updated at "user speed" e.g. users, templates, groups.
    * Basically _updates to these collections happen when a user takes an action e.g. clicks something._
  * "PORD\_ALT" which is referred to as `alt_db`.
    * Contains collections (and docs) that are updated at "machine speed" e.g. calendarEvents, recurringEvents, etc.
    * Basically, _updates to these collections happen via long running tasks e.g. syncing with every calendar event from a Google account._
