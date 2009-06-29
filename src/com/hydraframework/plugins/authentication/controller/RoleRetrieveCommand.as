package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import com.hydraframework.plugins.authentication.model.*;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class RoleRetrieveCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IPrincipalDelegate
		{
			return this.facade.retrieveDelegate(IPrincipalDelegate) as IPrincipalDelegate;
		}

		public function get proxy():PrincipalProxy
		{
			return PrincipalProxy(this.facade.retrieveProxy(PrincipalProxy.NAME));
		}

		public function RoleRetrieveCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var asyncToken:AsyncToken=this.delegate.retrieveRoles(notification.body as IPrincipal);
				asyncToken.addResponder(this);
			}
		}

		public function result(data:Object):void
		{
			if (data.result is ArrayCollection)
			{
				this.proxy.setRoles(ArrayCollection(data.result));
			}
		}
		
		public function fault(info:Object):void
		{
		}
		
	}
}