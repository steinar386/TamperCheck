<# 

.SYNOPSIS
Tool to validate if file content has been altered
.DESCRIPTION
During deployment - a MD5 value has to be determined, and added to the end of the filename with the separator '-'.
The actual file to validate - and the script with schedule and filename must be kept separate to protect the validation in the filename.
The script can be configured to stop on missing digital signature.
Use -verbose to see detailed information during runtime.

Install-File.msu -> Install-File-f673b5f942b26a558eb3605dfc9641c4.msu

.PARAMETER FileName
Specifies the file to validate

.INPUTS

.OUTPUTS

.EXAMPLE
PS> .\TamperCheck.ps1 .\Install-File-f673b5f942b26a558eb3605dfc9641c4.msu

.EXAMPLE
PS> .\TamperCheck.ps1 .\Install-File-f673b5f942b26a558eb3605dfc9641c4.msu -verbose

 
 #>

#Script Name : TamperCheck.ps1
#Creator : steinar.thorsen (at) outlook.com
#Date : 16th March, 2021
#Updated : 22nd March, 2021
#References : 
#Version : 0.1

#Parameters
param (
    [Parameter(Mandatory=$True, HelpMessage = "Enter file to be validated")]
    [string[]]
    $FileName
)

#Variables

# ** SecLevel 1 = Allow unsigned files
# ** SecLevel 2 = Halt on missing digital signature
$SecLevel=1

# ** Clearing variables for sanity
$f_md5=0
$f_md5value=0
$f_sig =""
$f_sigm =""

# ** Check that the file exist
if (Test-Path -Path $FileName -PathType Leaf) 
    {write-verbose "File Exist"}
    
    else 
    {write-host "Alert: File does not exist!";break}

# ** Check the Digital Signature of the file, validate with local certification store
# ** This will also allow for self signed certificates, if they are trusted by the validator
$f_sig=(Get-AuthenticodeSignature $FileName)|Select-Object -ExpandProperty Status

if ($f_sig-eq"UnknownError") 
    {write-host "Alert: No valid Digital Signature detected"; 
        $f_sigm=(Get-AuthenticodeSignature $FileName)|Select-Object -ExpandProperty StatusMessage
        write-verbose $f_sigm
        if($SecLevel-eq 2) {write-verbose "Security Level set to halt on invalid digital signature";break}
    }
    else 
    {if ($f_sig-eq"Valid") 
            {write-verbose "A valid Digital Signature detected"}
    }

# ** Get actual MD5 hash value from file
$f_md5value=(CertUtil -hashfile $FileName MD5)[1] -replace " ",""

# ** Get MD5 hash string from filename
# ** Remove file extension
$f_md5="$FileName".split('\.')[-2]
# ** Remove everything before the last dash
$f_md5=$f_md5 -creplace '(?s)^.*\-', ''
write-verbose "MD5 Hash $f_md5value"
write-verbose "MD5 Text $f_md5"
# ** Compare MD5 hash value and filename
if ($f_md5 -eq $f_md5value) 
        {write-verbose "Matching MD5"}
    else 
    {write-host "Alert: Failed MD5 check!";break}

write-host "I Would run "$FileName