# TamperCheck
Script tool for checking if a file has been tampered with since deployment.

SCENARIO
The aim of this tool - is to attempt to verify if the files has been modified in any way after the initial upload.

Install files and scripts are uploaded to a staging area which may have many contributors, this opens up the attack vector of bad actors altering installation files or scripts used in automated installations or processes. Making it possible to install malware and unwanted software.

This is a quick compare of file md5 hash to a stored hash - the hash is stored in the filename, as the scheduled/robotics script is not stored accessible to anyone except administrators.

ASSUMPTION
The robotic/scheduler which is used to run the installation files or scripts is not available to the same set of people.

PROCESS
Person 1 - calculates the MD5 sum of a file, changes the filename - and copies it to location where it should be launched.
Person 2 - Enters the verified filename, and enters that into the scheduler.

FORMAT
filename-<md5 hash>.extension
The text "-<md5 hash>" (with the leading dash) is what the script uses to pick the md5 hash from the filename. It will allow additional dashes earlier in the filename.

VERIFICATION
When the scheduler runs - it can initiate the automated installation with this script - verifying two things.

* Any Digital Signature is verified (that it is trusted by the installer robot). (Windows OS only)
* The md5 hash of the file is compared to the data stored in the filename.

CONFIGURATION
Changing the variable SecLevel to 2 will halt the execution if a Digital Signature can not be validated.

NOTE
The Digital Signature is verified as long as it is trusted by the robot, including self signed certificates.
This script is designed as portable and light-weight as possible, relying as little on external applications, databases or functionality as possible.
