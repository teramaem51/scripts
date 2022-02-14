#!/bin/bash


# Compress the cloud9 project into an archive and back it up to s3.



# Setting variables

DATE_STAMP=$(date '+%Y%m%d')
ARCHIVE_NAME="$C9_PROJECT"_"$DATE_STAMP.tar.gz"



# Archive project

echo -e "\nArchive the files under the directory $LOCAL_DIR/$C9_PROJECT_DIR/."
echo "Are you sure? (press Enter Key)"
read

tar -zcvf $ARCHIVE_NAME $LOCAL_DIR/$C9_PROJECT_DIR



# Backup to S3

ARCHIVE_PATH=$(find $HOME -name $ARCHIVE_NAME)

echo -e "\n\nStart the backup with the following settings.\n"
echo "Archive name: $ARCHIVE_PATH"
echo "Destination: $S3_PREFIX/$C9_PROJECT/"
echo "Are you sure? (press Enter Key)"
read

aws s3 cp $ARCHIVE_PATH "$S3_PREFIX/$C9_PROJECT/"



# Other

echo -e "\n\nRemove $ARCHIVE_NAME file. (press Enter Key)"
read

rm $ARCHIVE_PATH
echo -e "\n\n"
