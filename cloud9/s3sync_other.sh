#!/bin/bash

# This script uses the blacklist method to back up everything except those set to ignore.

SYNC_IGNORE=$(sed '/^$/d; /#/d; s/^/--exclude "/g; s/$/"/g' < $LOCAL_DIR/.s3sync_ignore | sed -z 's/\n/ /g; s/ $//g')
eval "aws s3 sync $LOCAL_DIR $S3_PREFIX $SYNC_IGNORE --delete"
