package com.hydraframework.plugins.authentication.model
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.Identity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	

	public class IdentityProxy extends Proxy
	{
		public static const NAME:String = "IdentityProxy";

		/**
		 * @private
		 * Cached instance of the IdentityProxy.
		 */
		private static const _instance:IdentityProxy = new IdentityProxy();

		private var _identity:IIdentity;

		/**
		 * Returns a cached instance of the IdentityProxy.
		 */
		public static function getInstance():IdentityProxy {
			return _instance;
		}

		public function IdentityProxy()
		{
			super(NAME);
			_identity = PrincipalProxy.getInstance().identity;
		}
		
		public function isLoggedOn():Boolean
		{
			return _identity.isAuthenticated;
		}
		
		
	}
}