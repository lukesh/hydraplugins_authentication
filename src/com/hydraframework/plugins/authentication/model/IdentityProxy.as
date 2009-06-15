package com.hydraframework.plugins.authentication.model
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.Identity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class IdentityProxy extends Proxy
	{
		public static const NAME:String = "UserProxy";

		private var _identity:IIdentity;
		
		/**
		 * @private
		 * Cached instance of the AuthenticationManager.
		 */
		private static const _instance:IdentityProxy = new IdentityProxy();

		/**
		 * Returns a cached instance of the AuthenticationManager.
		 */
		public static function getInstance():IdentityProxy {
			return _instance;
		}

		public function IdentityProxy()
		{
			super(NAME);
			_identity = new Identity();
		}
		
		public function setLoginId(loginId:String):void
		{
			logOut();
			_identity.loginId = loginId;
		}
		
		public function logIn():void
		{
			_identity.loggedIn = true;
			this.sendNotification(new Notification(AuthenticationManager.LOGIN, null, Phase.RESPONSE));
		}
		
		public function logOut():void
		{
			_identity.clear();
			this.sendNotification(new Notification(AuthenticationManager.LOGOUT, null, Phase.RESPONSE));
		}
		
		public function isLoggedOn():Boolean
		{
			return _identity.loggedIn;
		}
		
		public function setRoles(roles:ArrayCollection):void
		{
			_identity.roles = roles;
			this.sendNotification(new Notification(AuthenticationManager.ROLE_RETRIEVE, null, Phase.RESPONSE));
		}
		
		public function setDataRestrictions(dataRestrictions:Dictionary):void
		{
			_identity.dataRestrictions = dataRestrictions;			
			this.sendNotification(new Notification(AuthenticationManager.RESTRICTION_RETRIEVE, null, Phase.RESPONSE));
		}
		
		public function checkRole(role:String):void
		{
			var isInRole:Boolean = _identity.isInRole(role);
			this.sendNotification(new Notification(AuthenticationManager.ROLE_CHECK, isInRole, Phase.RESPONSE));
		}
		
		
	}
}