/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.securitycontext {

	import com.hydraframework.core.hydraframework_internal;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.plugins.authentication.data.delegates.MockIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.delegates.MockPrincipalDelegate;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.ILogoutInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipalDelegate;
	import com.hydraframework.plugins.authentication.securitycontext.controller.*;
	import com.hydraframework.plugins.authentication.securitycontext.events.SecurityContextEvent;
	import com.hydraframework.plugins.authentication.securitycontext.interfaces.ISecurityContext;

	import flash.events.Event;

	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	use namespace hydraframework_internal;

	public class SecurityContext extends Facade implements ISecurityContext {
		public static const NAME:String                 = "plugins.authentication.SecurityContext";

		/*
		   -----------------------------------------------------------------------
		   NOTIFICATIONS
		   -----------------------------------------------------------------------
		 */

		/**
		 * Notes
		 */
		public static const LOGIN:String                = "plugins.authentication.login";
		public static const LOGOUT:String               = "plugins.authentication.logout";
		public static const ROLE_CHECK:String           = "plugins.authentication.roleCheck";
		public static const IDENTITY_IMPERSONATE:String = "plugins.authentication.identityImpersonate";

		/**
		 * Internal Notes
		 */
		public static const ROLE_RETRIEVE:String        = "plugins.authentication.roleRetrieve";
		public static const RESTRICTION_RETRIEVE:String = "plugins.authentication.restrictionRetrieve";
		public static const IDENTITY_RETRIEVE:String    = "plugins.authentication.identityRetrieve";

		private var _principalDelegateClass:Class       = MockPrincipalDelegate;
		private var _identityDelegateClass:Class        = MockIdentityDelegate;

		public function SecurityContext(principalDelegateClass:Class = null, identityDelegateClass:Class = null) {
			super();
			setName(NAME);
			_principalDelegateClass = principalDelegateClass || _principalDelegateClass;
			_identityDelegateClass = identityDelegateClass || _identityDelegateClass;
			initialize();
			setCurrentUser(IPrincipalDelegate(this.retrieveDelegate(IPrincipalDelegate)).recordFactory());
		}

		/*
		   -----------------------------------------------------------------------
		   PUBLIC PROPERTIES
		   -----------------------------------------------------------------------
		 */

		private var _currentUser:IPrincipal;

		private function setCurrentUser(value:IPrincipal):void {
			if (value != _currentUser) {
				_currentUser = value;
				BindingUtils.bindSetter(setIdentity, _currentUser, "identity");
				dispatchEvent(new Event("currentUserChange"));

				// Dispatch SecurityContextEvent (not required for databinding, but was present in previous API)
				dispatchEvent(new SecurityContextEvent(SecurityContextEvent.CURRENT_USER_SET));
			}
		}

		[Bindable(event="currentUserChange")]
		public function get currentUser():IPrincipal {
			return _currentUser;
		}

		private var _identity:IIdentity;

		private function setIdentity(value:IIdentity):void {
			if (_identity != value) {
				_identity = value;
				BindingUtils.bindSetter(setAuthenticated, _identity, "authenticated");
				dispatchEvent(new Event("identityChange"));
			}
		}

		[Bindable(event="identityChange")]
		public function get identity():IIdentity {
			return _identity;
		}

		private var _authenticated:Boolean;

		private function setAuthenticated(value:Boolean):void {
			_authenticated = value;
			dispatchEvent(new Event("authenticatedChange"));
		}

		[Bindable(event="authenticatedChange")]
		public function get authenticated():Boolean {
			return _authenticated;
		}

		private var _impersonator:IPrincipal;

		[Bindable(event="impersonatorChange")]
		private function setImpersonator(value:IPrincipal):void {
			if (value != _impersonator) {
				_impersonator = value;
				dispatchEvent(new Event("impersonatorChange"));

				// Dispatch SecurityContextEvent (not required for databinding, but was present in previous API)
				dispatchEvent(new SecurityContextEvent(SecurityContextEvent.IMPERSONATOR_SET));
			}
		}

		public function get impersonator():IPrincipal {
			return _impersonator;
		}

		/*
		   -----------------------------------------------------------------------
		   PRIVATE METHODS
		   -----------------------------------------------------------------------
		 */

		private function setImpersonation(newPrincipal:IPrincipal):void {
			if (!this.currentUser.impersonated) {
				this.setImpersonator(this.currentUser);
				this.setCurrentUser(newPrincipal);
				this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.IMPERSONATION_COMPLETE));
			}
		}

		/*
		   -----------------------------------------------------------------------
		   PUBLIC METHODS
		   -----------------------------------------------------------------------
		 */

		public function login(loginInfo:LoginInformation):void {
			this.sendNotification(new Notification(SecurityContext.LOGIN, loginInfo, Phase.REQUEST));
		}

		public function logout(logoutInfo:ILogoutInformation = null):void {
			this.sendNotification(new Notification(SecurityContext.LOGOUT, logoutInfo));
		}

		public function isInRole(roleName:String):Boolean {
			return this.currentUser.isInRole(roleName);
		}

		public function hasDataRestrictions(dataRestrictionName:String):ArrayCollection {
			return this.currentUser.getDataRestrictionValues(dataRestrictionName);
		}

		public function beginImpersonation(newUserId:String):void {
			this.sendNotification(new Notification(SecurityContext.IDENTITY_IMPERSONATE, newUserId, Phase.REQUEST));
		}

		public function endImpersonation():void {
			if (this.impersonator) {
				this.setCurrentUser(this.impersonator);
				this.setImpersonator(null);
			}
		}

		override public function registerCore():void {
			/*
			   Delegates
			 */
			this.registerDelegate(_identityDelegateClass);
			this.registerDelegate(_principalDelegateClass);

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

		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);

			if (notification.isResponse()) {
				var roleUser:IPrincipal;
				switch (notification.name) {
					case SecurityContext.IDENTITY_IMPERSONATE:
						if (notification.body is IIdentity) {
							this.sendNotification(new Notification(SecurityContext.ROLE_RETRIEVE, IPrincipal(notification.body), Phase.REQUEST));
						} else {
							currentUser.clear();
							this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, false, true));
						}
						break;
					case SecurityContext.LOGIN:
						if (notification.body is IIdentity && (notification.body as IIdentity).authenticated) {
							currentUser.identity = notification.body as IIdentity;
							this.sendNotification(new Notification(SecurityContext.ROLE_RETRIEVE, currentUser, Phase.REQUEST));
						} else {
							currentUser.clear();
							this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, false, true));
						}
						break;
					case SecurityContext.LOGOUT:
						setCurrentUser(IPrincipal(notification.body));
						setImpersonator(null);
						this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGOUT_COMPLETE, false, true));
						break;
					case SecurityContext.ROLE_RETRIEVE:
						if (notification.body is IPrincipal) {
							roleUser = notification.body as IPrincipal;
							if (roleUser.identity.authenticated) {
								setCurrentUser(roleUser);
							}
							this.sendNotification(new Notification(SecurityContext.RESTRICTION_RETRIEVE, roleUser, Phase.REQUEST));
						}
						break;
					case SecurityContext.RESTRICTION_RETRIEVE:
						if (notification.body is IPrincipal) {
							roleUser = notification.body as IPrincipal;
							if (roleUser.identity.authenticated) {
								setCurrentUser(roleUser);
								this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, true, true));
							} else {
								setImpersonation(roleUser);
							}
						}
						break;
					case SecurityContext.ROLE_CHECK:
						this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.ROLE_CHECK_COMPLETE, Boolean(notification.body), true));
						break;
				}
			}
			if (notification.isCancel()) {
				switch (notification.name) {
					case SecurityContext.LOGIN:  {
						currentUser.clear();
						this.dispatchEvent(new SecurityContextEvent(SecurityContextEvent.LOGIN_COMPLETE, false, true));
						break;
					}
				}
			}
		}
	}
}