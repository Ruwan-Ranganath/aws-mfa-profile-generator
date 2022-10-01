#! /bin/bash

awsprofile="MFA_AWS_PROFILE_NAME"
awsuserid="USER_ID"
mfaarn="AWS_MFA_ARN"

awssetup="aws configure set --profile $awsprofile"
profilearn="$mfaarn/$awsuserid"
 
if ! command -v aws &> /dev/null
then
    echo "aws cli could not be found"
    exit
else
    echo "aws cli installed"
    exit
fi


read -r -p "Enter Auth Code": stscode

mfakeys=$(aws sts get-session-token --serial-number ${profilearn} --token-code ${stscode} --output text)

$awssetup aws_access_key_id $(echo ${mfakeys} | cut -d " " -f 2)
$awssetup aws_secret_access_key $(echo ${mfakeys} | cut -d " " -f 4) 
$awssetup aws_session_token $(echo ${mfakeys} | cut -d " " -f 5)
echo "Access,Secret,MFA Configured"
