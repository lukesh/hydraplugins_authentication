package com.hydraframework.plugins.authentication.data.delegates
{
	import com.hydraframework.plugins.authentication.data.interfaces.IPrincipalDelegate;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import mx.rpc.AsyncToken;
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	import mx.core.mx_internal;

	public class MockPrincipalDelegate
	{
		public static var mock_roleList:ArrayCollection;
		public static var mock_dataRestrictions:Dictionary;

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

		public function retrieveRoles():AsyncToken
		{
			var asyncToken:AsyncToken=new AsyncToken(null);

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, mock_roleList, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function retrieveDataRestrictions():AsyncToken
		{
			var asyncToken:AsyncToken=new AsyncToken(null);

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, mock_dataRestrictions, asyncToken, null));
				}, 200);
			return asyncToken;
		}
	}
}