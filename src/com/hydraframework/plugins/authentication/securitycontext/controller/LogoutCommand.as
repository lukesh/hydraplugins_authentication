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
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipalDelegate;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	
	import mx.rpc.IResponder;

	public class LogoutCommand extends SimpleCommand implements IResponder
	{
		public function get principalDelegate():IPrincipalDelegate
		{
			var d:IPrincipalDelegate = this.facade.retrieveDelegate(IPrincipalDelegate) as IPrincipalDelegate;
			d.responder = this;
			return d;
		}

		public function get identityDelegate():IIdentityDelegate
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
				this.identityDelegate.logout();
			}
		}

		public function result(data:Object):void
		{
			var blankUser:IPrincipal = IPrincipal(principalDelegate.recordFactory());
			blankUser.identity = identityDelegate.recordFactory();
			this.facade.sendNotification(new Notification(SecurityContext.LOGOUT, blankUser, Phase.RESPONSE));
		}

		public function fault(data:Object):void
		{
		}

	}
}