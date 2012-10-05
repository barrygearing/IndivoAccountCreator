package indivoAccountCreator.tasks
{

	import org.indivo.client.IndivoClientEvent;

	public class DeleteShareTask extends AdminAsyncTaskBase
	{
		private var _shareWithAccountId:String;
		private var _shareRoleLabel:String;
		private var _janitorAccessKey:String;
		private var _janitorAccessSecret:String;

		public function DeleteShareTask()
		{
			super();
		}

		public function set shareWithAccountId(shareWithAccountId:String):void
		{
			_shareWithAccountId = shareWithAccountId;
		}

		public function set shareRoleLabel(shareRoleLabel:String):void
		{
			_shareRoleLabel = shareRoleLabel;
		}

		public function get shareWithAccountId():String
		{
			return _shareWithAccountId;
		}

		public function get shareRoleLabel():String
		{
			return _shareRoleLabel;
		}

		override public function performTask():void
		{
			super.performTask();
			deleteShare();
		}

		private function deleteShare():void
		{
			pha.shares_X_delete_POST(null, null, null, recordId, shareWithAccountId, janitorAccessKey, janitorAccessSecret);
		}
		
		override protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
/*
			var responseXml:XML = event.response;
			if (responseXml.name() != "ok")
			{
				abortOnError("Unexpected result: " + responseXml.toXMLString());
			}
*/
			var responseXml:XML = event.response;
			//				if (responseXml.name() != "ok")
			//					throw new Error("Unexpected result: " + responseXml.toXMLString());
			//
			//				_accountId = responseXml.id;

			trace("Response after delete shares: " + responseXml.toXMLString());

//			updateStatus("Share deleted.");

			super.indivoClientCompleteHandler(event);
		}

		public function get janitorAccessKey():String
		{
			return _janitorAccessKey;
		}

		public function set janitorAccessKey(value:String):void
		{
			_janitorAccessKey = value;
		}

		public function get janitorAccessSecret():String
		{
			return _janitorAccessSecret;
		}

		public function set janitorAccessSecret(value:String):void
		{
			_janitorAccessSecret = value;
		}
	}
}
