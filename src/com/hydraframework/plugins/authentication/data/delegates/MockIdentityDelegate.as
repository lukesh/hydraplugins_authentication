package com.hydraframework.plugins.authentication.data.delegates
{
	import com.hydraframework.plugins.authentication.data.descriptors.Identity;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.data.interfaces.ILoginInformation;
	
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class MockIdentityDelegate implements IIdentityDelegate
	{

		public function MockIdentityDelegate()
		{
		}

		public function login(loginInfo:ILoginInformation):AsyncToken
		{
			var asyncToken:AsyncToken=new AsyncToken(null);

			var fakeIdentity:Identity = new Identity();
			fakeIdentity.userId = "ABC123";
			fakeIdentity.displayName = "Fake ID";

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, fakeIdentity, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function logout():AsyncToken
		{
			var asyncToken:AsyncToken=new AsyncToken(null);

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, true, asyncToken, null));
				}, 200);
			return asyncToken;
		}
		
		public function retrieveInformation(userId:String):AsyncToken
		{
			var asyncToken:AsyncToken=new AsyncToken(null);
			var fakeIdentity:Identity = new Identity();
			
			fakeIdentity.displayName = "Fake Impersonation ID";
			fakeIdentity.userId = userId;

			setTimeout(function():void
				{
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, fakeIdentity, asyncToken, null));
				}, 200);
			return asyncToken;
		}



	}
}