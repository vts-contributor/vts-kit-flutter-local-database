package com.viettel.vts_sqflite.operation;

import static com.viettel.vts_sqflite.Constant.PARAM_SQL;
import static com.viettel.vts_sqflite.Constant.PARAM_SQL_ARGUMENTS;

import com.viettel.vts_sqflite.SqlCommand;

import java.util.HashMap;
import java.util.Map;

public class SqlErrorInfo {

    static public Map<String, Object> getMap(Operation operation) {
        Map<String, Object> map = null;
        SqlCommand command = operation.getSqlCommand();
        if (command != null) {
            map = new HashMap<>();
            map.put(PARAM_SQL, command.getSql());
            map.put(PARAM_SQL_ARGUMENTS, command.getRawSqlArguments());
        }
        return map;
    }
}
