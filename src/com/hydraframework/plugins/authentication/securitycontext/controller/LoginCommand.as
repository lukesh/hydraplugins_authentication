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
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class LoginCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			var d:IIdentityDelegate = this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
			d.responder = this;
			return d;
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

				this.delegate.login(loginInfo);
			}
		}

		public function result(data:Object):void
		{
			var currentUser:IIdentity;

			if (data is ResultEvent)
			{
				currentUser = data.result as IIdentity;
			}
			else if (data is IIdentity)
			{
				currentUser = IIdentity(data);
			}

			this.facade.sendNotification(new Notification(SecurityContext.LOGIN, currentUser, Phase.RESPONSE));
		}

		public function fault(data:Object):void
		{
		}
	}
}