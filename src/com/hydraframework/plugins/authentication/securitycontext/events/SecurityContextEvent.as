/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.securitycontext.events {
	import flash.events.Event;

	public class SecurityContextEvent extends Event {

		public static const LOGIN_COMPLETE:String = "SecurityContextEvent.loginComplete";
		public static const LOGOUT_COMPLETE:String = "SecurityContextEvent.logoutComplete";
		public static const ROLE_CHECK_COMPLETE:String = "SecurityContextEvent.roleCheckComplete";
		public static const CURRENT_USER_SET:String = "SecurityContextEvent.currentUserSet";
		public static const IMPERSONATOR_SET:String = "SecurityContextEvent.impersonatorSet";
		public static const IMPERSONATION_COMPLETE:String = "SecurityContextEvent.impersonationComplete";

		public var Success:Boolean;

		public function SecurityContextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, success:Boolean = true) {
			super(type, bubbles, cancelable);
			this.Success = success;
		}

		override public function clone():Event {
			return new SecurityContextEvent(type, bubbles, cancelable);
		}
	}
}