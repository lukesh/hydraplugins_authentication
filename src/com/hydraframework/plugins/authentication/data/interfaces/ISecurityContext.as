package com.hydraframework.plugins.authentication.data.interfaces
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public interface ISecurityContext extends IEventDispatcher
	{

		[Bindable(event="currentUserChange")]
		function set currentUser(value:IPrincipal):void;
		function get currentUser():IPrincipal;
		[Bindable(event="impersonatorChange")]
		function set impersonator(value:IPrincipal):void;
		function get impersonator():IPrincipal;
		[Bindable(event="identityChange")]
		function set identity(value:IIdentity):void;
		function get identity():IIdentity;
		[Bindable(event="loggedOnChange")]
		function set loggedOn(value:Boolean):void;
		function get loggedOn():Boolean;

		function login(loginInfo:LoginInformation):void;
		function isInRole(roleName:String):Boolean;
		function hasDataRestrictions(dataRestrictionName:String):ArrayCollection;
		function beginImpersonation(newUserId:String):void;
		function endImpersonation():void;
	}
}