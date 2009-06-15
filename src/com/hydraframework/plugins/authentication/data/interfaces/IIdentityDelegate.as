package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;
	
	public interface IIdentityDelegate
	{
		function login(password:String):AsyncToken;
		function logout():AsyncToken;
		function retrieveRoles():AsyncToken;
		function retrieveInformation():AsyncToken;
		function retrieveDataRestrictions():AsyncToken;
	}
}