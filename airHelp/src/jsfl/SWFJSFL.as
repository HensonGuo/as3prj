//****************************************************************************** 
// swfJSFL	ver1.3
// Copyright(C) 2009 Hiiragi, all rights reserved. 
// 
// IntroduceSite : http://www.libspark.org/wiki/swfJSFL
// AuthorSite : http://melancholy.raindrop.jp/wordpress/
//  
//  
// Licensed under the MIT License 
//****************************************************************************** 

package jsfl {
	import adobe.utils.MMExecute;
	
	public class SWFJSFL {
		
		public static const URI_COMMANDS:String = "Commands/";
		public static const URI_JS:String = "Javascript/";
		public static const URI_PANEL:String = "WindowSWF/";
		
		private var _exist:Boolean;	//指定したJSFLファイルが存在するか
		
		private var _targetURI:String;	//JSFLのURI(file:///～)
		private var _targetFilePath:String	//JSFLのFilePath(C:\～)
		
		private var _targetDir:String;	//ディレクトリ名
		private var _targetFile:String;	//ファイル名
		
		private var _debugMode:Boolean = false;
		
		//Constructor
		public function SWFJSFL(targetDirectory:String, targetFile:String) {
			_targetDir = targetDirectory;
			_targetFile = targetFile;
			
			getURI();
			URItoPath();
			existCheck();
		}
		
		
		
		
		//Method
		//Private
		private function getURI():void {
			var configURI:String = MMExecute("fl.configURI");
			_targetURI = configURI + _targetDir + _targetFile;
		}
		
		private function URItoPath():void {
			var str:String = _targetURI;
			str = str.replace(/^file:\/\/\/([A-Z])\|(.*\/)/,"$1:$2");
			str = str.replace(/\//g,"\\\\");
			_targetFilePath = str;
		}
		
		
		private function existCheck():void {
			var str:String = "fl.fileExists('" + _targetURI + "')";
			var resultStr:String = MMExecute(str);
			
			(resultStr == "true") ? _exist = true : _exist = false;
			
			if (resultStr == "false") throwError(_targetURI + "が存在しません。");
		}
		
		private function throwError(str:String):void 
		{
			JSFL.trace(str);
			throw new Error(str);
		}
		
		
		
		//Public
		public function run(funcName:String = null, ...rest):String {
			
			if (_exist) {
				var str:String = "";
				
				if (funcName == null) {
					str = "fl.runScript('" + _targetURI + "');"
					if (_debugMode) JSFL.trace(str);
					MMExecute(str);
					
				} else {
					var arg:String = "";
					for each (var element:* in rest) {
						arg += ",'" + JSFL.stringReplace(element) + "'";
					}
					
					 str = "fl.runScript('" + _targetURI + "','" + funcName + "'" + arg + ");";
					
					if (_debugMode) 
						JSFL.trace(str);
					var resultStr:String = MMExecute(str);
					return resultStr;
				}

			} else {
				throwError("swfJSFL.run Error : \n\t" + _targetFile +"が存在していないため、メソッドを使用することができません。");
			}
			
			return null;
		}
		
		
		
		
		//getter/setter
		public function get debugMode():Boolean {
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void {
			_debugMode = value;
		}
		
		public function get targetURI():String {
			return _targetURI;
		}
		
		public function get targetFilePath():String {
			return _targetFilePath;
		}
		
		public function get exist():Boolean { return _exist; }
		
	}
}