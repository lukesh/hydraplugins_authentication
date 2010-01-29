package com.hydraframework.plugins.authentication.data.descriptors {

	import com.hydraframework.plugins.authentication.data.interfaces.ILogoutInformation;

	public class LogoutInformation implements ILogoutInformation {

		private var _message:String;

		public function set message(value:String):void {
			if (_message != value) {
				_message = value;
			}
		}

		public function get message():String {
			return _message;
		}

		private var _showAlert:Boolean;

		public function set showAlert(value:Boolean):void {
			if (_showAlert != value) {
				_showAlert = value;
			}
		}

		public function get showAlert():Boolean {
			return _showAlert;
		}

		public function LogoutInformation(message:String = null, showAlert:Boolean = false) {
			this.message = message;
			this.showAlert = showAlert;
		}

	}
}