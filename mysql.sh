#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

echo "enter the root password :"
read $myroot_password

VALIDATE(){

if [ $? -ne 0 ]
then
    echo " -e $2 is $R failure $N "
    exit 1
else
    echo "-e $2 is $G sucess $N"
fi

}

if [ USERID -ne 0 ] 
then 
    echo "you are not the root user to run the script"
    exit 1
else
    echo "you are root user good to go"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql sever"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql service"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

#ExpenseApp@1 my root password

mysql_secure_installation --set-root-pass $myroot_password &>>$LOGFILE
VALIDATE $? "setting up the root password"





