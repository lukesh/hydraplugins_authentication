package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import com.hydraframework.plugins.authentication.model.IdentityProxy;

	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class InformationRetrieveCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function get proxy():IdentityProxy
		{
			return IdentityProxy(this.facade.retrieveProxy(IdentityProxy.NAME));
		}

		public function InformationRetrieveCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void {
			if (notification.isRequest())
			{
				var loginInfo:ILoginInformation = notification.body as ILoginInformation;
				
				this.proxy.setLoginId(loginInfo.loginId);
				var asyncToken:AsyncToken=this.delegate.login(loginInfo.password);
				asyncToken.addResponder(this);
			}
			
		}

		public function result(data:Object):void {
			if (Boolean(data.result))
			{
				this.proxy.logIn();
			}
		}
		
		public function fault(data:Object):void {
		}
	}
}