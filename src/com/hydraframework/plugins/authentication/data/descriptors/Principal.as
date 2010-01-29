/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;

	[Bindable]
	public class Principal extends EventDispatcher implements IPrincipal
	{
		public function Principal()
		{
			super();
			identity = new Identity();
		}

		private var _identity:IIdentity;

		public function set identity(value:IIdentity):void
		{
			if (value != _identity)
			{
				_identity = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, identity, null, value));
			}
		}

		public function get identity():IIdentity
		{
			return _identity;
		}

		private var _roles:ArrayCollection;

		public function set roles(value:ArrayCollection):void
		{
			if (value != _roles)
			{
				_roles = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, roles, null, value));
			}
		}

		public function get roles():ArrayCollection
		{
			return _roles;
		}

		private var _dataRestrictions:Dictionary;

		public function set dataRestrictions(value:Dictionary):void
		{
			if (value != _dataRestrictions)
			{
				_dataRestrictions = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, dataRestrictions, null, value));
			}
		}

		public function get dataRestrictions():Dictionary
		{
			return _dataRestrictions;
		}

		private var _impersonated:Boolean;

		public function set impersonated(value:Boolean):void
		{
			if (value != _impersonated)
			{
				_impersonated = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, impersonated, null, value));
			}
		}

		public function get impersonated():Boolean
		{
			return _impersonated;
		}

		private var _rolesLoaded:Boolean;

		public function set rolesLoaded(value:Boolean):void
		{
			if (value != _rolesLoaded)
			{
				_rolesLoaded = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, rolesLoaded, null, value));
			}
		}

		public function get rolesLoaded():Boolean
		{
			return _rolesLoaded;
		}

		private var _dataRestrictionsLoaded:Boolean;

		public function set dataRestrictionsLoaded(value:Boolean):void
		{
			if (value != _dataRestrictionsLoaded)
			{
				_dataRestrictionsLoaded = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, dataRestrictionsLoaded, null, value));
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