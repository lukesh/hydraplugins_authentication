package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class Identity extends EventDispatcher implements IIdentity
	{
		public function Identity(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var _userId:String;
		
		public function get userId():String
		{
			return _userId;
		}
		
		public function set userId(value:String):void
		{
			_userId = value;
		}
		
		private var _displayName:String;
		
		[Bindable(event="displayNameChange")]
		public function get displayName():String
		{
			return _displayName;
		}
		
		public function set displayName(value:String):void
		{
			_displayName = value;
			this.dispatchEvent(new Event("displayNameChange"));
		}
		
		private var _attributes:Dictionary;
		
		public function get attributes():Dictionary
		{
			return _attributes;
		}
		
		public function set attributes(value:Dictionary):void
		{
			_attributes = value;
		}
		
		private var _isAuthenticated:Boolean = false;
		
		public function get isAuthenticated():Boolean
		{
			return _isAuthenticated;
		}
		
		public function set isAuthenticated(value:Boolean):void
		{
			_isAuthenticated = value;
		}

		public function getAttribute(attributeName:String):Object
		{
			return attributes[attributeName];
		}
		
		public function clear():void
		{
			_attributes = null;
			_displayName = null;
			_userId = null;
		}
	}
}