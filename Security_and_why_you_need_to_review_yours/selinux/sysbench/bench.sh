sysbench --test=oltp --db-driver=mysql --mysql-db=test --mysql-user=root prepare
for threads in 1 2 4 8 16 32;
do
sysbench --test=oltp --db-driver=mysql --mysql-db=test --mysql-user=root \
--num-threads=$threads run > threads-${threads}.out
done
