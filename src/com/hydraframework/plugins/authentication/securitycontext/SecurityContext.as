package com.hydraframework.plugins.authentication.securitycontext
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.plugins.authentication.data.delegates.MockIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.delegates.MockPrincipalDelegate;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipalDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.ISecurityContext;
	import com.hydraframework.plugins.authentication.securitycontext.controller.*;
	import com.hydraframework.plugins.authentication.securitycontext.events.SecurityContextEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class SecurityContext extends Facade implements ISecurityContext
	{
		public static const NAME:String = "plugins.authentication.SecurityContext";
		
		/*
		   -----------------------------------------------------------------------
		   NOTIFICATIONS
		   -----------------------------------------------------------------------
		 */
		 
		/**
		 * Notes
		 */
		public static const LOGIN:String = "plugins.authentication.login";
		public static const LOGOUT:String = "plugins.authentication.logout";
		public static const ROLE_CHECK:String = "plugins.authentication.roleCheck";
		public static const IDENTITY_IMPERSONATE:String = "plugins.authentication.identityImpersonate";

		/**
		 * Internal Notes
		 */
		public static const ROLE_RETRIEVE:String = "plugins.authentication.roleRetrieve";
		public static const RESTRICTION_RETRIEVE:String = "plugins.authentication.restrictionRetrieve";
		public static const IDENTITY_RETRIEVE:String = "plugins.authentication.identityRetrieve";

		public function SecurityContext()
		{
			super(NAME);
			initialize();
		}

		/*
		   -----------------------------------------------------------------------
		   PUBLIC PROPERTIES
		   -----------------------------------------------------------------------
		 */
		 
		private var _currentUser:IPrincipal;

		[Bindable(event="currentUserChange")]
		public function set currentUser(value:IPrincipal):void
		{
			if (value != _currentUser)
			{
				_currentUser = value;
				dispatchEvent(new Event("currentUserChange"));
				this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.CURRENT_USER_SET));
			}
		}

		public function get currentUser():IPrincipal
		{
			return _currentUser;
		}

		
		[Bindable(event="identityChange")]
		public function set identity (value:IIdentity):void
		{
			if (currentUser && value != currentUser.identity)
			{
				currentUser.identity = value;
				dispatchEvent (new Event ("identityChange"));
			}
		}

		public function get identity ():IIdentity
		{
			return currentUser ? currentUser.identity : null;
		}

		private var _impersonator:IPrincipal;

		[Bindable(event="impersonatorChange")]
		public function set impersonator(value:IPrincipal):void
		{
			if (value != _impersonator)
			{
				_impersonator = value;
				dispatchEvent(new Event("impersonatorChange"));
				this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.IMPERSONATOR_SET));
			}
		}

		public function get impersonator():IPrincipal
		{
			return _impersonator;
		}

		private var _loggedOn:Boolean;

		[Bindable(event="loggedOnChange")]
		public function set loggedOn(value:Boolean):void
		{
			if (value != _loggedOn)
			{
				_loggedOn = value;
				dispatchEvent(new Event("loggedOnChange"));
			}
		}

		public function get loggedOn():Boolean
		{
			return _loggedOn;
		}
		
		/*
		   -----------------------------------------------------------------------
		   PRIVATE PROPERTIES
		   -----------------------------------------------------------------------
		 */
		 
		private var _identityDelegate:IIdentityDelegate;

		private function get identityDelegate():IIdentityDelegate {
			if (_identityDelegate == null) {
				_identityDelegate = IIdentityDelegate(this.retrieveDelegate(IIdentityDelegate));
			}
			return _identityDelegate;
		}

		private var _principalDelegate:IPrincipalDelegate;

		private function get principalDelegate():IPrincipalDelegate {
			if (_principalDelegate == null) {
				_principalDelegate = IPrincipalDelegate(this.retrieveDelegate(IPrincipalDelegate));
			}
			return _principalDelegate;
		}
	
		/*
		   -----------------------------------------------------------------------
		   PRIVATE METHODS
		   -----------------------------------------------------------------------
		 */
		 
		private function setImpersonation(newPrincipal:IPrincipal):void
		{
			if (!this.currentUser.impersonated)
			{
				this.impersonator = this.currentUser;
				this.currentUser = newPrincipal;
				this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.IMPERSONATION_COMPLETE));
			}	
		}
		
		/*
		   -----------------------------------------------------------------------
		   PUBLIC METHODS
		   -----------------------------------------------------------------------
		 */

		public function login(loginInfo:LoginInformation):void
		{
			this.sendNotification(new Notification(SecurityContext.LOGIN, loginInfo, Phase.REQUEST));
		}

		public function isInRole(roleName:String):Boolean
		{
			return this.currentUser.isInRole(roleName);
		}

		public function hasDataRestrictions(dataRestrictionName:String):ArrayCollection
		{
			return this.currentUser.getDataRestrictionValues(dataRestrictionName);
		}

		public function beginImpersonation(newUserId:String):void
		{
			this.sendNotification(new Notification(SecurityContext.IDENTITY_IMPERSONATE, newUserId, Phase.REQUEST));
		}

		public function endImpersonation():void
		{
			if (this.impersonator)
			{
				this.currentUser = this.impersonator;
				this.impersonator = null;
			}	
		}

		override public function registerCore():void
		{
			/*
			   Delegates
			 */
			this.registerDelegate(MockIdentityDelegate);
			this.registerDelegate(MockPrincipalDelegate);

			/*
			   Commands
			 */
			this.registerCommand(SecurityContext.LOGIN, LoginCommand);
			this.registerCommand(SecurityContext.LOGOUT, LogoutCommand);
			this.registerCommand(SecurityContext.ROLE_CHECK, RoleCheckCommand);
			this.registerCommand(SecurityContext.ROLE_RETRIEVE, RoleRetrieveCommand);
			this.registerCommand(SecurityContext.RESTRICTION_RETRIEVE, RestrictionRetrieveCommand);
			this.registerCommand(SecurityContext.IDENTITY_IMPERSONATE, IdentityImpersonateCommand);
		}

		override public function handleNotification(notification:Notification):void
		{
			super.handleNotification(notification);

			if (notification.isResponse())
			{
				var roleUser:IPrincipal;
				switch (notification.name)
				{
					case SecurityContext.IDENTITY_IMPERSONATE:
						if (notification.body is IIdentity)
						{
							var newUser:IPrincipal = principalDelegate.recordFactory();
							newUser.identity = notification.body as IIdentity;
							this.sendNotification(new Notification(SecurityContext.ROLE_RETRIEVE, newUser, Phase.REQUEST));
						}
						else
						{
							currentUser.clear();
							this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, false, true));
						}
						break;
					case SecurityContext.LOGIN:
						if (notification.body is IIdentity)
						{
							currentUser.identity = notification.body as IIdentity;
							this.sendNotification(new Notification(SecurityContext.ROLE_RETRIEVE, currentUser, Phase.REQUEST));
						}
						else
						{
							currentUser.clear();
							this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, false, true));
						}
						break;
					case SecurityContext.LOGOUT:
						var blankUser:IPrincipal = principalDelegate.recordFactory();
						blankUser.identity = identityDelegate.recordFactory();
						currentUser = blankUser;
						impersonator = null;
						this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGOUT_COMPLETE, false, true));
						break;
					case SecurityContext.ROLE_RETRIEVE:
						if (notification.body is IPrincipal)
						{
							roleUser = notification.body as IPrincipal;
							if (roleUser.identity.authenticated)
							{
								currentUser = roleUser;
							}
							this.sendNotification(new Notification(SecurityContext.RESTRICTION_RETRIEVE, roleUser, Phase.REQUEST));
						}
						break;
					case SecurityContext.RESTRICTION_RETRIEVE:
						if (notification.body is IPrincipal)
						{
							roleUser = notification.body as IPrincipal;
							if (roleUser.identity.authenticated)
							{
								currentUser = roleUser;
								this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, true, true));
							}
							else
							{
								setImpersonation(roleUser);
							}
						}
						break;
					case SecurityContext.ROLE_CHECK:
						this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.ROLE_CHECK_COMPLETE, Boolean(notification.body), true));
						break;
				}
			}
		}
	}
}