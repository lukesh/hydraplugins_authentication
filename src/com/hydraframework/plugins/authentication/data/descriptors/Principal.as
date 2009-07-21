/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.descriptors {
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	public class Principal extends EventDispatcher implements IPrincipal {
		public function Principal(target:IEventDispatcher=null) {
			super(target);
		}

		private var _identity:IIdentity;

		[Bindable(event="plugins_Authentication_identityChange")]
		public function get identity():IIdentity {
			return _identity;
		}

		public function set identity(value:IIdentity):void {
			_identity=value;
			this.dispatchEvent(new Event("plugins_Authentication_identityChange"));
		}

		private var _roles:ArrayCollection;

		public function get roles():ArrayCollection {
			return _roles;
		}

		public function set roles(value:ArrayCollection):void {
			_roles=value;
		}

		private var _dataRestrictions:Dictionary;

		public function get dataRestrictions():Dictionary {
			return _dataRestrictions;
		}

		public function set dataRestrictions(value:Dictionary):void {
			_dataRestrictions=value;
		}

		private var _impersonated:Boolean;

		public function get impersonated():Boolean {
			return _impersonated;
		}

		public function set impersonated(value:Boolean):void {
			_impersonated=value;
		}


		private var _rolesLoaded:Boolean=false;

		public function get rolesLoaded():Boolean {
			return _rolesLoaded;
		}

		public function set rolesLoaded(value:Boolean):void {
			_rolesLoaded=value;
		}

		private var _dataRestrictionsLoaded:Boolean=false;

		public function get dataRestrictionsLoaded():Boolean {
			return _dataRestrictionsLoaded;
		}

		public function set dataRestrictionsLoaded(value:Boolean):void {
			_dataRestrictionsLoaded=value;
		}

		public function isInRole(roleName:String):Boolean {
			if (roles.toArray().indexOf(roleName) != -1) {
				return true;
			}

			return false;
		}

		public function getDataRestrictionValues(restrictionName:String):ArrayCollection {
			return dataRestrictions[restrictionName];
		}

		public function clear():void {
			_roles=null;
			_dataRestrictions=null;
			_rolesLoaded=false;
			_dataRestrictionsLoaded=false;
			//identity.clear();
			identity=new Identity();
			identity.isAuthenticated=false;
		}
	}
}