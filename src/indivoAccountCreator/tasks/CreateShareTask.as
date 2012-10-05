package indivoAccountCreator.tasks
{

	import indivoAccountCreator.AccountCreatorEvent;

	import org.indivo.client.IndivoClientEvent;

	public class CreateShareTask extends AsyncTaskBase
	{
		private var _shareWithAccountId:String;
		private var _shareRoleLabel:String;
		
		public function CreateShareTask()
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
			shareRecord();
		}

		private function shareRecord():void
		{
			pha.shares_POST(null, null, null, recordId, shareWithAccountId, shareRoleLabel, accessKey, accessSecret);
		}
		
		override protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			var responseXml:XML = event.response;
			if (responseXml.name() != "ok")
			{
				abortOnError("Unexpected result: " + responseXml.toXMLString());
			}

			super.indivoClientCompleteHandler(event);
		}
	}
}
