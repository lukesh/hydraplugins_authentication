package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public interface IIdentity
	{
		function get userId():String;
		function set userId(value:String):void;
		function get loginId():String;
		function set loginId(value:String):void;
		function get displayName():String;
		function set displayName(value:String):void;
		function get attributes():Dictionary;
		function set attributes(value:Dictionary):void;
		function get loggedIn():Boolean;
		function set loggedIn(value:Boolean):void;
		function get roles():ArrayCollection;
		function set roles(value:ArrayCollection):void;
		function get dataRestrictions():Dictionary;
		function set dataRestrictions(value:Dictionary):void;
				
		/* any other core attributes that would be common across hydra apps? */
		
		function isInRole(roleName:String):Boolean;
		function getDataRestrictionValues(restrictionName:String):ArrayCollection;
		function getAttribute(attributeName:String):Object;
		function clear():void;
	}
}