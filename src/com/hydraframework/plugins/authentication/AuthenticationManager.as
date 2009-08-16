package com.hydraframework.plugins.authentication
{
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;
	import com.hydraframework.plugins.authentication.data.interfaces.ISecurityContext;
	import com.hydraframework.plugins.authentication.securitycontext.SecurityContext;
	import com.hydraframework.plugins.authentication.securitycontext.events.SecurityContextEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class AuthenticationManager extends Plugin
	{

		public static const NAME:String = "plugins.authentication.AuthenticationManager";

		/**
		 * @private
		 * Cached instance of the AuthenticationManager.
		 */
		private static const _instance:AuthenticationManager = new AuthenticationManager();

		/**
		 * Returns a cached instance of the AuthenticationManager.
		 */
		public static function get instance():AuthenticationManager
		{
			return _instance;
		}

		private var _securityContexts:ArrayCollection;

		[Bindable(event="securityContextsChange")]
		public function set securityContexts(value:ArrayCollection):void
		{
			if (value != _securityContexts)
			{
				_securityContexts = value;
				dispatchEvent(new Event("securityContextsChange"));
			}
		}

		public function get securityContexts():ArrayCollection
		{
			return _securityContexts;
		}

		private var _currentSecurityContext:ISecurityContext;

		[Bindable(event="currentSecurityContextChange")]
		public function set currentSecurityContext(value:ISecurityContext):void
		{
			if (value != _currentSecurityContext)
			{
				if (_currentSecurityContext)
				{
					_currentSecurityContext.removeEventListener(SecurityContextEvent.LOGIN_COMPLETE, handleLoginComplete);
				}
				_currentSecurityContext = value;
				_currentSecurityContext.addEventListener(SecurityContextEvent.LOGIN_COMPLETE, handleLoginComplete);
				dispatchEvent(new Event("currentSecurityContextChange"));
			}
		}

		public function get currentSecurityContext():ISecurityContext
		{
			return _currentSecurityContext;
		}


		public function AuthenticationManager()
		{
			super(NAME);
		}

		override public function initialize():void
		{
			super.initialize();
			this.securityContexts.addItem(new SecurityContext());
			this.currentSecurityContext = ISecurityContext(this.securityContexts.getItemAt(0));
		}

		override public function preinitialize():void
		{
			super.preinitialize();
		}
		
		private function handleLoginComplete(event:SecurityContextEvent):void
		{
			switch (event.type)
			{
				case SecurityContextEvent.LOGIN_COMPLETE:
					this.dispatchEvent(new AuthenticationEvent(AuthenticationEvent.AUTHENTICATE, true));
					break;
			}
		}

	}
}