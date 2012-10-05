package indivoAccountCreator.tasks
{

	import flash.events.Event;

	import mx.utils.StringUtil;

	import org.indivo.client.Admin;

	public class DeleteAllSharesTask extends AsyncTaskBase
	{
		private var _getSharesTask:GetSharesTask;
		private var _admin:Admin;

		public function DeleteAllSharesTask(getSharesTask:GetSharesTask)
		{
			_getSharesTask = getSharesTask;
		}

		public function get getSharesTask():GetSharesTask
		{
			return _getSharesTask;
		}

		public function set getSharesTask(value:GetSharesTask):void
		{
			_getSharesTask = value;
		}

		override public function performTask():void
		{
			for each (var accountId:String in _getSharesTask.sharedAccountIds)
			{
				var task:DeleteShareTask = new DeleteShareTask();
				task.shareWithAccountId = StringUtil.trim(accountId);
				task.pha = pha.clone();
				task.admin = admin.clone();
				task.recordId = recordId;
				task.accessKey = accessKey;
				task.accessSecret = accessSecret;
				task.performer = performer;
				performer.tasks.push(task);
			}
			dispatchEvent(new Event(Event.COMPLETE));
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
