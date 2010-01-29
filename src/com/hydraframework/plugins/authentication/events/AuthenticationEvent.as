/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.events
{
	import flash.events.Event;

	public class AuthenticationEvent extends Event
	{
		public static const LOGIN:String = "AuthenticationEvent.login";
		public static const LOGOUT:String = "AuthenticationEvent.logout";
		
		public var success:Boolean;

		public function AuthenticationEvent(type:String, successValue:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.success = successValue;
		}

		override public function clone():Event
		{
			return new AuthenticationEvent(type, success, bubbles, cancelable);
		}

	}
}