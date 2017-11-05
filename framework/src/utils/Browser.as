package utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	/**
	 * 浏览器工具类 
	 * @author jianglang
	 * 
	 */	
	public class Browser
	{
//		[Embed(source = "Browser.js",mimeType="application/octet-stream")]
		
		public function Browser()
		{
			
		}
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public static function get url():String
		{
			if (!ExternalInterface.available) 
				return null;
			try
			{
				return ExternalInterface.call("Browser.getURL");
			}
			catch(e:Error){}
			return "";
		}
		
		
		/**
		 * 浏览器除去参数后的地址
		 * @return 
		 * 
		 */        
		public function get baseUrl():String
		{
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = Browser.url;
			var p:int = url.indexOf("#");
			if (p>0)
				return url.substr(0,p - 1);
			else
				return url;
		}
		
		/**
		 * 浏览器标题
		 * @param v
		 * 
		 */        
		public static function set title(v:String):void
		{
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("Browser.setTitle",v);
			}
			catch(e:Error){}
		}
		
		public static function get title():String
		{
			if (!ExternalInterface.available) 
				return null;
			try
			{
				return ExternalInterface.call("Browser.getTitle");
			}
			catch(e:Error){}
			return "";
		}
		
		/**
		 * 跳转  _brank:新界面  _self：本界面跳转
		 * @param url
		 * @param target
		 * 
		 */		
		public static function navigateToUrl(url:String,target:String = "_blank"):void
		{
			if (url.substr(0,11) == "javascript:" && ExternalInterface.available)
			{
				var js:String = url.substr(11);
				if (url.indexOf("(") == -1 && url.indexOf(")") == -1)
					js += "()";
				try
				{
					ExternalInterface.call("eval",js);
				}
				catch(e:Error){}
			}
			else
			{
				navigateToURL(new URLRequest(url),target);
			}
		}
		
		
		/**
		 * 刷新当前页面 
		 * 
		 */		
		public static function reload():void
		{
			navigateToURL(new URLRequest("javascript:location.reload();"),"_self");
		}
		
		/**
		 * 调用js字符串 
		 * 
		 */		
		public static function asCallJsStr(jsStr:String):void
		{
			navigateToURL(new URLRequest(jsStr),"_self");
		}
		
		/**
		 * 调用js函数 
		 * @param jsFun
		 * 
		 */		
		public static function asCallJsFun(jsFun:String):Boolean
		{
			if (!ExternalInterface.available) 
				return false;
			try
			{
				ExternalInterface.call(jsFun);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 浏览器地址栏参数
		 * @param values
		 * 
		 */        
		public static function set urlVariables(values:URLVariables):void
		{
			if (!ExternalInterface.available) 
				return;
			
			var url:String = "";
			var para:String = values.toString();
			if (para.length>0)
				url += "#" + para;
			try
			{
				ExternalInterface.call("Browser.setUrlVariables",url);
			}
			catch(e:Error){}
		}
		
		public static function get urlVariables():URLVariables
		{
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = Browser.url;
			var p:int = url.indexOf("#");
			if (p>0)
				return new URLVariables(url.substr(p + 1));
			else
				return new URLVariables();
		}
	
		/**
		 * 加入收藏夹 
		 * @param url
		 * @param title
		 * 
		 */        
		public function addFavorite(title:String=null,url:String=null):void
		{
			if (!ExternalInterface.available) 
				return;
			
			if (!url) 
				url = Browser.url;    
			
			if (!title)
				title = Browser.title;
			
			try
			{
				ExternalInterface.call("Browser.addFavorite",url,title);
			}
			catch(e:Error)
			{
				
			}
		}
	
		/**
		 * 设为主页
		 * @param url
		 * 
		 */        
		public function setHomePage(url:String=null):void
		{
			if (!ExternalInterface.available) 
				return;
			
			if (!url)
				url = Browser.url;
			try
			{
				ExternalInterface.call("Browser.setHomePage",url);
			}
			catch(e:Error){}
		}
	
		/**
		 * 设置cookie
		 * 
		 * @param name           cookie名称
		 * @param value          cookie值
		 * @param expires        cookie过期时间
		 * @param security       是否加密
		 */
		public static function setCookie(name:String, value:String, expires:Date=null, security:Boolean=false):void
		{
			if (!ExternalInterface.available) 
				return;
			
			expires || (expires = new Date(new Date().time + (1000 * 86400 * 365)));
			try
			{
				ExternalInterface.call("Brower.setCookie",name,value,expires.time,security);
			}
			catch(e:Error){}
		}
	
	
		/**
		 * 读取cookie
		 * 
		 * @param name	cookie名称
		 * @return 
		 * 
		 */        
		public static function getCookie(name:String):String
		{
			if (!ExternalInterface.available) 
				return null;
			try
			{
				return ExternalInterface.call("Browser.getCookie",name);
			}
			catch(e:Error){}
			return "";
		}
	
		/**
		 * 在浏览器关闭时提供确认提示
		 * 
		 */
		public static function confirmClose(text:String = "确认退出？"):void
		{
			if (!ExternalInterface.available)
				return;
			
			if (text)
			{
				try
				{
					ExternalInterface.call("Browser.confirmClose",text);
				}
				catch(e:Error){}
			}	
			else
			{
				try
				{
					ExternalInterface.call("Browser.confirmClose");
				}
				catch(e:Error){}
			}
		}

		/**
		 * 弹出警示框
		 * @param text
		 * 
		 */
		public function alert(...params):void
		{
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("alert",params.toString());
			}
			catch(e:Error){}
		}
		
		/**
		 * 消除浏览器的滚动事件干扰 
		 * 
		 */
		public function disableScroll(objId:String = null):void
		{
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("Browser.disableScroll",objId);
			}
			catch(e:Error){}
		}
	
	
	}
}