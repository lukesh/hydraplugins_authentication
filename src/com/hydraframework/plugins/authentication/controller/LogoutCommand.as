package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class LogoutCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function LogoutCommand(facade:IFacade)
		{
			super(facade);
		}

		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var asyncToken:AsyncToken=this.delegate.logout();
				asyncToken.addResponder(this);
			}
		}
		
		public function result(data:Object):void {
			this.facade.sendNotification(new Notification(AuthenticationManager.LOGOUT, null, Phase.RESPONSE));
		}
		
		public function fault(data:Object):void {
		}
		
	}
}