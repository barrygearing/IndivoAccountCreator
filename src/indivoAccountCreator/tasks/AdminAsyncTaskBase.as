package indivoAccountCreator.tasks
{

	import flash.events.Event;

	import org.indivo.client.Admin;
	import org.indivo.client.IndivoClientEvent;

	public class AdminAsyncTaskBase extends AsyncTaskBase
	{
		protected var _admin:Admin;

		public function AdminAsyncTaskBase()
		{
			super();
		}

		override public function performTask():void
		{
			// override in subclass
			super.addPhaEventListeners();
			addAdminEventListeners();
		}

		protected function addAdminEventListeners():void
		{
			_admin.addEventListener(IndivoClientEvent.COMPLETE, admin_indivoClientCompleteHandler);
			_admin.addEventListener(IndivoClientEvent.ERROR, admin_indivoClientEventErrorHandler);
		}

		protected function admin_indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			logger.info("Task complete. Result: " + event.response);
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, admin_indivoClientCompleteHandler);
			_admin.removeEventListener(IndivoClientEvent.ERROR, admin_indivoClientEventErrorHandler);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		protected function admin_indivoClientEventErrorHandler(event:IndivoClientEvent):void
		{
			logger.error("Unexpected error occurred performing task: " + event.response);
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, admin_indivoClientCompleteHandler);
			_admin.removeEventListener(IndivoClientEvent.ERROR, admin_indivoClientEventErrorHandler);
//			dispatchEvent(new Event(Event.EXITING));
			abortOnError("Task failed. Aborting. " + event.requestXml + " " + event.response);
		}

		public function get admin():Admin
		{
			return _admin;
		}

		public function set admin(value:Admin):void
		{
			_admin = value;
		}
	}
}
