/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.authentication.data.delegates
{
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
		public static var mock_roleList:ArrayCollection;
		public static var mock_dataRestrictions:Dictionary;

		private var _responder:IResponder;

		public function set responder(value:IResponder):void {
			_responder=value;
		}

		public function get responder():IResponder {
			return _responder;
		}
		
		public function MockPrincipalDelegate()
		{
			if (!mock_roleList)
			{
				mock_roleList=new ArrayCollection();

				mock_roleList.addItem("Administrator");
				mock_roleList.addItem("Developer");
			}
			
			if (!mock_dataRestrictions)
			{
				var dataRestrictionValues:ArrayCollection = new ArrayCollection();

				mock_dataRestrictions = new Dictionary();

				dataRestrictionValues.addItem("Interactive");
 				dataRestrictionValues.addItem("Creative");
				mock_dataRestrictions["Division"] = dataRestrictionValues;
				mock_dataRestrictions["Status"] = "Exempt";
			}
		}

		public function retrieveRoles(user:IPrincipal):void
		{
			var asyncToken:AsyncToken=new AsyncToken(null);

			user.roles = mock_roleList;
			user.rolesLoaded = true;

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));
				
			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, user, asyncToken, null));
				}, 200);
		}

		public function retrieveDataRestrictions(user:IPrincipal):void
		{
			var asyncToken:AsyncToken=new AsyncToken(null);
			
			user.dataRestrictions = mock_dataRestrictions;
			user.dataRestrictionsLoaded = true;

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));
				
			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, user, asyncToken, null));
				}, 200);
		}
	}
}