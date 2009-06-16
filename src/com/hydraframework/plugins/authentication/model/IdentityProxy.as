package com.hydraframework.plugins.authentication.model
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.Identity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	
	import flash.utils.Dictionary;
	

	public class IdentityProxy extends Proxy
	{
		public static const NAME:String = "IdentityProxy";

		private var _identity:IIdentity;
		
		/**
		 * @private
		 * Cached instance of the IdentityProxy.
		 */
		private static const _instance:IdentityProxy = new IdentityProxy();

		/**
		 * Returns a cached instance of the IdentityProxy.
		 */
		public static function getInstance():IdentityProxy {
			return _instance;
		}

		public function IdentityProxy()
		{
			super(NAME);
			_identity = new Identity();
		}
		
		public function logIn(identity:IIdentity):void
		{
			_identity = identity;
			_identity.isAuthenticated = true;
			this.sendNotification(new Notification(AuthenticationManager.LOGIN, null, Phase.RESPONSE));
		}
		
		public function logOut():void
		{
			_identity.clear();
			this.sendNotification(new Notification(AuthenticationManager.LOGOUT, null, Phase.RESPONSE));
		}
		
		public function isLoggedOn():Boolean
		{
			return _identity.isAuthenticated;
		}
		
		
	}
}