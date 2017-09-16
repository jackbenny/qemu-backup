# What is it?
This is a simple Bash script I made to automatically backup my
virtual machines on my server. It's working really well for me,
but there is no guarantee it will work for you.
The script retains a set number of backups before starting to rotate.
The backups are named with a date and timestamp and the rotation-number.


# Usage
Replace the made-up names with the name, disktype and diskfile of your 
real virtual machines.

`NUMBACKUPS` decides how many backups should be retained. The file *rotate.txt*
keeps track of the rotation.

`VMDISKDIR` is the directory where the virtual machines are stored on the
server, not the backup dir.

Also make sure to check and/or change the directories to match your
machine.

Then simple put the script in a cronjob.
