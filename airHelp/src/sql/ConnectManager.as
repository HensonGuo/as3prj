package sql
{
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	
	public class ConnectManager
	{
		private  var _conn:SQLConnection;
		private var _connect:Connect
		private static var _instace:ConnectManager;
		private var _dbFile:File;
		public function ConnectManager()
		{
			
		}
		public static function getInstance():ConnectManager
		{
			if(!_instace){_instace=new ConnectManager()}
			return _instace;
		}
		public function set dbFile(location:File):void
		{
			_dbFile=location;
		}
		public function get dbFile():File
		{
			return _dbFile
		}
		
		public function getConnection():SQLConnection
		{
			if(_dbFile==null)
			{
				throw new Error('必须先设定数据库文件');
				return;
			}
			
			if(_conn==null)
			{
				_conn=new SQLConnection();
				
			}
			return _conn;
		}
		public function getConnect():Connect
		{
			if (_connect == null)
			{
				_connect = new Connect(getConnection(), _dbFile);
			}
			return _connect;
		}
		
		public function get isOpen():Boolean
		{
			return _conn.connected;
		}
	}
}