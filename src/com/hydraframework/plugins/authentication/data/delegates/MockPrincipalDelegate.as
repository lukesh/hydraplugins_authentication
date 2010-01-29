/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.authentication.data.delegates
{
	import com.hydraframework.plugins.authentication.data.descriptors.Principal;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipal;
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipalDelegate;

	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;

	public class MockPrincipalDelegate implements IPrincipalDelegate
	{
		public static var _mockRoleList:ArrayCollection;
		public static var _mockDataRestrictions:Dictionary;

		private var _responder:IResponder;

		public function set responder(value:IResponder):void
		{
			_responder = value;
		}

		public function get responder():IResponder
		{
			return _responder;
		}

		private var _recordFactory:Function = function():Object
		{
			var principal:IPrincipal = new Principal();

			return principal;
		}

		public function get recordFactory():Function
		{
			return _recordFactory;
		}

		public function MockPrincipalDelegate()
		{
			if (!_mockRoleList)
			{
				_mockRoleList = new ArrayCollection();
				_mockRoleList.addItem("Administrator");
				_mockRoleList.addItem("Developer");
			}

			if (!_mockDataRestrictions)
			{
				var dataRestrictionValues:ArrayCollection = new ArrayCollection();

				_mockDataRestrictions = new Dictionary();
				dataRestrictionValues.addItem("Interactive");
				dataRestrictionValues.addItem("Creative");
				_mockDataRestrictions["Division"] = dataRestrictionValues;
				_mockDataRestrictions["Status"] = "Exempt";
			}
		}

		public function retrieveRoles(user:IPrincipal):void
		{
			var asyncToken:AsyncToken = new AsyncToken(null);

			user.roles = _mockRoleList;
			user.rolesLoaded = true;

			asyncToken.addResponder(new Responder(function(data:Object):void
				{
					//
					// Transform / normalize response if necessary
					//
					responder.result(data);
				}, function(info:Object):void
				{
					responder.fault(info);
				}));

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, user, asyncToken, null));
				}, 200);
		}

		public function retrieveDataRestrictions(user:IPrincipal):void
		{
			var asyncToken:AsyncToken = new AsyncToken(null);

			user.dataRestrictions = _mockDataRestrictions;
			user.dataRestrictionsLoaded = true;

			asyncToken.addResponder(new Responder(function(data:Object):void
				{
					//
					// Transform / normalize response if necessary
					//
					responder.result(data);
				}, function(info:Object):void
				{
					responder.fault(info);
				}));

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, user, asyncToken, null));
				}, 200);
		}
	}
}