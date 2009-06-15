package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.model.IdentityProxy;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class RoleCheckCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function get proxy():IdentityProxy
		{
			return IdentityProxy(this.facade.retrieveProxy(IdentityProxy.NAME));
		}

		public function RoleCheckCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				this.proxy.checkRole(String(notification.body));
			}
		}
		
		public function result(data:Object):void {
		}
		
		public function fault(data:Object):void {
		}
	
	}
}