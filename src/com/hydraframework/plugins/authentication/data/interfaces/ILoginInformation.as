/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.interfaces {

	public interface ILoginInformation {
		function get loginId():String;
		function set loginId(value:String):void;
		function get password():String;
		function set password(value:String):void;
	}
}