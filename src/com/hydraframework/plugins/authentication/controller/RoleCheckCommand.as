package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class RoleCheckCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IPrincipalDelegate
		{
			return this.facade.retrieveDelegate(IPrincipalDelegate) as IPrincipalDelegate;
		}

		public function RoleCheckCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void
		{
			//this.sendNotification(new Notification(AuthenticationManager, null, Phase.RESPONSE));
		}
		
		public function result(data:Object):void {
		}
		
		public function fault(data:Object):void {
		}
	
	}
}