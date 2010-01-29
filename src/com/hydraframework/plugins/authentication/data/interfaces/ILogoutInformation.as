package com.hydraframework.plugins.authentication.data.interfaces {

	public interface ILogoutInformation {

		/**
		 * Message to be presented to the user when the
		 * session is expired.
		 */
		function set message(value:String):void;
		function get message():String;

		/**
		 * Should an alert be displayed when this logout
		 * request is made?
		 */
		function set showAlert(value:Boolean):void;
		function get showAlert():Boolean;

	}
}