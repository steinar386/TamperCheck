#!/bin/bash

# .SYNOPSIS
# Tool to validate if file content has been altered
# .DESCRIPTION
# During deployment - a MD5 value has to be determined, and added to the end of the filename with the separator -.
# The actual file to validate - and the script with schedule and filename must be kept separate to protect the validation in the filename.
# The script can be configured to stop on missing digital signature.
# Use -verbose to see detailed information during runtime.
#
# Install-File.msu -> Install-File-f673b5f942b26a558eb3605dfc9641c4.msu
#
# .PARAMETER FileName
# Specifies the file to validate
#
# .INPUTS
#
# .OUTPUTS
#
# .EXAMPLE
# sh .\TamperCheck.sh .\Install-File-f673b5f942b26a558eb3605dfc9641c4.msu
#
# .EXAMPLE
# sh -x .\TamperCheck.sh .\Install-File-f673b5f942b26a558eb3605dfc9641c4.msu
#
# Script Name : TamperCheck.sh
# Creator : steinar.thorsen (at) outlook.com
# Date : 16th March, 2021
# Updated : 22nd March, 2021
# References :
# Version : 0.1

# ** Check that the file exists
if [ ! -f $1 ]; then echo "Alert: File does not exist!"; exit 1; fi;
# ** Get MD5 hash string from filename
F_MD5=$1
F_MD5="${F_MD5%%.*}"
F_MD5="${F_MD5##*-}"
# echo $F_MD5;
# ** Get actual MD5 hash value from file
F_MD5VALUE=$(md5sum $1)
F_MD5VALUE="${F_MD5VALUE%% *}"
# echo $F_MD5VALUE;
# ** Compare MD5 hash value and filename
if [ "$F_MD5" != "$F_MD5VALUE" ]; then echo "Alert: Failed MD5 check!"; exit 1; fi;
echo "I would run "$1
