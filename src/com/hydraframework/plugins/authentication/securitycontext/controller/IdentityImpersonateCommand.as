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
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class IdentityImpersonateCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			var d:IIdentityDelegate = this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
			d.responder = this;
			return d;
		}

		public function IdentityImpersonateCommand(facade:IFacade)
		{
			super(facade);
		}

		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var userId:String = notification.body as String;
				this.delegate.retrieveInformation(userId);
			}

		}

		public function result(data:Object):void
		{
			if (data is ResultEvent)
			{
				if (!(data.result))
				{
					this.facade.sendNotification(new Notification(SecurityContext.IDENTITY_IMPERSONATE, data.result, Phase.RESPONSE));
				}
			}
			else
			{
				this.facade.sendNotification(new Notification(SecurityContext.IDENTITY_IMPERSONATE, data, Phase.RESPONSE));
			}
		}

		public function fault(data:Object):void
		{
		}
	}
}