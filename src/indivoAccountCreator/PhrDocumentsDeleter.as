package indivoAccountCreator
{
	import flash.events.Event;

	import indivoAccountCreator.tasks.DeletePhrDocumentTask;

	public class PhrDocumentsDeleter extends PhrTaskPerformerBase
	{
		private var _documentIds:Vector.<String>;

		public function PhrDocumentsDeleter()
		{
		}

		override protected function performNextSubTask():void
		{
			super.performNextSubTask();

			assertSourceRecordProperties();

			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_completeHandler);

			for each (var id:String in documentIds)
			{
				var task:DeletePhrDocumentTask = new DeletePhrDocumentTask();
				task.documentId = id;
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
			complete();
		}

		public function get documentIds():Vector.<String>
		{
			return _documentIds;
		}

		public function set documentIds(value:Vector.<String>):void
		{
			_documentIds = value;
		}
	}
}
