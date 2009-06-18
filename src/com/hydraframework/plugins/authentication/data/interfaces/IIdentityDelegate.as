
package com.hydraframework.plugins.authentication.data.interfaces
{
	import mx.rpc.AsyncToken;
	
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	
	/**
	 * IIdentityDelegate specifies what needs to be implemented to support user login and impersonation 
	 */
	public interface IIdentityDelegate
	{
		/**
		 * 
		 * @return message with null payload if the user lookup failed and an an IIdentity payload if the user lookup succeeded
		 *  
		 * @see IIdentity
		 */
		function retrieveInformation(userId:String):AsyncToken;
		
		/**
		 * 
		 * @return message with null payload if the login attempt failed and an an IIdentity payload if the login attempt succeeded
		 *  
		 * @see IIdentity
		 */
		function login(loginInfo:ILoginInformation):AsyncToken;
		
		/**
		 * @return message with null payload
		 */
		function logout():AsyncToken;
	}
}