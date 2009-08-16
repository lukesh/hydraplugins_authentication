package com.hydraframework.plugins.authentication.data.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public interface IIdentity extends IEventDispatcher
	{
		[Bindable(event="userIdChange")]
		function set userId (value:String):void;
		function get userId ():String;
		[Bindable(event="displayNameChange")]
		function set displayName (value:String):void;
		function get displayName ():String;
		[Bindable(event="attributesChange")]
		function set attributes (value:Dictionary):void;
		function get attributes ():Dictionary;
		[Bindable(event="authenticatedChange")]
		function set authenticated (value:Boolean):void;
		function get authenticated ():Boolean;

		
		function getAttribute(attribute:String):Object;
		function clear():void;
	}
}