/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.securitycontext.interfaces
{
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public interface ISecurityContext extends IEventDispatcher
	{

		// Implement private/protected setter function to enable databinding
		[Bindable(event="currentUserChange")]
		function get currentUser():IPrincipal;
		// Implement private/protected setter function to enable databinding
		[Bindable(event="impersonatorChange")]
		function get impersonator():IPrincipal;
		// Implement private/protected setter function to enable databinding
		[Bindable(event="identityChange")]
		function get identity():IIdentity;
		// Implement private/protected setter function to enable databinding
		[Bindable(event="authenticatedChange")]
		function get authenticated():Boolean;

		function login(loginInfo:LoginInformation):void;
		function logout():void;
		function isInRole(roleName:String):Boolean;
		function hasDataRestrictions(dataRestrictionName:String):ArrayCollection;
		function beginImpersonation(newUserId:String):void;
		function endImpersonation():void;
	}
}