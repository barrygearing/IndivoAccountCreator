package indivoAccountCreator
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
import flash.net.URLVariables;
import flash.utils.getQualifiedClassName;

	import indivoAccountCreator.tasks.ChangeOwnerTask;
	import indivoAccountCreator.tasks.DeleteAllSharesTask;

	import indivoAccountCreator.tasks.DeleteShareTask;
	import indivoAccountCreator.tasks.GetSharesTask;

	import mx.logging.ILogger;
import mx.logging.Log;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;

import org.indivo.client.*;

	public class RecordDeleter extends PhrTaskPerformerBase
	{
		public function RecordDeleter()
		{
			_logger = Log.getLogger(getQualifiedClassName(this).replace("::", "."));
		}
		
		protected var _logger:ILogger;
		private var _janitorAccountId:String;
		private var _oldShareAccountId:String;
		private var _janitorUsername:String;
		private var _janitorPassword:String;
		private var _janitorAccessKey:String;
		private var _janitorAccessSecret:String;

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

		override protected function performNextSubTask():void
		{
			deleteRecord();
		}

		public function deleteRecord():void
		{
			updateStatus("Changing owner.");

			//assertSourceRecordProperties();

			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_completeHandler);
			addChangeOwnerTask(performer);
			var getSharesTask:GetSharesTask = addGetSharesTask(performer);
			addDeleteAllSharesTask(performer, getSharesTask);

			performer.performTasks();
		}

		private function addDeleteAllSharesTask(performer:AsyncPerformer, getSharesTask:GetSharesTask):void
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

		private function addGetSharesTask(performer:AsyncPerformer):GetSharesTask
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
		
		private function performer_completeHandler(event:Event):void
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