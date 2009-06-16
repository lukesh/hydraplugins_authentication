package com.hydraframework.plugins.authentication
{
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;
	import com.hydraframework.plugins.authentication.controller.*;
	import com.hydraframework.plugins.authentication.data.descriptors.Principal;
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
		
		public function isLoggedOn():Boolean
		{
			return IdentityProxy.getInstance().isLoggedOn();
		}
		
//		public function identity():IIdentity
//		{
//			return IdentityProxy
//		}
//		

	}
}