package indivoAccountCreator
{

	import flash.events.Event;

	import indivoAccountCreator.tasks.ChangeOwnerTask;
	import indivoAccountCreator.tasks.GetSharesTask;

	public class RecordDeleter extends SharesDeleterBase
	{
		public function RecordDeleter()
		{
		}

		private var _janitorAccountId:String;
		private var _oldShareAccountId:String;

		override protected function performNextSubTask():void
		{
			deleteRecord();
		}

		public function deleteRecord():void
		{
			updateStatus("Changing owner.");

			//assertSourceRecordProperties();

			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_deleteRecordCompleteHandler);
			addChangeOwnerTask(performer);
			var getSharesTask:GetSharesTask = addGetSharesTask(performer);
			addDeleteAllSharesTask(performer, getSharesTask);

			performer.performTasks();
		}

		private function addChangeOwnerTask(performer:AsyncPerformer):void
		{
			var task:ChangeOwnerTask = new ChangeOwnerTask();
			task.pha = pha.clone();
			task.admin = admin.clone();
			task.janitorAccountId = janitorAccountId;
			task.recordId = _source.recordId;
			task.accessKey = _source.accessKey;
			task.accessSecret = _source.accessSecret;
			task.performer = performer;
			performer.tasks.push(task);
		}
		
		private function performer_deleteRecordCompleteHandler(event:Event):void
		{
			updateStatus("Record deleted.");

			_source.recordId = "";
			if (_source.recordSeed.length() == 0)
				_source.recordSeed = 1;
			else
				_source.recordSeed = Number(_source.recordSeed) + 1;

			complete();
		}

		public function get oldShareAccountId():String
		{
			return _oldShareAccountId;
		}

		public function set oldShareAccountId(value:String):void
		{
			_oldShareAccountId = value;
		}

		public function get janitorAccountId():String
		{
			return _janitorAccountId;
		}

		public function set janitorAccountId(value:String):void
		{
			_janitorAccountId = value;
		}

	}
}