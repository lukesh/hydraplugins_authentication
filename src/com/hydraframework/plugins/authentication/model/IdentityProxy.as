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

		public function IdentityProxy()
		{
			super(NAME);
		}
		
		public function logIn(data:Object):void
		{
			if (data.result)
			{
				// success
				var currentUser:IIdentity = data.result as IIdentity;
				currentUser.isAuthenticated = true;
				this.sendNotification(new Notification(AuthenticationManager.LOGIN, currentUser, Phase.RESPONSE));
			}
			else
			{
				// failure
				this.sendNotification(new Notification(AuthenticationManager.LOGIN, null, Phase.RESPONSE));
			}
		}
		
		public function logOut():void
		{
			this.sendNotification(new Notification(AuthenticationManager.LOGOUT, null, Phase.RESPONSE));
		}
		
	}
}