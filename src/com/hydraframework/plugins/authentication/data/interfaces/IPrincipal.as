/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	[Bindable]
	public interface IPrincipal extends IEventDispatcher
	{

		function set identity(value:IIdentity):void;
		function get identity():IIdentity;
		function set roles(value:ArrayCollection):void;
		function get roles():ArrayCollection;
		function set dataRestrictions(value:Dictionary):void;
		function get dataRestrictions():Dictionary;
		function set rolesLoaded(value:Boolean):void;
		function get rolesLoaded():Boolean;
		function set dataRestrictionsLoaded(value:Boolean):void;
		function get dataRestrictionsLoaded():Boolean;
		function set impersonated(value:Boolean):void;
		function get impersonated():Boolean;

		function isInRole(roleName:String):Boolean;
		function getDataRestrictionValues(dataRestrictionName:String):ArrayCollection;
		function clear():void;
	}
}