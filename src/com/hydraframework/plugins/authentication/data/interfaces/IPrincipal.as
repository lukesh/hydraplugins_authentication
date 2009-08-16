package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public interface IPrincipal extends IEventDispatcher
	{

		[Bindable(event="identityChange")]
		function set identity (value:IIdentity):void;
		function get identity ():IIdentity;
		[Bindable(event="rolesChange")]
		function set roles (value:ArrayCollection):void;
		function get roles ():ArrayCollection;
		[Bindable(event="dataRestrictionsChange")]
		function set dataRestrictions (value:Dictionary):void;
		function get dataRestrictions ():Dictionary;
		[Bindable(event="rolesLoadedChange")]
		function set rolesLoaded (value:Boolean):void;
		function get rolesLoaded ():Boolean;
		[Bindable(event="dataRestrictionsLoadedChange")]
		function set dataRestrictionsLoaded (value:Boolean):void;
		function get dataRestrictionsLoaded ():Boolean;
		[Bindable(event="impersonatedChange")]
		function set impersonated (value:Boolean):void;
		function get impersonated ():Boolean;
		
		function isInRole(roleName:String):Boolean;
		function getDataRestrictionValues(dataRestrictionName:String):ArrayCollection;
		function clear():void;
	}
}