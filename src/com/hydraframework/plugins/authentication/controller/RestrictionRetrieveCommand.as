package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import com.hydraframework.plugins.authentication.model.*;
	
	import flash.utils.Dictionary;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class RestrictionRetrieveCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IPrincipalDelegate
		{
			return this.facade.retrieveDelegate(IPrincipalDelegate) as IPrincipalDelegate;
		}

		public function get proxy():PrincipalProxy
		{
			return PrincipalProxy(this.facade.retrieveProxy(PrincipalProxy.NAME));
		}

		public function RestrictionRetrieveCommand(facade:IFacade)
		{
			super(facade);
		}
		
		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var asyncToken:AsyncToken=this.delegate.retrieveDataRestrictions();
				asyncToken.addResponder(this);
			}
		}

		public function result(data:Object):void
		{
			if (data.Result is Dictionary)
			{
				this.proxy.setDataRestrictions(Dictionary(data.result));
			}
		}
		
		public function fault(info:Object):void
		{
		}
		
	}
}