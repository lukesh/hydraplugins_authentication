/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.interfaces {
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	[Bindable]
	public interface IIdentity extends IEventDispatcher {

		function set userId(value:String):void;
		function get userId():String;
		function set displayName(value:String):void;
		function get displayName():String;
		function set attributes(value:Dictionary):void;
		function get attributes():Dictionary;
		function set authenticated(value:Boolean):void;
		function get authenticated():Boolean;

		function getAttribute(attribute:String):Object;
		function clear():void;
	}
}