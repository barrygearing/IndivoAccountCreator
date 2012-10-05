package indivoAccountCreator.tasks
{

	import org.indivo.client.IndivoClientEvent;

	public class GetSharesTask extends AsyncTaskBase
	{
		private var _sharedAccountIds:Vector.<String> = new Vector.<String>();

		public function GetSharesTask()
		{
			super();
		}

		override public function performTask():void
		{
			super.performTask();
			pha.shares_GET(null, null, null, null, recordId, accessKey, accessSecret, null);
		}

		override protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			var responseXml:XML = event.response;
			if (responseXml.name() == "Shares")
			{
				for each (var shareXml:XML in responseXml.Share)
				{
					if (shareXml.hasOwnProperty("@account"))
					{
						_sharedAccountIds.push(shareXml.@account);
					}
				}
			}
			else
				abortOnError("Indivo request " + describeRequest(event) + " resulted in unexpected result: " + responseXml.toXMLString());

			super.indivoClientCompleteHandler(event);
		}

		public function get sharedAccountIds():Vector.<String>
		{
			return _sharedAccountIds;
		}
	}
}
