package com.hydraframework.plugins.authentication.model
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.Identity;
	import com.hydraframework.plugins.authentication.data.descriptors.Principal;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class PrincipalProxy extends Proxy
	{
		public static const NAME:String = "PrincipalProxy";
		
		public function PrincipalProxy(data:Object=null)
		{
			super(NAME, data);
			_principal = new Principal();
			_principal.identity = new Identity();
		}
		
		private var _principal:IPrincipal;
		
		public function get principal():IPrincipal
		{
			return _principal;
		}

		public function set principal(value:IPrincipal):void
		{
			_principal = value;
		}

		public function get identity():IIdentity
		{
			return _principal.identity;
		}

		public function set identity(value:IIdentity):void
		{
			_principal.identity = value;
		}
		
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
			var isInRole:Boolean = _principal.isInRole(role);
			this.sendNotification(new Notification(AuthenticationManager.ROLE_CHECK, isInRole, Phase.RESPONSE));
		}
		
	}
	
}