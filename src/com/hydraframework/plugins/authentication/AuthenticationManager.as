/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication {
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.ILogoutInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.events.AuthenticationEvent;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	import com.hydraframework.plugins.authentication.securitycontext.events.SecurityContextEvent;
	import com.hydraframework.plugins.authentication.securitycontext.interfaces.ISecurityContext;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.PropertyChangeEvent;

	public class AuthenticationManager extends Plugin {
		public static const NAME:String = "plugins.authentication.AuthenticationManager";

		/**
		 * @private
		 * Cached instance of the AuthenticationManager.
		 */
		private static const _instance:AuthenticationManager = new AuthenticationManager();
		;

		/**
		 * Returns a cached instance of the AuthenticationManager.
		 */
		public static function get instance():AuthenticationManager {
			return _instance;
		}

		/*
		   -----------------------------------------------------------------------
		   PUBLIC PROPERTIES
		   -----------------------------------------------------------------------
		 */

		private var _logoutInformation:ILogoutInformation = null;

		/**
		 * [READONLY] Contains additional information about the logout request
		 */
		public function get logoutInformation():ILogoutInformation {
			return _logoutInformation;
		}

		private var _securityContexts:ArrayCollection;

		[Bindable]
		public function set securityContexts(value:ArrayCollection):void {
			if (value != _securityContexts) {
				_securityContexts = value;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, securityContexts, null, value));
			}
		}

		public function get securityContexts():ArrayCollection {
			if (!_securityContexts) {
				_securityContexts = new ArrayCollection();
			}
			return _securityContexts;
		}

		private var _currentSecurityContext:ISecurityContext;

		[Bindable]
		public function set currentSecurityContext(value:ISecurityContext):void {
			if (value != _currentSecurityContext) {
				if (_currentSecurityContext) {
					_currentSecurityContext.removeEventListener(SecurityContextEvent.LOGIN_COMPLETE, handleSecurityContextEvent);
					_currentSecurityContext.removeEventListener(SecurityContextEvent.LOGOUT_COMPLETE, handleSecurityContextEvent);
				}
				_currentSecurityContext = value;
				_currentSecurityContext.addEventListener(SecurityContextEvent.LOGIN_COMPLETE, handleSecurityContextEvent, false, 0, true);
				_currentSecurityContext.addEventListener(SecurityContextEvent.LOGOUT_COMPLETE, handleSecurityContextEvent, false, 0, true);

				/*
				   Setup ChangeWatchers
				 */
				BindingUtils.bindSetter(setCurrentUser, _currentSecurityContext, "currentUser");
				BindingUtils.bindSetter(setIdentity, _currentSecurityContext, "identity");
				BindingUtils.bindSetter(setAuthenticated, _currentSecurityContext, "authenticated");

				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, _currentSecurityContext, null, value));
			}
		}

		public function get currentSecurityContext():ISecurityContext {
			return _currentSecurityContext;
		}

		/*
		   -----------------------------------------------------------------------
		   currentSecurityContext bindable getters
		   -----------------------------------------------------------------------
		 */

		protected var _identity:IIdentity;

		protected function setIdentity(value:IIdentity):void {
			if (value != _identity) {
				_identity = value;
				dispatchEvent(new Event("identityChange"));
			}
		}

		[Bindable(event="identityChange")]
		public function get identity():IIdentity {
			return _identity;
		}

		protected var _currentUser:IPrincipal;

		protected function setCurrentUser(value:IPrincipal):void {
			if (value != _currentUser) {
				_currentUser = value;
				dispatchEvent(new Event("currentUserChange"));
			}
		}

		[Bindable(event="currentUserChange")]
		public function get currentUser():IPrincipal {
			return _currentUser;
		}

		protected var _authenticated:Boolean;

		protected function setAuthenticated(value:Boolean):void {
			if (value != _authenticated) {
				_authenticated = value;
				dispatchEvent(new Event("authenticatedChange"));
			}
		}

		[Bindable(event="authenticatedChange")]
		public function get authenticated():Boolean {
			return _authenticated;
		}

		/*
		   -----------------------------------------------------------------------
		   CONSTRUCTOR
		   -----------------------------------------------------------------------
		 */

		public function AuthenticationManager() {
			super(NAME);
		}

		/*
		   -----------------------------------------------------------------------
		   PUBLIC METHODS
		   -----------------------------------------------------------------------
		 */


		override public function initialize():void {
			super.initialize();
			this.initializeSecurityContexts();
		}

		override public function preinitialize():void {
			super.preinitialize();
		}

		public function login(loginInfo:LoginInformation):void {
			if(_currentSecurityContext == null){
				Alert.show("Security Context is not set.  User cannot login.");
				return;
			}
			_currentSecurityContext.login(loginInfo);
		}

		/**
		 * <p>Logs out the current user from Adeptiv.</p>
		 *
		 * @param info Provides additional information about the logout request
		 */
		public function logout(logoutInfo:ILogoutInformation = null):void {
			if (authenticated) {
				_logoutInformation = logoutInfo;
				if(_currentSecurityContext == null){
					Alert.show("Security Context is not set.  User cannot logout.");
					return;
				}
				_currentSecurityContext.logout();
			}
		}

		public function isInRole(roleName:String):Boolean {
			return _currentSecurityContext ? _currentSecurityContext.isInRole(roleName) : false;
		}

		public function hasDataRestrictions(dataRestrictionName:String):ArrayCollection {
			return _currentSecurityContext ? _currentSecurityContext.hasDataRestrictions(dataRestrictionName) : null;
		}

		public function beginImpersonation(newUserId:String):void {
			_currentSecurityContext ? _currentSecurityContext.beginImpersonation(newUserId) : null;
		}

		public function endImpersonation():void {
			_currentSecurityContext ? _currentSecurityContext.endImpersonation() : null;
		}

		/*
		   -----------------------------------------------------------------------
		   PROTECTED METHODS
		   -----------------------------------------------------------------------
		 */

		/**
		 * @private
		 */
		protected function initializeSecurityContexts():void {
			this.securityContexts.addItem(new SecurityContext());
			this.currentSecurityContext = ISecurityContext(this.securityContexts.getItemAt(0));
		}

		/*
		   -----------------------------------------------------------------------
		   PRIVATE METHODS
		   -----------------------------------------------------------------------
		 */

		/**
		 * @private
		 */
		private function handleSecurityContextEvent(event:SecurityContextEvent):void {
			switch (event.type) {
				case SecurityContextEvent.LOGIN_COMPLETE:
					this.dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGIN, event.Success));
					break;
				case SecurityContextEvent.LOGOUT_COMPLETE:
					this.dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGOUT, true));
					break;
			}
		}

	}
}