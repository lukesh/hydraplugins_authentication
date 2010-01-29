/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.interfaces {
	import com.hydraframework.core.registries.delegate.interfaces.IDelegate;

	import mx.rpc.AsyncToken;

	public interface IPrincipalDelegate extends IDelegate {
		/**
		 * @return message of supplied user with no user roles if the role retrieval failed and user roles populated if it succeeded
		 */
		function retrieveRoles(user:IPrincipal):void;

		/**
		 * @return message of supplied user with no data restrictions if the data restriction retrieval failed and data restrictions populated if it succeeded
		 */
		function retrieveDataRestrictions(user:IPrincipal):void;

		/**
		 * @return recordFactory that will create the appropriate Principal class for this implementation
		 */
		 function get recordFactory():Function;
	}
}