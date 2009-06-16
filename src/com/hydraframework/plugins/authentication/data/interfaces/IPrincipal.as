package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	public interface IPrincipal
	{
		function get roles():ArrayCollection;
		function set roles(value:ArrayCollection):void;
		function get dataRestrictions():Dictionary;
		function set dataRestrictions(value:Dictionary):void;
		function get rolesLoaded():Boolean;
		function set rolesLoaded(value:Boolean):void;
		
		
		function get identity():IIdentity;
		function set identity(value:IIdentity):void;

		/* methods
		*/
		function isInRole(roleName:String):Boolean;
		function getDataRestrictionValues(restrictionName:String):ArrayCollection;
		function clear():void;
	}
}