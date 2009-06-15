package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

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
		
		private var _loginId:String;
		
		public function get loginId():String
		{
			return _loginId;
		}
		
		public function set loginId(value:String):void
		{
			_loginId = value;
		}
		
		private var _displayName:String;
		
		public function get displayName():String
		{
			return _displayName;
		}
		
		public function set displayName(value:String):void
		{
			_displayName = value;
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
		
		private var _loggedIn:Boolean = false;
		
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
		public function set loggedIn(value:Boolean):void
		{
			_loggedIn = value;
		}

		private var _roles:ArrayCollection;
		
		public function get roles():ArrayCollection
		{
			return _roles;
		}
		
		public function set roles(value:ArrayCollection):void
		{
			_roles = value;
		}
		
		private var _dataRestrictions:Dictionary;
		
		public function get dataRestrictions():Dictionary
		{
			return _dataRestrictions;
		}
		
		public function set dataRestrictions(value:Dictionary):void
		{
			_dataRestrictions = value;
		}
		
		public function isInRole(roleName:String):Boolean
		{
			if (roles.toArray().indexOf(roleName) != -1)
			{
				return true;
			}
			
			return false;
		}
		
		public function getDataRestrictionValues(restrictionName:String):ArrayCollection
		{
			return dataRestrictions[restrictionName];
		}
		
		public function getAttribute(attributeName:String):Object
		{
			return attributes[attributeName];
		}
		
		public function clear():void
		{
			_roles = null;
			_dataRestrictions = null;
			_attributes = null;
			_loginId = null;
			_displayName = null;
			_userId = null;
		}
	}
}