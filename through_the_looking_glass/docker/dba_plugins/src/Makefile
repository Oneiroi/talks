CFLAGS=$(mysql_config --cflags)
all:
	gcc -DMYSQL_DYNAMIC_PLUGIN ${CFLAGS} -fPIC -Wall  -shared -o lib_sys_eval.so lib_sys_eval.cc