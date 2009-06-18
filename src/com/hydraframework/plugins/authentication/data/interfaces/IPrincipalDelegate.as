package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;

	public interface IPrincipalDelegate
	{
		/**
		 * @return message with null payload if the role retrieval failed and an ArrayCollection of roles payload if it succeeded
		 */
		function retrieveRoles():AsyncToken;
		
		/**
		 * @return message with null payload if the data restriction retrieval failed and a Dictionary of data restrictions and values payload if it succeeded
		 */
		function retrieveDataRestrictions():AsyncToken;
		
	}
}