#!/bin/sh
#if [ $# -eq 0 ] ; then
if [ $# -lt 2 ] ; then
    echo "input arguments ex) ./pg.sh app dev"
    exit 0
fi
echo "OK"
LIST_FILE=list.txt
inSVC=$1
inPRODUCT=$2
R=$(awk -v Tsvc="${inSVC}" -v tProduct="${inPRODUCT}"  '{if(index($1, Tsvc)!=0 && index($2, tProduct)!=0) print $0  }' list.txt)
pghost=$(echo $R |awk '{print $4}' )
pgacc=$(echo $R |awk '{print $3}' )
pgpw=$(echo $R |awk '{print $5}' )
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
         PGPASSWORD=${pgpw} psql -U ${pgacc} -h ${pghost}  --d postgres -c 'select * from pg_stat_activity;';;
  "2" )
    echo "######################################################################" &&
    echo "connect ${pghost}"  &&
    echo "######################################################################" &&
     PGPASSWORD=${pgpw} psql -U ${pgacc} -h ${pghost}  --d postgres  ;;
  "3" )
        PGPASSWORD=${pgpw} psql -U ${pgacc} -h ${pghost}  --d postgres -c 'SELECT * FROM pg_catalog.pg_tables'  ;;
  "q" )
         exit 0 ;;
        esac
         exit 0
done

#PGPASSWORD=lM8dZpVvYa1EKe87qsMx psql -U dbadmin -h rds-pgsql-dev-kstadium-main.cluster-cysgddip6ijs.ap-northeast-2.rds.amazonaws.com -d postgres
