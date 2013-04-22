package indivoAccountCreator
{

	import flash.utils.getQualifiedClassName;

	import indivoAccountCreator.tasks.DeleteAllSharesTask;
	import indivoAccountCreator.tasks.GetSharesTask;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.URLUtil;

	import org.indivo.client.IndivoClientEvent;

	public class SharesDeleterBase extends PhrTaskPerformerBase
	{
		protected var _logger:ILogger;

		protected var _janitorAccessKey:String;

		protected var _janitorAccessSecret:String;

		protected var _janitorUsername:String;

		protected var _janitorPassword:String;

		public function SharesDeleterBase()
		{
			_logger = Log.getLogger(getQualifiedClassName(this).replace("::", "."));
		}

		protected function addDeleteAllSharesTask(performer:AsyncPerformer, getSharesTask:GetSharesTask):void
		{
			var task:DeleteAllSharesTask = new DeleteAllSharesTask(getSharesTask);
			task.pha = pha.clone();
			task.admin = admin.clone();
			task.recordId = _source.recordId;
			task.accessKey = _janitorAccessKey;
			task.accessSecret = _janitorAccessSecret;
			task.performer = performer;
			performer.tasks.push(task);
		}

		protected function addGetSharesTask(performer:AsyncPerformer):GetSharesTask
		{
			var task:GetSharesTask = new GetSharesTask();
			task.pha = pha.clone();
			task.recordId = _source.recordId;
			task.accessKey = _janitorAccessKey;
			task.accessSecret = _janitorAccessSecret;
			task.performer = performer;
			performer.tasks.push(task);
			return task;
		}

		public override function performTask():void
		{
			updateStatus("Performing login.");

			_admin.addEventListener(IndivoClientEvent.COMPLETE, loginCompleteHandler);
			_admin.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);

			_admin.create_session(_janitorUsername, _janitorPassword);
		}

		private function loginCompleteHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, loginCompleteHandler);

			var responseText:String = event.response.toString();

			var appInfo:Object = URLUtil.stringToObject(responseText, "&");

			if (appInfo.hasOwnProperty("oauth_token"))
			{
				_janitorAccessKey = appInfo["oauth_token"];
				_janitorAccessSecret = appInfo["oauth_token_secret"];

				updateStatus("Login successful");
				performNextSubTask();
			}
			else
				abortOnError("Unexpected result: " + event.response.toXMLString());
		}

		public function get janitorUsername():String
		{
			return _janitorUsername;
		}

		public function set janitorUsername(value:String):void
		{
			_janitorUsername = value;
		}

		public function get janitorPassword():String
		{
			return _janitorPassword;
		}

		public function set janitorPassword(value:String):void
		{
			_janitorPassword = value;
		}
	}
}
