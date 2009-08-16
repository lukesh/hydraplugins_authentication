/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class Principal extends EventDispatcher implements IPrincipal
	{
		public function Principal()
		{
			super();
		}

		private var _identity:IIdentity;

		[Bindable(event="identityChange")]
		public function set identity(value:IIdentity):void
		{
			if (value != _identity)
			{
				_identity = value;
				dispatchEvent(new Event("identityChange"));
			}
		}

		public function get identity():IIdentity
		{
			return _identity;
		}

		private var _roles:ArrayCollection;

		[Bindable(event="rolesChange")]
		public function set roles(value:ArrayCollection):void
		{
			if (value != _roles)
			{
				_roles = value;
				dispatchEvent(new Event("rolesChange"));
			}
		}

		public function get roles():ArrayCollection
		{
			return _roles;
		}
		
		private var _dataRestrictions:Dictionary;
		[Bindable(event="dataRestrictionsChange")]
		public function set dataRestrictions (value:Dictionary):void
		{
			if (value != _dataRestrictions)
			{
				_dataRestrictions = value;
				dispatchEvent (new Event ("dataRestrictionsChange"));
			}
		}

		public function get dataRestrictions ():Dictionary
		{
			return _dataRestrictions;
		}

		private var _impersonated:Boolean;

		[Bindable(event="impersonatedChange")]
		public function set impersonated(value:Boolean):void
		{
			if (value != _impersonated)
			{
				_impersonated = value;
				dispatchEvent(new Event("impersonatedChange"));
			}
		}

		public function get impersonated():Boolean
		{
			return _impersonated;
		}

		private var _rolesLoaded:Boolean;

		[Bindable(event="rolesLoadedChange")]
		public function set rolesLoaded(value:Boolean):void
		{
			if (value != _rolesLoaded)
			{
				_rolesLoaded = value;
				dispatchEvent(new Event("rolesLoadedChange"));
			}
		}

		public function get rolesLoaded():Boolean
		{
			return _rolesLoaded;
		}

		private var _dataRestrictionsLoaded:Boolean;

		[Bindable(event="dataRestrictionsLoadedChange")]
		public function set dataRestrictionsLoaded(value:Boolean):void
		{
			if (value != _dataRestrictionsLoaded)
			{
				_dataRestrictionsLoaded = value;
				dispatchEvent(new Event("dataRestrictionsLoadedChange"));
			}
		}

		public function get dataRestrictionsLoaded():Boolean
		{
			return _dataRestrictionsLoaded;
		}

		public function isInRole(roleName:String):Boolean
		{
			if (roles.toArray().indexOf(roleName) != -1)
			{
				return true;
			}

			return false;
		}

		public function getDataRestrictionValues(dataRestrictionName:String):ArrayCollection
		{
			return dataRestrictions[dataRestrictionName];
		}

		public function clear():void
		{
			roles = null;
			dataRestrictions = null;
			rolesLoaded = false;
			dataRestrictionsLoaded = false;
			identity = new Identity();
			identity.authenticated = false;
		}
	}
}