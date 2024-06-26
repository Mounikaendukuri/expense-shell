#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"


VALIDATE() {

if [ $? -ne 0 ]
then
    echo -e " $2 is $R failure $N "
    exit 1
else
    echo -e " $2 is $G sucess $N"
fi
}

if [ $USERID -ne 0 ] 
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

# my root password

mysql -h db.mounikadaws.online -uroot -pExpenseApp@1 -e 'show databases'&>>$LOGFILE
if [ $? -ne 0 ]
then     
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting up the root password"
else
    echo "my sql password already setup"
fi





