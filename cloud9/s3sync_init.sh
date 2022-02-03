#!/bin/bash


# This is a script to set environment variables, etc. for backing up a cloud9 project to s3.
# After creating a new project, run it on the target instance.



# Initializing variables

if [ -z $PRIMARY_S3_BUCKET ];then
    echo -e "\nBackup destination bucket name (and press Enter Key): "
    echo "e.g. s3://example" && read PRIMARY_S3_BUCKET
    echo -e "\nAdd an environment variable to ~/.bashrc file with the following settings.\n"
    echo "export PRIMARY_S3_BUCKET=$PRIMARY_S3_BUCKET"
    echo 'Are you sure? (press Enter Key)'
    read
    echo -e "\n# Set environment variable for s3sync_* scripts\nexport PRIMARY_S3_BUCKET=$PRIMARY_S3_BUCKET\n" >> $HOME/.bashrc
    source $HOME/.bashrc
fi

S3_PREFIX_DEFAULT="$PRIMARY_S3_BUCKET/c9"
LOCAL_DIR_DEFAULT='s3'
C9_PROJECT_DIR="$C9_PROJECT"


# Setting environment variables

echo -e "\nBackup destination prefix (and press Enter Key): "
echo "e.g. $S3_PREFIX_DEFAULT" && read S3_PREFIX

if [ -z $S3_PREFIX ];then
    S3_PREFIX="$S3_PREFIX_DEFAULT"
fi

export S3_PREFIX


echo 'Base directory name (and press Enter Key): '
echo "e.g. $LOCAL_DIR_DEFAULT" && read LOCAL_DIR

if [ -z $LOCAL_DIR ];then
    LOCAL_DIR="$HOME/environment/$LOCAL_DIR_DEFAULT"
else
    LOCAL_DIR="$HOME/environment/$LOCAL_DIR"
fi

export LOCAL_DIR


export C9_PROJECT_DIR



# Create directory

if [ ! -d $LOCAL_DIR ];then
    mkdir $LOCAL_DIR
    echo -e "\nCreate $LOCAL_DIR directory."
fi

if [ ! -d $LOCAL_DIR/$C9_PROJECT_DIR ];then
    mkdir $LOCAL_DIR/$C9_PROJECT_DIR
    echo "Create $C9_PROJECT_DIR directory."
fi

if [ ! -d $HOME/environment/scripts ];then
    git clone https://github.com/teramaem51/scripts.git
    echo -e "\nCreate scripts directory."
fi



# Create default .s3sync_ignore file

if [ ! -f $LOCAL_DIR/.s3sync_ignore ];then
    touch $LOCAL_DIR/.s3sync_ignore
    echo '# Describe the target you want to ignore in the s3 sync command of aws cli.' > $LOCAL_DIR/.s3sync_ignore
    echo '# If it is a file name, prefix it with *.' >> $LOCAL_DIR/.s3sync_ignore
    echo '# If it is a directory name, prefix it with * and suffix it with /*.' >> $LOCAL_DIR/.s3sync_ignore
    echo -e "# Only # is supported for commenting out.\n\n\n" >> $LOCAL_DIR/.s3sync_ignore
    echo -e "*$C9_PROJECT_DIR/*\n" >> $LOCAL_DIR/.s3sync_ignore
    echo -e "\nCreate default .s3sync_ignore file."
fi



# Create useful link

if [ ! -f $LOCAL_DIR/$C9_PROJECT_DIR/s3sync_project ];then
    ln -fs $(find $HOME/environment/scripts -name "s3sync_project*") $LOCAL_DIR/$C9_PROJECT_DIR/s3sync_project
fi

cd $LOCAL_DIR/$C9_PROJECT_DIR/



# Other

echo -e "\n\nThe following information was successfully configured.\n"
export -p | grep -E "PRIMARY_S3_BUCKET|S3_PREFIX|LOCAL_DIR|C9_PROJECT_DIR"
echo -e "\n\n"
