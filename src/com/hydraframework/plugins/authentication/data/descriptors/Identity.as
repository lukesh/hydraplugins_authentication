/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.descriptors {
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class Identity extends EventDispatcher implements IIdentity {
		public function Identity() {
			super();
		}

		private var _userId:String;
		[Bindable(event="userIdChange")]
		public function set userId (value:String):void
		{
			if (value != _userId)
			{
				_userId = value;
				dispatchEvent (new Event ("userIdChange"));
			}
		}

		public function get userId ():String
		{
			return _userId;
		}

		private var _displayName:String;
		[Bindable(event="displayNameChange")]
		public function set displayName (value:String):void
		{
			if (value != _displayName)
			{
				_displayName = value;
				dispatchEvent (new Event ("displayNameChange"));
			}
		}

		public function get displayName ():String
		{
			return _displayName;
		}

		private var _attributes:Dictionary;
		[Bindable(event="attributesChange")]
		public function set attributes (value:Dictionary):void
		{
			if (value != _attributes)
			{
				_attributes = value;
				dispatchEvent (new Event ("attributesChange"));
			}
		}

		public function get attributes ():Dictionary
		{
			return _attributes;
		}

		private var _authenticated:Boolean;
		[Bindable(event="authenticatedChange")]
		public function set authenticated (value:Boolean):void
		{
			if (value != _authenticated)
			{
				_authenticated = value;
				dispatchEvent (new Event ("authenticatedChange"));
			}
		}

		public function get authenticated ():Boolean
		{
			return _authenticated;
		}

		public function getAttribute(attributeName:String):Object {
			return attributes[attributeName];
		}

		public function clear():void {
			attributes=null;
			displayName=null;
			userId=null;
			authenticated=false;
		}
	}
}