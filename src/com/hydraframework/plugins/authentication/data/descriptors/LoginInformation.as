/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.descriptors
{
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;

	public class LoginInformation implements ILoginInformation
	{
		public function LoginInformation()
		{
			super();
		}

		private var _loginId:String;

		public function set loginId(value:String):void
		{
			if (value != _loginId)
			{
				_loginId = value;
			}
		}

		public function get loginId():String
		{
			return _loginId;
		}

		private var _password:String;

		public function set password(value:String):void
		{
			if (value != _password)
			{
				_password = value;
			}
		}

		public function get password():String
		{
			return _password;
		}

	}
}