/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.interfaces {
	import com.hydraframework.core.registries.delegate.interfaces.IDelegate;

	import mx.rpc.AsyncToken;

	/**
	 * IIdentityDelegate specifies what needs to be implemented to support user login and impersonation
	 */
	public interface IIdentityDelegate extends IDelegate {
		/**
		 *
		 * @return message with null payload if the user lookup failed and an an IIdentity payload if the user lookup succeeded
		 *
		 * @see IIdentity
		 */
		function retrieveInformation(userId:String):void;

		/**
		 *
		 * @return message with null payload if the login attempt failed and an an IIdentity payload if the login attempt succeeded
		 *
		 * @see IIdentity
		 */
		function login(loginInfo:ILoginInformation):void;

		/**
		 * @return message with null payload
		 */
		function logout():void;
		
		/**
		 * @return recordFactory that will create the appropriate Identity class for this implementation
		 */
		 function get recordFactory():Function;
	}
}