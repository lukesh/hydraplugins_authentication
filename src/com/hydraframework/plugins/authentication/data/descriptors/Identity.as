/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.descriptors {

	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;

	[Bindable]
	public class Identity extends EventDispatcher implements IIdentity {

		public function Identity() {
			super();
		}

		private var _userId:String;

		public function set userId(value:String):void {
			if (value != _userId) {
				_userId = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, userId, null, value));
			}
		}

		public function get userId():String {
			return _userId;
		}

		private var _displayName:String;

		public function set displayName(value:String):void {
			if (value != _displayName) {
				_displayName = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, displayName, null, value));
			}
		}

		public function get displayName():String {
			return _displayName;
		}

		private var _attributes:Dictionary;

		public function set attributes(value:Dictionary):void {
			if (value != _attributes) {
				_attributes = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, attributes, null, value));
			}
		}

		public function get attributes():Dictionary {
			return _attributes;
		}

		private var _authenticated:Boolean;

		public function set authenticated(value:Boolean):void {
			if (value != _authenticated) {
				_authenticated = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, authenticated, null, value));
			}
		}

		public function get authenticated():Boolean {
			return _authenticated;
		}

		public function getAttribute(attributeName:String):Object {
			return attributes[attributeName];
		}

		public function clear():void {
			attributes = null;
			displayName = null;
			userId = null;
			authenticated = false;
		}
	}
}