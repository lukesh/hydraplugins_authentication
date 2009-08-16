/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication {
	import flash.events.Event;

	public class AuthenticationEvent extends Event {
		public static const AUTHENTICATE:String="AuthenticationEvent.authenticate";
		public var success:Boolean;

		public function AuthenticationEvent(type:String, successValue:Boolean, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.success=successValue;
		}

		override public function clone():Event {
			return new AuthenticationEvent(type, success, bubbles, cancelable);
		}

	}
}