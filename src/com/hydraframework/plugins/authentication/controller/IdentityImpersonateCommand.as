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
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class IdentityImpersonateCommand extends SimpleCommand implements IResponder {
		public function get delegate():IIdentityDelegate {
			var d:IIdentityDelegate = this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
			d.responder = this;
			return d;
		}

		public function IdentityImpersonateCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				var userId:String=notification.body as String;
				this.delegate.retrieveInformation(userId);
			}

		}

		public function result(data:Object):void {
			if (!(data.result)) {
				this.facade.sendNotification(new Notification(AuthenticationManager.IDENTITY_IMPERSONATE, data.result, Phase.RESPONSE));
			}
		}

		public function fault(data:Object):void {
		}
	}
}