package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class LoginCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function LoginCommand(facade:IFacade)
		{
			super(facade);
		}

		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var loginInfo:ILoginInformation = notification.body as ILoginInformation;
				
				var asyncToken:AsyncToken=this.delegate.login(loginInfo);
				asyncToken.addResponder(this);
			}
		}
		
		public function result(data:Object):void {
			var currentUser:IIdentity = data.result as IIdentity;
			currentUser.isAuthenticated = true;

			this.facade.sendNotification(new Notification(AuthenticationManager.LOGIN, currentUser, Phase.RESPONSE));
		}
		
		public function fault(data:Object):void {
		}
	}
}