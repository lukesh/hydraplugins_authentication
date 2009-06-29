package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;

	public interface IPrincipalDelegate
	{
		/**
		 * @return message of supplied user with no user roles if the role retrieval failed and user roles populated if it succeeded
		 */
		function retrieveRoles(user:IPrincipal):AsyncToken;
		
		/**
		 * @return message of supplied user with no data restrictions if the data restriction retrieval failed and data restrictions populated if it succeeded
		 */
		function retrieveDataRestrictions(user:IPrincipal):AsyncToken;
		
	}
}