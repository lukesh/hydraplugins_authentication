package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public interface IIdentity
	{
		function get userId():String;
		function set userId(value:String):void;
		function get displayName():String;
		function set displayName(value:String):void;
		function get attributes():Dictionary;
		function set attributes(value:Dictionary):void;
		function get isAuthenticated():Boolean;
		function set isAuthenticated(value:Boolean):void;
				
		/* any other core attributes that would be common across hydra apps? */
		
		function getAttribute(attributeName:String):Object;
		function clear():void;
	}
}