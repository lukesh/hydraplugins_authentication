/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.interfaces
{

	public interface ILoginInformation
	{
		function get loginId():String;
		function set loginId(value:String):void;
		function get password():String;
		function set password(value:String):void;
	}
}