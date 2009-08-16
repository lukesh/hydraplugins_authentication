/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.securitycontext.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	
	import mx.rpc.IResponder;

	public class LogoutCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			var d:IIdentityDelegate = this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
			d.responder = this;
			return d;
		}

		public function LogoutCommand(facade:IFacade)
		{
			super(facade);
		}

		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				this.delegate.logout();
			}
		}

		public function result(data:Object):void
		{
			this.facade.sendNotification(new Notification(SecurityContext.LOGOUT, null, Phase.RESPONSE));
		}

		public function fault(data:Object):void
		{
		}

	}
}