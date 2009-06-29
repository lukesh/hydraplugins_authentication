package com.hydraframework.plugins.authentication
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;
	import com.hydraframework.plugins.authentication.controller.*;
	import com.hydraframework.plugins.authentication.data.delegates.*;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.model.IdentityProxy;
	import com.hydraframework.plugins.authentication.model.PrincipalProxy;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class AuthenticationManager extends Plugin
	{
		/**
		 * Notes
		 */		
		public static const NAME:String = "AuthenticationManager";
		public static const LOGIN:String = "plugins.authentication.login";
		public static const LOGOUT:String = "plugins.authentication.logout";
		public static const ROLE_RETRIEVE:String = "plugins.authentication.roleRetrieve";
		public static const RESTRICTION_RETRIEVE:String = "plugins.authentication.restrictionRetrieve";
		public static const IDENTITY_RETRIEVE:String = "plugins.authentication.identityRetrieve";
		public static const ROLE_CHECK:String = "plugins.authentication.roleCheck";
		
		/**
		 * Events 
		 * 
		 */
		public static const ROLE_CHECK_COMPLETE:String = "plugins.authentication.roleCheckComplete";
		public static const LOGIN_COMPLETE:String = "plugins.authentication.loginComplete";
		public static const LOGOUT_COMPLETE:String = "plugins.authentication.logoutComplete";
		public static const CURRENT_USER_SET:String = "pluginsAuthenticationCurrentUserSet";
		public static const IMPERSONATOR_SET:String = "pluginsAuthenticationImpersonatorSet";
		
		/**
		 * @private
		 * Cached instance of the AuthenticationManager.
		 */
		private static const _instance:AuthenticationManager = new AuthenticationManager();

		/**
		 * Returns a cached instance of the AuthenticationManager.
		 */
		public static function get instance():AuthenticationManager {
			return _instance;
		}

		private var _currentUser:IPrincipal;
		
		[Bindable(event="pluginsAuthenticationCurrentUserSet")]
		public function get currentUser():IPrincipal
		{
			return _currentUser;
		}
		
		public function set currentUser(value:IPrincipal):void
		{
			_currentUser = value;
			this.dispatchEvent(new Event(CURRENT_USER_SET));
		}
		
		private var _impersonator:IPrincipal;

		[Bindable(event="pluginsAuthenticationImpersonatorSet")]
		public function get impersonator():IPrincipal
		{
			return _impersonator;
		}

		public function set impersonator(value:IPrincipal):void
		{
			_impersonator = value;
			this.dispatchEvent(new Event(IMPERSONATOR_SET));
		}

		public function AuthenticationManager()
		{
			super(NAME);
			_currentUser = new Principal();
			_currentUser.identity = new Identity();
			_currentUser.identity.isAuthenticated = false;	
			_impersonator = null;
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
			this.facade.registerProxy(new IdentityProxy());
			this.facade.registerProxy(new PrincipalProxy());
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
						if (notification.body is IIdentity)
						{
							currentUser.identity = notification.body as IIdentity;
							this.sendNotification(new Notification(AuthenticationManager.ROLE_RETRIEVE, currentUser, Phase.REQUEST));
							//this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.LOGIN_COMPLETE, true, true));
						}
						else
						{
							currentUser.clear();
							this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.LOGIN_COMPLETE, false, true));
						}
						break;
					case AuthenticationManager.LOGOUT:
						currentUser.clear();
						impersonator = null;
						this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.LOGOUT_COMPLETE, false, true));
						break;
					case AuthenticationManager.ROLE_RETRIEVE:
						if (notification.body is IPrincipal)
						{
							var roleUser:IPrincipal = notification.body as IPrincipal;
							if (roleUser.identity.isAuthenticated)
							{
								currentUser = roleUser;
							}
						this.sendNotification(new Notification(AuthenticationManager.RESTRICTION_RETRIEVE, currentUser, Phase.REQUEST));
						
						}
						break;
					case AuthenticationManager.RESTRICTION_RETRIEVE:
						if 
						this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.LOGIN_COMPLETE, true, true));
						break;
					case AuthenticationManager.ROLE_CHECK:
						this.dispatchEvent(new AuthenticationEvent(AuthenticationManager.ROLE_CHECK_COMPLETE, Boolean(notification.body), true));
						break;
				}
			}
		} 
		
		public function get isLoggedOn():Boolean
		{
			return AuthenticationManager.instance.currentUser.identity.isAuthenticated;
		}
		
		public function get identity():IIdentity
		{
			return AuthenticationManager.instance.currentUser.identity;
		}
		
		public function login(loginInfo:ILoginInformation):void {
			this.sendNotification(new Notification(AuthenticationManager.LOGIN, loginInfo, Phase.REQUEST));
		}
		
		public function isInRole(roleName:String):Boolean
		{
			return AuthenticationManager.instance.currentUser.isInRole(roleName);
		}
		
		public function hasDataRestriction(dataRestrictionName:String):ArrayCollection
		{
			return AuthenticationManager.instance.currentUser.getDataRestrictionValues(dataRestrictionName);
		}
		
		public function beginImpersonation(newUser:String):void
		{
			
		}
		
		public function beginImpersonation(newPrincipal:IPrincipal):void
		{
			if (!AuthenticationManager.instance.currentUser.impersonated)
			{
				AuthenticationManager.instance.impersonator = AuthenticationManager.instance.currentUser;
				AuthenticationManager.instance.currentUser = newPrincipal;
			}
		}
		
		public function endImpersonation():void
		{
			if (!AuthenticationManager.instance.impersonator)
			{
				AuthenticationManager.instance.currentUser = AuthenticationManager.instance.impersonator;
				AuthenticationManager.instance.impersonator = null;
			}
		}

	}
}