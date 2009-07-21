/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
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
	}
}