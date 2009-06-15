package com.hydraframework.plugins.authentication.data.interfaces
{
	public interface ILoginInformation
	{
		function get loginId():String;
		function set loginId(value:String):void;
		function get password():String;
		function set password(value:String):void;
	}
}