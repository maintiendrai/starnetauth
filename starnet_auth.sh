#!/bin/ksh 

#  Copyright (c) starnet_auth.sh : maintiendrai@gmail.com
#  version  : 1.0
#  date     : 2014-10-22
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#

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
