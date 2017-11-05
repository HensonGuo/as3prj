/**
 * The SQLite Utility Class for ActionScript 3.0
 *
 * @author	Copyright (c) 2008 daoki2
 * @version	1.0.2
 * @link	http://snippets.libspark.org/
 * @link	http://homepage.mac.com/daoki2/
 *
 * Copyright (c) 2008 daoki2
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package utils {
    import flash.errors.IllegalOperationError;
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import flash.data.*;

	/**
	 * <span style="color:#FF0000; font-weight:bold;">(Flex Only)</span>
	 */
    public class SqlUtil {

       /**
        * Constructor
        */
        public function SqlUtil() {
            throw new IllegalOperationError("SqlUtil class can not create instance");
        }

       /**
        * Build Insert SQL Statement
        * @param	table	Table to insert data
        * @param	rows	Data to insert
        * @return		Insert SQL Statement
        */
        public static function buildInsert(table:String, rows:ArrayCollection):String {
            var sqlU:String = "INSERT INTO " + table + "(";
            for each(var val:* in rows)
                sqlU += val.column + ", ";
            sqlU = sqlU.substring(0, sqlU.length - 2);
            sqlU += ") VALUES (";
            for each(val in rows) {
                if (val.type == "TEXT") {
                    sqlU += "'";
                    if (val.value != null)
                        sqlU += val.value;
                    sqlU += "'";
                } else {
                    sqlU += val.value;
                }
                sqlU += ", ";
            }
            sqlU = sqlU.substring(0, sqlU.length - 2);
            sqlU += ")";
            return sqlU;
        }

       /**
        * Build Select All SQL Statement
        * @param	db	The SQLConnection of the specified DataBase
        * @param	table	Table to build the SQL statement
        * @return		Select All SQL Statement
        */
        static public function buildSelectAll(db:SQLConnection, table:String):String {
            var columns:ArrayCollection = getColumnDef(db, table);
            var sqlU:String = "SELECT ";
            for each(var val:* in columns)
                sqlU += val.name + ", ";
            sqlU = sqlU.substring(0, sqlU.length - 2);
            sqlU += " FROM " + table;
            return sqlU;
        }

       /**
        * Build Create Table SQL Statement
        * @param	db	The SQLConnection of the specified DataBase
        * @param	table	Table to build the SQL statement
        * @return		Create Table SQL Statement
        */
        static public function buildTableDefs(db:SQLConnection, table:String):Array {
            var result:Array = new Array();
            var sqlschema:SQLSchemaResult;
            try {
                db.loadSchema(SQLTableSchema, table);
                sqlschema = db.getSchemaResult();
                result.push(sqlschema.tables[0].sqlU);
                db.loadSchema(SQLIndexSchema, table);
                sqlschema = db.getSchemaResult();
                for each (var val:* in sqlschema.indices) {
                    result.push(val.sqlU);
                }
            } catch (err:Error) {
            }
            return result;
        }

       /**
        * Drop the specified index from the DataBase
        * @param	db		The SQLConnection of the specified DataBase
        * @param	index		The Index to drop from DataBase
        * @return	true/false	If it succed to drop the index	
        */
        static public function dropIndex(db:SQLConnection, index:String):Boolean {
            var result:Object;

            if (index == "" || index == null)
                return false;

            var sqlU:String = "DROP INDEX IF EXISTS " + index;

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:dropIndex");
            return result.status;
        }

       /**
        * Drop the specified table from the DataBase
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The Table to drop from DataBase
        * @return	true/false	If it succed to drop the table	
        */
        static public function dropTable(db:SQLConnection, table:String):Boolean {
            var result:Object;

            if (table == "" || table == null)
                return false;

            var sqlU:String = "DROP TABLE IF EXISTS " + table;

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:dropTable");
            return result.status;
        }

       /**
        * Create index of the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table to create index
        * @param	indexDefs	ArrayCollection of the index definition
        *				and it contains the following params.
        *                                - name   : Index name
        *				 - columns: The list of the column
        * @return	true/false	If it succeed to create the index
        */
        static public function createIndex(db:SQLConnection, table:String, indexDefs:ArrayCollection):Boolean {
            var result:Object;
            var lastResult:Boolean = true
            var sqlU:String = "";
            for each(var val:* in indexDefs) {
                sqlU = "CREATE INDEX IF NOT EXISTS " + val.name + " ON " + table + "(" + val.columns + ")";

                result = executeSQLStatement(db, sqlU);
                if (!result.status) {
                    Alert.show(result.message, "ERROR!:createIndex");
                    lastResult = false;
                }
            }
            return lastResult;
        }

       /**
        * Create table to the specified database
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table name
        * @param	tableDefs	ArrayCollection of the table definition
        *				and it contains the following params.
        *				 - name         : Column name
        *				 - type         : The data type of the column
        *				 - primaryKey   : If the column is primary key
        *				 - autoIncrement: If it will increment the value automatically
        *				 - allowNull    : If the column allows null value
        * @return	true/false	If it succeed to create the table
        */
        static public function createTable(db:SQLConnection, table:String, tableDefs:ArrayCollection):Boolean {
            var result:Object;
            var sqlU:String = "CREATE TABLE IF NOT EXISTS " + table + " (";
            for each(var val:* in tableDefs) {
                sqlU += val.name + " " + val.type;
                if (val.primaryKey)
                    sqlU += " " + "PRIMARY KEY";
                if (val.autoIncrement)
                    sqlU += " " + "AUTOINCREMENT";
                if (!val.allowNull)
                    sqlU += " " + "NOT NULL";
                sqlU += ", ";
            }
            sqlU = sqlU.substr(0, sqlU.length - 2);
            sqlU += ")";

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:createTable");

            return result.status;
        }

       /**
        * Delete row from the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table to delete the row
        * @param	keyColumn	The column name that specify the row
        * @param	keyValue	The column value that specify the row
        * @return	true/false	If it succeed to delete the row
        */
        static public function deleteRow(db:SQLConnection, table:String, keyColumn:String, keyValue:int):Boolean {
            var result:Object;
            var sqlU:String = "DELETE FROM " + table + " WHERE " + keyColumn + " = " + keyValue;

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:delete");
            return result.status;
        }

       /**
        * Check if the index exists in the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table if contains the index
        * @param	index		The index name to check
        * @return       true/false	If the index exists in the table
        */
        static public function existsIndex(db:SQLConnection, table:String, index:String):Boolean {
            var result:Boolean = false;
            var indexList:ArrayCollection = getIndexList(db, table);
            for each(var val:* in indexList) {
                if(val.name == index) {
                    result = true;
                    break;
                }
            }
            return result;
        }

       /**
        * Check if the table exists in the database
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table name to check
        * @return	true/false	If the table exists in the table
        */
        static public function existsTable(db:SQLConnection, table:String):Boolean {
            var result:Boolean = false;
            var tableList:Array = getTableList(db);
            for each(var val:* in tableList) {
                if(val == table) {
                    result = true;
                    break;
                }
            }
            return result;
        }

       /**
        * Get the columns definition of the specified table
        * @param	db	The SQLConnection of the specified DataBase
        * @param	table	The table name which you want the column defs
        * @return		The ArrayCollection of the columns definition
        * 			and it contains the following params
        * 			 - name         : Column name
        * 			 - type         : The Data type of the column
        * 			 - primaryKey   : If this column is primary key
        * 			 - autoIncrement: If this column increment automatically
        * 			 - allowNull    : If this column allow null value
        */
        static public function getColumnDef(db:SQLConnection, table:String):ArrayCollection {
            var result:ArrayCollection = new ArrayCollection();
            db.loadSchema(SQLTableSchema, table);
            var sqlschema:SQLSchemaResult = db.getSchemaResult();
            for each(var column:* in sqlschema.tables[0].columns)
                result.addItem({name:column.name, type:column.dataType, primaryKey:column.primaryKey,
                    autoIncrement:column.autoIncrement, allowNull:column.allowNull});
            return result;
        }

       /**
        * Get the Data & Column Defs of the table
        * @param	db	The SQLConnection of the specified DataBase
        * @param	sqlU	The SQL string
        * @return	result	The Array which contains column defs and data
        *			The following are the description
        *			 - result[0]: The Array of the columns name
        *			 - result[1]: The SQLResult of the sqlU which executed
        */
        static public function getData(db:SQLConnection, sqlU:String):Array {
            var result:Array = new Array();
            var columns:Array = getResultColumns(sqlU);
            var resultData:SQLResult = getResultData(db, sqlU);
            result.push(columns);
            result.push(resultData);
            return result;
        }

       /**
        * Get the index list of the specified table
        * @param	db	The SQLConnection of the specified DataBase
        * @param	table	The table to get the list of index
        * @return		The ArrayCollection of the index
        * 			and it contains the following params
        * 			 - name   : Index name
        * 			 - columns: The column list
        */
        static public function getIndexList(db:SQLConnection, table:String):ArrayCollection {
            var result:ArrayCollection = new ArrayCollection();
            try {
                db.loadSchema(SQLIndexSchema, table);
                var sqlschema:SQLSchemaResult = db.getSchemaResult();
                for each(var index:* in sqlschema.indices) {
                    if (table == null)
                        result.addItem({name: index.name, columns: ""});
                    else
                        result.addItem({name: index.name,
                               columns: index.sqlU.substring(index.sqlU.search("ON " + table)
                                            + table.length + 4, index.sqlU.length - 1)});
                }
            } catch (err:Error) {
                //Alert.show(err.toString(), "ERROR!:getIndexList");
            }
            return result;
        }

       /**
        * Get the row count of the table
        * @param	db	The SQLConnection of the specified DataBase
        * @param	table	The table name which you want to get the row count
        * @return		The row count of the table
        */
        static public function getRowCount(db:SQLConnection, table:String):uint {
            var sqlU:String = "select count(*) as count from " + table;
            var row:SQLResult = getResultData(db, sqlU);
            if (row != null)
                return row.data[0].count;
            return 0;
        }

       /**
        * Get the table list of the specified DataBase
        * @param	db	The SQLConnection of the specified DataBase
        * @return		The Array of the table name
        */ 
        static public function getTableList(db:SQLConnection):Array {
            var result:Array = new Array();
            try {
                db.loadSchema(SQLTableSchema);
                var sqlschema:SQLSchemaResult = db.getSchemaResult();
                for each(var table:* in sqlschema.tables)
                    result.push(SQLTableSchema(table).name);
            } catch (err:Error) {
                //Alert.show(err.toString(), "ERROR!");
            }
            return result;
        } 

       /**
        * Insert row to the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table to insert the data
        * @param	rows		The ArrayCollection of the data to insert
        *				and it contains the following params
        *				 - column: Column name 
        *				 - value : Column value
        *				 - type  : Data type of the column
        * @return	true/false	If it succeed to insert the row data
        */
        public static function insertRow(db:SQLConnection, table:String, rows:ArrayCollection):Boolean {
            var result:Object;
            var sqlU:String = buildInsert(table, rows);

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:insert");
            return result.status;
        }

       /**
        * Remove the whole data of the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table to remove the whole data
        * @parem	keyColumn	The column name of the primary key
        * @return	true/false	If it succed to trancate the table	
        */
        static public function trancateTable(db:SQLConnection, table:String, keyColumn:String):Boolean {
            var result:Object;

            if (table == "" || table == null || keyColumn == "" || keyColumn == null)
                return false;

            var sqlU:String = "DELETE FROM " + table + " WHERE " + keyColumn + " > 0";

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:trancateTable");
            return result.status;
        }

       /**
        * Update row of the specified table
        * @param	db		The SQLConnection of the specified DataBase
        * @param	table		The table to update the data
        * @param	keyColumn	The column name to specify the row
        * @param	keyValue	The column value to specify the row
        * @param	updateColumn	The column name to update
        * @param	updateValue	The column value to update
        * @param	updateType	The data type of the column to update
        * @return	true/false	If it succeed to update the row data
        */
        public static function updateRow(db:SQLConnection, table:String, keyColumn:String, keyValue:int,
                                   updateColumn:String, updateValue:String, updateType:String):Boolean {
            var result:Object;

            if (updateType == "TEXT")
                updateValue = "'" + updateValue + "'";

            var sqlU:String = "UPDATE " + table + " SET " + updateColumn + " = " + updateValue
                           + " WHERE " + keyColumn + " = " + keyValue;

            result = executeSQLStatement(db, sqlU);
            if (!result.status)
                Alert.show(result.message, "ERROR!:update");
            return result.status;
        }

       /**
        * private method
        */

       /**
        * Execute SQL statement
        */
        public static function executeSQLStatement(db:SQLConnection, sqlU:String):Object {
            var status:Boolean = true;
            var message:String = "";
            try {
                var stmt:SQLStatement = new SQLStatement;
                stmt.sqlConnection = db;
                stmt.text = sqlU;
                stmt.execute();
            } catch (err:Error) {
                status = false;
                message = err.toString();
            }
            return {status: status, message: message};
        }

       /**
        * Get the Columns of the Result set
        */
        private static function getResultColumns(sqlU:String):Array {
            var result:Array = new Array();
            var startIndex:Number = 0;
            var endIndex:Number = 0;

            var selectPos:Number = sqlU.toUpperCase().search("SELECT ");
            if (selectPos == -1)
                return null;

            var distinctPos:Number = sqlU.toUpperCase().search("DISTINCT ");
            if (distinctPos == -1)
                startIndex = selectPos + 7;
            else
                startIndex = distinctPos + 9;

            endIndex = sqlU.toUpperCase().search(" FROM");
            if (endIndex == -1)
                return null;

            var columns:String = sqlU.slice(startIndex, endIndex);

            var column:Array = columns.split(",");
            for each(var val:* in column) {
                startIndex = val.toUpperCase().search("AS ");
                if (startIndex == -1)
                    result.push(removeWhitespace(val));
                else
                    result.push(removeWhitespace(val.slice(startIndex + 3)));
            }
            return result;
        }

       /**
        * Get the Data of the Result set
        */
        private static function getResultData(db:SQLConnection, sqlU:String):SQLResult {
            var stmt:SQLStatement = new SQLStatement;
            stmt.sqlConnection = db;
            stmt.text = sqlU;
            try {
                stmt.execute();
                return stmt.getResult();
            } catch(err:Error) {
                Alert.show(err.toString(), "ERROR!:getResultData");
                //trace("getResultData:", sqlU);
                return null;
            }
            return null;
        }

       /**
        * Remove the white space from the string
        */
        private static function removeWhitespace(txt:String):String {
            var val:String = "";
            for (var i:int = 0; i < txt.length; i++)
                if (txt.charAt(i) != ' ')
                    val += txt.charAt(i);
            return val;
        }
    }
}