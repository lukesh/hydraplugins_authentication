package com.hydraframework.plugins.authentication.model
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class PrincipalProxy extends Proxy
	{
		public static const NAME:String = "PrincipalProxy";
		
		/**
		 * @private
		 * Cached instance of the PrincipalProxy.
		 */
		private static const _instance:PrincipalProxy = new PrincipalProxy();

		/**
		 * Returns a cached instance of the PrincipalProxy.
		 */
		public static function getInstance():PrincipalProxy {
			return _instance;
		}

		public function PrincipalProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		private var _principal:IPrincipal;

		public function setRoles(roles:ArrayCollection):void
		{
			_principal.roles = roles;
			this.sendNotification(new Notification(AuthenticationManager.ROLE_RETRIEVE, null, Phase.RESPONSE));
		}
		
		public function setDataRestrictions(dataRestrictions:Dictionary):void
		{
			_principal.dataRestrictions = dataRestrictions;			
			this.sendNotification(new Notification(AuthenticationManager.RESTRICTION_RETRIEVE, null, Phase.RESPONSE));
		}
		
		public function checkRole(role:String):void
		{
			if (!_principal.rolesLoaded)
			{
		
			}
			
			var isInRole:Boolean = _principal.isInRole(role);
			this.sendNotification(new Notification(AuthenticationManager.ROLE_CHECK, isInRole, Phase.RESPONSE));
		}
	}
	
}