#!/bin/ksh 

# write by : maintiendrai@gmail.com
# version  : 1.0
# date     : 2014-10-22


#
#   ------------------------------------------
#           Global Variables
#   ------------------------------------------
#

function init 
{
    WEB_AUTH_URL="http://192.168.9.19/smp/webauthservlet"
    NAS_IP="10.10.30.1"
}


function digest
{
    print "**************************initial start**************************"

    if [[ $1 == "login" ]];then 
        KIND="preLogin"
    elif [[ $1 == "logout" ]];then
        KIND="logout"
    else 
        print "Syntax error, error argument"
        show_syntax
    fi

    USERID=`print $2 | awk '{split($0,a,":"); print a[1]}'`
    USERIP=`print $2 | awk '{split($0,a,"@"); print a[2]}'`
    
    if [[ $KIND == "preLogin" ]];then
        PASSWORD=`print $2 | awk '{split($0,a,":|@"); print a[2]}'`
    fi

    excute
}

function show_syntax
{
    print "./starnet_auth.sh <action> <username>:<password>@<userip> "
    exit 0
}


#
#   excute function
#
function excute
{
    if [[ $KIND == "preLogin" ]];then
        print "**************************login**************************"
        
        print "curl -i POST -H "'Content-type':'application/x-www-form-urlencoded'" -d \
             'kind=$KIND&userIp=$USERIP&nasIp=$NAS_IP&userId=$USERID&password=$PASSWORD' $WEB_AUTH_URL"
        
        curl -i POST -H "'Content-type':'application/x-www-form-urlencoded'" -d \
                "kind=$KIND&userIp=$USERIP&nasIp=$NAS_IP&userId=$USERID&password=$PASSWORD" $WEB_AUTH_URL
    elif [[ $KIND == "logout" ]];then
        print "**************************logout**************************"

        print "curl -i POST -H "'Content-type':'application/x-www-form-urlencoded'" -d \
             'kind=$KIND&userIp=$USERIP&nasIp=$NAS_IP&userId=$USERID' $WEB_AUTH_URL"

        curl -i POST -H "'Content-type':'application/x-www-form-urlencoded'" -d \
                "kind=$KIND&userIp=$USERIP&nasIp=$NAS_IP&userId=$USERID" $WEB_AUTH_URL 
    fi
}


#
#------------------------------------------
#           code start                    #
#------------------------------------------
#

init 

SHELL_FILE=$0

digest $@

exit 0
