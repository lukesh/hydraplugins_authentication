package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;

	public interface IPrincipalDelegate
	{
		function retrieveRoles():AsyncToken;
		function retrieveDataRestrictions():AsyncToken;
		
	}
}