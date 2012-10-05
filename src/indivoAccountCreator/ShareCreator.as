package indivoAccountCreator
{

	import flash.events.Event;

	import indivoAccountCreator.tasks.CreateShareTask;

	import mx.utils.StringUtil;

	public class ShareCreator extends PhrTaskPerformerBase
	{
		private var _shareWithAccountId:String;
		private var _shareRoleLabel:String;
		
		public function get shareRoleLabel():String
		{
			return _shareRoleLabel;
		}

		public function set shareRoleLabel(value:String):void
		{
			_shareRoleLabel = value;
		}

		public function get shareWithAccountId():String
		{
			return _shareWithAccountId;
		}
		
		public function set shareWithAccountId(value:String):void
		{
			_shareWithAccountId = value;
		}
		
		public function ShareCreator()
		{
		}

		override protected function performNextSubTask():void
		{
			updateStatus("Sharing record.");

			super.performNextSubTask();

			assertSourceRecordProperties();

			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_completeHandler);

			var shareAccountIds:Array = shareWithAccountId.split(",");

			for each (var id:String in shareAccountIds)
			{
				var task:CreateShareTask = new CreateShareTask();
				task.shareWithAccountId = StringUtil.trim(id);
				task.shareRoleLabel = shareRoleLabel;
				task.pha = _pha.clone();
				task.recordId = _source.recordId;
				task.accessKey = _source.accessKey;
				task.accessSecret = _source.accessSecret;
				task.performer = performer;
				performer.tasks.push(task);
			}

			performer.performTasks();
		}

		private function performer_completeHandler(event:Event):void
		{
			updateStatus("Record shared.");
			complete();
		}
	}
}