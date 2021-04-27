#! /bin/bash

#####Lamda function query using AWS CLI
find_target_lambda(){
    target_lambda=$(aws lambda get-function --function-name "Avid-VPC-LOGS-function" --query "Configuration.FunctionArn" --output text --profile $1 --region $2)
    echo "$1 $2 $target_lambda"
}

#######################
#   Get list of profiles
########################
echo "Fetch the profiles of AWS account"
PROFILE_LIST=$(aws configure list-profiles)

echo "Create the text file "
FILE="sophos_function_list.txt"
rm $FILE || echo "Create new txt file" && touch $FILE

##########Get list of regions###############
echo "Get list of regions of AWS"
REGION_LIST=$(aws ec2 describe-regions --output text | awk '{print $4}')

for profile in $PROFILE_LIST
do
    for region in $REGION_LIST
    do
        echo "searching lambda function for $profile in region $region"
        find_target_lambda $profile $region | tee -a $FILE
    done
done