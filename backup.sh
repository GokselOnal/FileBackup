#!/bin/bash

if [ $# != 2 ]
then
  echo "Invalid argument provided\nPlease give 2 directory names as agruments"
  echo "Exp: backup.sh target_directory_name destination_directory_name"
  exit
fi

if [ ! -d $1 ] || [ ! -d $2 ]
then
  echo "Invalid directory path provided\nPlease give valid directory path"
  exit
fi

targetDirectory=$1
destinationDirectory=$2

echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

currentTS=$(date +%s)

backupFileName="backup-$currentTS.tar.gz"

origAbsPath=$(pwd)

cd $destinationDirectory
destDirAbsPath=$(pwd)

cd $origAbsPath
cd $targetDirectory

yesterdayTS=$(($currentTS + 24 * 60 * 60))

declare -a toBackup

for file in $(ls)
do
  file_last_modified_date=$(date -r $file +%s)
  if [ $file_last_modified_date > $yesterdayTS ]
  then
    toBackup+=($file)
  fi
done

tar -czvf $backupFileName ${toBackup[@]}
mv $backupFileName $destDirAbsPath


