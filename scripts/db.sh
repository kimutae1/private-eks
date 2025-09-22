#!/bin/sh
#if [ $# -eq 0 ] ; then
if [ $# -lt 2 ] ; then
    echo "input arguments ex) ./mysql.sh app dev"
    exit 0
fi
echo "OK"
LIST_FILE=list.txt
inSVC=$1
inPRODUCT=$2
R=$(awk -v Tsvc="${inSVC}" -v tProduct="${inPRODUCT}"  '{if(index($1, Tsvc)!=0 && index($2, tProduct)!=0) print $0  }' list.txt)
mysqlhost=$(echo $R |awk '{print $4}' )
mysqlacc=$(echo $R |awk '{print $3}' )
mysqlpw=$(echo $R |awk '{print $5}' )
while (true) ; do
clear
echo '
1. list
2. connect
3. database list
q. quit
'
echo -n "sel num : "
read no
case $no in
  "1" )
        echo "show processlist;" | mysql -u${mysqlacc} -p"${mysqlpw}" -h ${mysqlhost}  ;;
  "2" )
    echo "######################################################################" &&
    echo "connect ${mysqlhost}"  &&
    echo "######################################################################" &&
     mysql -u${mysqlacc} -p"${mysqlpw}" -h ${mysqlhost}  ;;
  "3" )
        echo "show databases;" | mysql -u${mysqlacc} -p"${mysqlpw}" -h ${mysqlhost}  ;;
  "q" )
         exit 0 ;;
        esac
         exit 0
done
