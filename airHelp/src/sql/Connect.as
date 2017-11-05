package sql {
	import flash.data.*;
	import flash.events.*;
	import flash.filesystem.File;
	
	import sql.events.ConnectEvent;
	
	import utils.FormatDate;
		
	[Event(name="onCreateDataBase", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onCreateTable", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onInsertDataComplete", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onSelectComplete", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onSchema", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onError", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onSelectCountComplete", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="onSelectExecComplete", type="hcxm.air.sqlStr.events.ConnectEvent")]
	[Event(name="childAdd", type="mx.events.ChildExistenceChangedEvent")]

	public class Connect extends EventDispatcher implements IEventDispatcher {
		
		private var sqlConn:SQLConnection
		private var db:File		
		private var _dataBaseName:String;
		private var _tableName:String;
		private var _sqlStatement:SQLStatement
		private var _isEncry:Boolean=false;
		private var _encryptionKey:String
		/**
		 * 建立一个数据库
		 * @param	dataBaseName		数据库的名称
		 */
		public function Connect(sqlConn:SQLConnection, _db:File, isencry:Boolean=false,encryptionKey:String=null) {
			this.sqlConn =sqlConn;
			db= _db;
			_dataBaseName=_db.name;
			this._isEncry=isencry;
			this._encryptionKey=encryptionKey
			if(this.sqlConn.connected==false)
			{							
				
				sqlConn.addEventListener(SQLEvent.OPEN, onOpen)
				sqlConn.addEventListener(SQLErrorEvent.ERROR, onError);
				sqlConn.addEventListener(SQLEvent.SCHEMA,_onSCHEMA);
				
			}else
			{
				//loadSchema();
			}		
			
		}
		public function createDB():void
		{
			//数据库存放在－C:\Documents and Settings\用户\Application Data\
			if(sqlConn.connected)return;
			sqlConn.openAsync(db);
			
		}
		
		private function onOpen(e:SQLEvent):void {
			//loadSchema();
			dispatchEvent(new ConnectEvent("onCreateDataBase"))	
		}		
		public function loadSchema():void
		{
			sqlConn.loadSchema();
		}
		private function onError(e:SQLErrorEvent):void {
			dispatchEvent(new ConnectEvent("onError",e));
		}
		/**
		 * 建立一个表
		 * @param	name	表的名称
		 * @param	str	表的字段定义
		 */
		public function createTable(name:String, str:String):void
		{
			
			if(name=="")
			{
				
			}else
			{
				_tableName = name;
			}

			var createStm:SQLStatement = new SQLStatement();
			createStm.sqlConnection = sqlConn;
			var sqlStr:String =  "CREATE TABLE IF NOT EXISTS " + _tableName + " ("+str+ ")";
			createStm.text = sqlStr;
			
			createStm.addEventListener(SQLEvent.RESULT, onResult);
			createStm.addEventListener(SQLErrorEvent.ERROR, onERRORStm);
			createStm.execute();
		}
		
		private function onResult(e:SQLEvent):void {
			trace("表	"+tableName+" 建立成功");
			dispatchEvent(new ConnectEvent(ConnectEvent.ON_CREATE_TABLE))
		
		}
		
		private function onERRORStm(e:SQLErrorEvent):void {
			trace("建立表失败")
			trace( "e : " + e );
			
		}
		/**
		 * 插入数据
		 * @param	ar1	表中的字段
		 * @param	ar2	对应字段的值
		 */
		public function insertData(ar1:Array,ar2:Array):void
		{
			var createStm:SQLStatement = new SQLStatement();
			createStm.sqlConnection = sqlConn;
			var temarr:Array=ar1;
			var s1:String = ar1.join(",");
			//trace( "s1 : " + s1 );
			
			var s2:String =":"+temarr[0];	
			temarr[0]=s2;		
			for(var i:int=1;i<temarr.length;i++)
			{
				s2+=", :"+temarr[i];
				temarr[i]= ":"+temarr[i];
			}
			
			var sqlStr:String = "INSERT INTO " + tableName + " (" + s1 +") VALUES (" + s2 + ")";
			trace( "sqlStr : " + sqlStr );
			
		//	var sqlStr:String = "INSERT INTO employees (firstName, lastName, salary) " + "VALUES ('Bob', 'Smith', 8000)";
			createStm.text = sqlStr;
			for(i=0;i<temarr.length;i++)
			{
				trace(temarr[i])
				createStm.parameters[temarr[i]]=ar2[i];
			}			
			createStm.execute();
			createStm.addEventListener(SQLEvent.RESULT, onResultInsert)			
			createStm.addEventListener(SQLErrorEvent.ERROR,_onError)
		}
		
		public function updateData(ar1:Array,ar2:Array,str:String):void
		{
			//UPDATE persondata SET
			var createStm:SQLStatement = new SQLStatement();
			createStm.sqlConnection = sqlConn;
			var s:String = " ";
			for (var i:int = 0; i < ar1.length; i++) {
				if (i != ar1.length - 1) {
					s += ar1[i] + "=" + ar2[i]+",";
				}else {
					s += ar1[i] + "=" + ar2[i]+"";
				}
				
			}
			var sqlStr:String = "UPDATE " + tableName+" SET" + s+" where "+str;
			trace( "sqlStr : " + sqlStr );
		//	var sqlStr:String = "INSERT INTO employees (firstName, lastName, salary) " + "VALUES ('Bob', 'Smith', 8000)";
			createStm.text = sqlStr;
			createStm.execute();
			createStm.addEventListener(SQLEvent.RESULT, onResultInsert)					
		}
		
		private function onSCHEMA(e:SQLEvent):void {
			for( var i:String in e ) trace( "key : " + i + ", value : " + e[ i ] );
			
		}
		
		private function onSqlSchema(e:SQLEvent):void 
		{
			for( var i:String in e ) trace( "key : " + i + ", value : " + e[ i ] );
		}
		
		private function onResultInsert(e:SQLEvent):void {
			trace( "插入成功e : " + e );
			dispatchEvent(new ConnectEvent("onInsertDataComplete"));
		}
		private function _onError(e:SQLErrorEvent):void
		{
			dispatchEvent(new ConnectEvent("onError",e));
		}
		/**
		 * 查询所有数据
		 */
		public function selectAll(str:String=null):void
		{

			var createStm:SQLStatement = new SQLStatement();
			//trace( "sqlConn : " + sqlConn.connected );
			
			createStm.sqlConnection = sqlConn;
			if(!str)
			{
				str='SELECT * FROM '+tableName
			}
			//var sqlStr:String = "SELECT * FROM employees";
			createStm.text =str;
			trace(str)
			createStm.execute();
			createStm.addEventListener(SQLEvent.RESULT, onResultSelect);	
		}
		/**
		 * 查询表中的记录总数
		 * */
		public function selectCount(str:String=null):void
		{

			var createStm:SQLStatement = new SQLStatement();
			//trace( "sqlConn : " + sqlConn.connected );
			
			createStm.sqlConnection = sqlConn;
			if(!str)
			{
				str='SELECT count(*) as count FROM '+tableName
			}
			//var sqlStr:String = "SELECT * FROM employees";
			trace(str)
			createStm.text =str;
		
			createStm.execute();
			createStm.addEventListener(SQLEvent.RESULT, onResultSelectCount);	
		}
		/**
		 * 模糊查询
		 * */
		public function selectLike(str:String):void
		{
			var sqlsment:SQLStatement = new SQLStatement();
			sqlsment.sqlConnection = sqlConn;
			var sqlStr:String="select * from "+this.tableName+" where message like :str"
			
			sqlsment.text =sqlStr;	
			sqlsment.parameters[":str"]="%"+str+"%"
			trace(sqlsment.text );
			sqlsment.execute();
			sqlsment.addEventListener(SQLEvent.RESULT, onResultselectLike);	
		//	sqlsment.addEventListener(SQLErrorEvent.ERROR,_onError1)		
		}
		/**
		 * 自定义语句
		 * */
		 public function exec(sqlStr:String):void
		 {
			var sqlsment:SQLStatement = new SQLStatement();
			sqlsment.sqlConnection = sqlConn;
			sqlsment.text =sqlStr;
			sqlsment.execute();
			sqlsment.addEventListener(SQLEvent.RESULT, onResultexec);
		 }
		 private function onResultexec(e:SQLEvent):void
		 {
		 	var result:SQLResult = e.target.getResult();
		 	dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_EXEC_COMPLETE,result.data,true));
		 }
		 /**
		 * 根据时间来搜索，
		 * */
		 public function selectFromDate(filed:String,data:Date):void
		 {
		 	var sqlStr:String="select * from "+tableName+" where strftime('%Y-%m-%d',"+filed+")='"+FormatDate.formatTime(data)+"'";
			var sqlsment:SQLStatement = new SQLStatement();
			sqlsment.sqlConnection = sqlConn;
			sqlsment.text =sqlStr;
			sqlsment.execute();
			sqlsment.addEventListener(SQLEvent.RESULT, onResultexec);
		 }
		 /* private function onResultexec(e:SQLEvent):void
		 {
		 	var result:SQLResult = e.target.getResult();
		 	dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_EXEC_COMPLETE,result.data,true));
		 } */
		private function _onError1(e:SQLEvent):void
		{
			
		}
		private function onResultselectLike(e:SQLEvent):void
		{
			var result:SQLResult = e.target.getResult();
			if (result.data != null) {
			
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COMPLETE, result.data, true))				
			}else {
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COMPLETE, [null], true))
			}			
		}
		
		private function onResultSelect(e:SQLEvent):void {
			
			var result:SQLResult = e.target.getResult();
			
			if (result.data != null) {
			
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COMPLETE, result.data, true))				
			}else {
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COMPLETE, [null], true))
			}
			//trace( "result : " + result.rowsAffected );	
			//sqlConn.close()
		}
		private function onResultSelectCount(e:SQLEvent):void {
			
			var result:SQLResult = e.target.getResult();
			
			if (result.data != null) {
			
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COUNT_COMPLETE, result.data, true))				
			}else {
				dispatchEvent(new ConnectEvent(ConnectEvent.ON_SELECT_COUNT_COMPLETE, [null], true))
			}
			//trace( "result : " + result.rowsAffected );	
			//sqlConn.close()
		}
		private function _onSCHEMA(e:SQLEvent):void
		{
			var sqlre:SQLSchemaResult=sqlConn.getSchemaResult();
			dispatchEvent(new ConnectEvent("onSchema",sqlre));
		}
		
		public function get conn():SQLConnection {
			return sqlConn;
		}
		public function get dataBaseName():String {
			return _dataBaseName;
		}

		public function get tableName():String {
			return _tableName;
		}
		public function set tableName(value:String):void {
			//把	.	转为 _
			var reg:RegExp=/[.@]/g;
			var s:Boolean=reg.test(value);
			if(s)
			{
				value=value.replace(reg,"_")
			}
			_tableName = value;
		}
		public function remove():void
		{
			//this=null;
			//sqlConn.close();
		}
		
	}
	
}