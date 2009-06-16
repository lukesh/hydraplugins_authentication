package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import com.hydraframework.plugins.authentication.model.IdentityProxy;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class IdentityRetrieveCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function get proxy():IdentityProxy
		{
			return IdentityProxy(this.facade.retrieveProxy(IdentityProxy.NAME));
		}

		public function IdentityRetrieveCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void {
			if (notification.isRequest())
			{
				var userId:String = notification.body as String;
				
				var asyncToken:AsyncToken=this.delegate.retrieveInformation(userId);
				asyncToken.addResponder(this);
			}
			
		}

		public function result(data:Object):void {
			if (!(data.result))
			{
				this.facade.sendNotification(new Notification(AuthenticationManager.IDENTITY_RETRIEVE, data.result, Phase.RESPONSE));
			}
		}
		
		public function fault(data:Object):void {
		}
	}
}