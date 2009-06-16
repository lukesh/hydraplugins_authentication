package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;
	
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	
	public interface IIdentityDelegate
	{
		function retrieveInformation(userId:String):AsyncToken;
		function login(loginInfo:ILoginInformation):AsyncToken;
		function logout():AsyncToken;
	}
}