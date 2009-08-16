package com.hydraframework.plugins.authentication.securitycontext.events
{
	import flash.events.Event;

	public class SecurityContextEvent extends Event
	{
		public static const LOGIN_COMPLETE:String = "SecurityContextEvent.loginComplete";
		public static const LOGOUT_COMPLETE:String = "SecurityContextEvent.logoutComplete";
		public static const ROLE_CHECK_COMPLETE:String = "SecurityContextEvent.roleCheckComplete";
		public static const CURRENT_USER_SET:String = "SecurityContextEvent.currentUserSet";
		public static const IMPERSONATOR_SET:String = "SecurityContextEvent.impersonatorSet";
		public static const IMPERSONATION_COMPLETE:String = "SecurityContextEvent.impersonationComplete";

		public function SecurityContextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new SecurityContextEvent(type, bubbles, cancelable);
		}
	}
}