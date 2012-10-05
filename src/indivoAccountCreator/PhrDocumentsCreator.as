package indivoAccountCreator
{

	import flash.events.Event;
	import flash.filesystem.File;

	import indivoAccountCreator.tasks.CreatePhrDocumentsFromFileTask;

	public class PhrDocumentsCreator extends PhrTaskPerformerBase
	{
		private var _sourceDirectory:File;
		private var _results:DocumentCreationResults;

		public function PhrDocumentsCreator()
		{
		}
		
		public function get sourceDirectory():File
		{
			return _sourceDirectory;
		}

		public function set sourceDirectory(value:File):void
		{
			_sourceDirectory = value;
		}

		protected override function performNextSubTask():void
		{
			assertSourceRecordProperties();
			var performer:AsyncPerformer = new AsyncPerformer();
			performer.addEventListener(Event.COMPLETE, performer_completeHandler);
			
			for each (var file:File in _sourceDirectory.getDirectoryListing())
			{
				if (file.exists && !file.isDirectory && file.extension == "xml")
				{
					var task:CreatePhrDocumentsFromFileTask = new CreatePhrDocumentsFromFileTask();
					task.sourceFile = file;
					task.pha = _pha.clone();
					task.recordId = _source.recordId;
					task.accessKey = _source.accessKey;
					task.accessSecret = _source.accessSecret;
					task.performer = performer;
					task.results = results;
					performer.tasks.push(task);
				}
			}

			resultLogger.logResult("Parsing " + performer.tasks.length + " file" + (performer.tasks.length == 1 ? "" : "s") + " from " + _sourceDirectory.name + " directory", 1);
			performer.performTasks();
		}

		private function performer_completeHandler(event:Event):void
		{
			complete();
		}

		public function get results():DocumentCreationResults
		{
			return _results;
		}

		public function set results(value:DocumentCreationResults):void
		{
			_results = value;
		}
	}
}