package com.hydraframework.plugins.authentication
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;
	import com.hydraframework.plugins.authentication.controller.*;
	import com.hydraframework.plugins.authentication.data.delegates.MockIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.delegates.MockPrincipalDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.model.IdentityProxy;
	import com.hydraframework.plugins.authentication.model.PrincipalProxy;

	public class AuthenticationManager extends Plugin
	{
		public static const NAME:String = "AuthenticationManager";
		public static const LOGIN:String = "plugins.authentication.login";
		public static const LOGOUT:String = "plugins.authentication.logout";
		public static const ROLE_RETRIEVE:String = "plugins.authentication.roleRetrieve";
		public static const RESTRICTION_RETRIEVE:String = "plugins.authentication.restrictionRetrieve";
		public static const IDENTITY_RETRIEVE:String = "plugins.authentication.identityRetrieve";
		public static const ROLE_CHECK:String = "plugins.authentication.roleCheck";
		public static const ROLE_CHECK_COMPLETE:String = "plugins.authentication.roleCheckComplete";
		public static const LOGIN_COMPLETE:String = "plugins.authentication.loginComplete";
		
		/**
		 * @private
		 * Cached instance of the AuthenticationManager.
		 */
		private static const _instance:AuthenticationManager = new AuthenticationManager();

		/**
		 * Returns a cached instance of the AuthenticationManager.
		 */
		public static function getInstance():AuthenticationManager {
			return _instance;
		}

		public function AuthenticationManager()
		{
			super(NAME);
		}

		override public function preinitialize():void {
			super.preinitialize();
			/*
			   Delegates
			 */
			this.facade.registerDelegate(MockIdentityDelegate);
			this.facade.registerDelegate(MockPrincipalDelegate);
			/*
			   Proxies
			 */
			this.facade.registerProxy(IdentityProxy.getInstance());
			this.facade.registerProxy(PrincipalProxy.getInstance());
			/*
			   Commands
			 */
			this.facade.registerCommand(AuthenticationManager.LOGIN, LoginCommand);
			this.facade.registerCommand(AuthenticationManager.LOGOUT, LogoutCommand);
			this.facade.registerCommand(AuthenticationManager.ROLE_CHECK, RoleCheckCommand);
			this.facade.registerCommand(AuthenticationManager.ROLE_RETRIEVE, RoleRetrieveCommand);
			this.facade.registerCommand(AuthenticationManager.RESTRICTION_RETRIEVE, RestrictionRetrieveCommand);
			this.facade.registerCommand(AuthenticationManager.IDENTITY_RETRIEVE, IdentityRetrieveCommand);
		}

		override public function handleNotification(notification:Notification):void {
			if (notification.isResponse())
			{
				switch(notification.name)
				{
					case AuthenticationManager.LOGIN:
						this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.LOGIN_COMPLETE, Boolean(notification.body), true));
						break;
					case AuthenticationManager.ROLE_CHECK:
						this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.ROLE_CHECK_COMPLETE, Boolean(notification.body), true));
						break;
				}
			}
			
		}
		
		public function get isLoggedOn():Boolean
		{
			return PrincipalProxy.getInstance().identity.isAuthenticated;
		}
		
		public function get identity():IIdentity
		{
			return PrincipalProxy.getInstance().identity;
		}
		
		public function isInRole(roleName:String):Boolean
		{
			return PrincipalProxy.getInstance().principal.isInRole(roleName);
		}

	}
}