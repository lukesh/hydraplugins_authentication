/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.interfaces.*;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class RoleRetrieveCommand extends SimpleCommand implements IResponder {
		public function get delegate():IPrincipalDelegate {
			var d:IPrincipalDelegate = this.facade.retrieveDelegate(IPrincipalDelegate) as IPrincipalDelegate;
			d.responder = this;
			return d;
		}

		public function RoleRetrieveCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.delegate.retrieveRoles(notification.body as IPrincipal);
			}
		}

		public function result(data:Object):void {
			if (data is ResultEvent) {
				this.facade.sendNotification(new Notification(AuthenticationManager.ROLE_RETRIEVE, IPrincipal(data.result), Phase.RESPONSE));
			} else if (data is IPrincipal) {
				this.facade.sendNotification(new Notification(AuthenticationManager.ROLE_RETRIEVE, IPrincipal(data), Phase.RESPONSE));
			}
		}

		public function fault(info:Object):void {
		}

	}
}