package indivoAccountCreator.tasks
{

	import org.indivo.client.IndivoClientEvent;

	public class ChangeOwnerTask extends AdminAsyncTaskBase
	{
		private var _janitorAccountId:String;

		public function ChangeOwnerTask()
		{
			super();
		}

		override public function performTask():void
		{
			super.performTask();
			admin.records_X_ownerPUT(recordId, _janitorAccountId);
		}

		public function get janitorAccountId():String
		{
			return _janitorAccountId;
		}

		public function set janitorAccountId(value:String):void
		{
			_janitorAccountId = value;
		}

		override protected function admin_indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			var responseXml:XML = event.response;
			if (responseXml.name() == "Account")
			{
				if (responseXml.@id.toString() != _janitorAccountId)
					abortOnError("Account id " + responseXml.@id.toString() + " of new owner account does not match expected value " + _janitorAccountId + " ; response: " + responseXml.toXMLString());
			}
			else
				abortOnError("Unexpected result: " + responseXml.toXMLString());

			//updateStatus("Owner changed to janitor. Deleting share.");

			super.admin_indivoClientCompleteHandler(event);
		}
	}
}
