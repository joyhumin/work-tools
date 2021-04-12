#! /bin/bash

###########Get lambda function and query the python runtime=2.7##############
find_old_python (){
    aws lambda list-functions --output text --query "Functions[?Runtime=='python2.7'].FunctionArn" --profile $1 --region $2
}

###########Get list of profiles##############
echo "Fetch the profiles of AWS account"
PROFILE_LIST=$(aws configure list-profiles)

##########Get list of regions###############
echo "Get list of regions of AWS"
REGION_LIST=$(aws ec2 describe-regions --output text | awk '{print $4}')


##########Prep##############
echo "Create the text file "
FILE="func_in_old_python.txt"
rm $FILE || echo "Create new txt file" && touch $FILE

# go through each profile list
for profile in $PROFILE_LIST
do
    # for each profile, go through all regions
    for region in $REGION_LIST
    do
        echo "$profile $region"
        find_old_python $profile $region | tee -a $FILE
    done
done

exit 0