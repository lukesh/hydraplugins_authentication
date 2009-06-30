package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class LoginInformation extends EventDispatcher implements ILoginInformation
	{
		public function LoginInformation(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var _loginId:String;
		
		public function get loginId():String
		{
			return _loginId;
		}
		
		public function set loginId(value:String):void
		{
			_loginId = value;
		}
		
		private var _password:String;
		
		public function get password():String
		{
			return _password;
		}
		
		public function set password(value:String):void
		{
			_password = value;
		}
	}
}