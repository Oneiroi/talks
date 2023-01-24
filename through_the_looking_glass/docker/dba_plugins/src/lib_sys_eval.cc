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
/* END udf_exmaple.cc functions */ 
// Why the above ^ failing to get sys_eval symbols into .so this allows _something_ known to be valid to be used for comparrison and debugging.

extern "C" bool sys_eval_init(UDF_INIT *initid,UDF_ARGS *args,char *message) {
    strcpy(message, "eval the CMD passed here!");
    return true;
}

extern "C" void sys_eval_deinit(UDF_INIT *) {}

extern "C" char* sys_eval(UDF_INIT *, UDF_ARGS *args, char *result, unsigned long *length, char *is_null, char *error){
    FILE *pipe;
	char line[1024];
	unsigned long outlen, linelen;
    
    result = (char*)malloc(1);
	outlen = 0;

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
		result[outlen] = 0x00;
		*length = strlen(result);
	}

	return result;
}

