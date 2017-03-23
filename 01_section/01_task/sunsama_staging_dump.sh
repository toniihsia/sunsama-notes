#!/bin/bash
#
# Tonia Hsia
# <tonia.hsia@gmail.com>
# March 20, 2017
#
# Dumps and restores all MongoDb databases on a given server.
#
### Set server settings.
APP_HOST="localhost" # ask Ashutosh about host name (not provided in docs)
APP_PORT="27000"
LOCAL_HOST="localhost"
LOCAL_PORT="27017"
USERNAME=""
PASSWORD=""
MAIN_DB="sift" #
ALT_DB="alt_data"
ADMIN="admin"


### Set where database backups will be stored.
BACKUP_PATH="~/MONGODUMP"

### Detect unix bin paths, (enter these manually if script fails to auto detect).
MONGO_DUMP_BIN_PATH="$(which mongodump)"
MONGO_RESTORE_BIN_PATH="$(which mongorestore)"
GZIP_BIN_PATH="$(which gzip)"

### Get date to use for backup directory; if no date given, default to today's date.
DEFAULT_DATE=`date +%m-%d-%Y` # defaults to current date in MM-DD-YYYY format
read -p "What name would you like to use for the directory? (Formatting: MM-DD-YYYY): " date
if [ -z "$date" ]; then
  DATE=$DEFAULT_DATE
else
  DATE=$date
fi

##################################################################################
# D U M P I N G     D A T A B A S E
##################################################################################
### Create BACKUP_PATH directory if it does not exist.
[ ! -d $BACKUP_PATH ] && mkdir -p $BACKUP_PATH || :

### Ensure directory exists before dumping to it.
if [ -d "$BACKUP_PATH" ]; then

  # Define backup directory for output.
	BACKUP_DIR="$BACKUP_PATH/staging-$DATE"

	echo; echo "=> Dumping Main and Alt DB: $APP_HOST:$APP_PORT"; echo -n '   ';

  # Dump main_db.
  $MONGO_DUMP_BIN_PATH --host $APP_HOST:$APP_PORT --username $USERNAME --password $PASSWORD --gzip --db $MAIN_DB --authenticationDatabase $ADMIN --out $BACKUP_DIR >> /dev/null

  # Dump alt_db.
  $MONGO_DUMP_BIN_PATH --host $APP_HOST:$APP_PORT --username $USERNAME --password $PASSWORD --gzip --db $ALT_DB --authenticationDatabase $ADMIN --out $BACKUP_DIR >> /dev/null
else
  echo; echo "=> The directory $BACKUP_PATH doesn't exist."; echo -n '   ';
fi

##################################################################################
# R E S T O R I N G    D A T A B A S E
##################################################################################
### Check to see if databases were dumped correctly.
if [ -d "$BACKUP_DIR" ]; then
  echo; echo "=> Dumping of Main and Alt DB was successful!"; echo -n '   ';
  echo; echo "=> Restoring Main and Alt DB: $LOCAL_HOST:$LOCAL_PORT"; echo -n '   ';

  # Define db names.
  # Restore the dump of `main_db` into localhost Mongo.
  $MONGO_RESTORE_BIN_PATH --noIndexRestore --host $LOCAL_HOST --db $MAIN_DB_RESTORE --port $LOCAL_PORT --gzip "$BACKUP_DIR/sift"

  # Restore the dump of `alt_db` into localhost Mongo.
  $MONGO_RESTORE_BIN_PATH --noIndexRestore --host $LOCAL_HOST --db $ALT_DB_RESTORE --port $LOCAL_PORT --gzip "$BACKUP_DIR/alt_data"

  echo; echo "=> Main and Alt DB have been restored successfully!"; echo -n '   ';
else
  echo; echo "=> Main and Alt DB could not be restored."; echo -n '   ';
fi
