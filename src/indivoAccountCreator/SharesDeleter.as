package indivoAccountCreator
{

	import flash.events.Event;

	import indivoAccountCreator.tasks.GetSharesTask;

	public class SharesDeleter extends SharesDeleterBase
	{
		public function SharesDeleter()
		{
		}

		override protected function performNextSubTask():void
		{
			deleteShares();
		}

		public function deleteShares():void
		{
			updateStatus("Deleting shares.");

			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_deleteSharesCompleteHandler);
			var getSharesTask:GetSharesTask = addGetSharesTask(performer);
			addDeleteAllSharesTask(performer, getSharesTask);

			performer.performTasks();
		}

		private function performer_deleteSharesCompleteHandler(event:Event):void
		{
			updateStatus("Shares deleted.");
			complete();
		}
	}
}
