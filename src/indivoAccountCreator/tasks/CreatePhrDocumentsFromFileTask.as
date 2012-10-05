package indivoAccountCreator.tasks
{

	import indivoAccountCreator.*;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.indivo.client.IndivoClientEvent;

	public class CreatePhrDocumentsFromFileTask extends AsyncTaskBase
	{
		private var _sourceFile:File;
		private var _results:DocumentCreationResults;

		public function CreatePhrDocumentsFromFileTask()
		{
			super();
		}

		public function get sourceFile():File
		{
			return _sourceFile;
		}

		public function set sourceFile(value:File):void
		{
			_sourceFile = value;
		}
		
		public override function performTask():void
		{
			var asyncTaskInitiated:Boolean = false;

			if (_sourceFile.exists)
			{
				logger.info("  File: " + _sourceFile.name);
				var stream:FileStream = new FileStream();
				stream.open(_sourceFile, FileMode.READ);
				var fileText:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();

				addPhaEventListeners();

				XML.setSettings(XML.defaultSettings());
				var fileXml:XML = new XML(fileText);
				if (fileXml.localName() == "IndivoDocuments")
				{
					trace("  POST " + fileXml.children().length() + " documents from " + _sourceFile.name);
					var i:int = 0;
					for each (var documentXml:XML in fileXml.children())
					{
						i++;
						if (documentXml.localName() == "LoadableIndivoDocument")
						{
							pushLoadableIndivoDocumentTask(documentXml);
						}
						else
						{
							// TODO: I think this might be resulting in dispatching a complete event for each document created, instead of a complete event after all of them are created
							trace("    POST " + i.toString() + " " + documentXml.localName());
							postOneDocument(documentXml.toXMLString());
							asyncTaskInitiated = true;
						}
					}
				}
				else
				{
					trace("  POST documents " + _sourceFile.name);
					postOneDocument(fileText);
					asyncTaskInitiated = true;
				}
			}

			if (!asyncTaskInitiated)
				dispatchEvent(new Event(Event.COMPLETE));
		}

		private function pushLoadableIndivoDocumentTask(documentXml:XML):void
		{
			// Steps:
			// 1. Create the LoadableIndivoDocument.document (and remember the id)
			// 2. For each relation, create all LoadableIndivoDocument.document (and remember the id)
			// 3. Create the relationship(s) from 1 to 2

			// Given this hierarchy:
			//  MO0
			//   si -> MSI0
			//          ai0 -> AI0
			//                  ar0 -> MA0
			//          ai1 -> AI1
			//                  ar1 -> MA1

			// A valid order for completion:
			//  MO0, MSI0, si, AI0, ai0, MA0, ar0, AI1, ai1, MA1, ar1

			var task:CreateLoadableIndivoDocumentTask = new CreateLoadableIndivoDocumentTask(documentXml);
			task.pha = pha.clone();
			task.recordId = recordId;
			task.accessKey = accessKey;
			task.accessSecret = accessSecret;
			task.performer = performer;
			task.results = results;
			results.addDocumentToCreate();
			performer.tasks.push(task);
		}

		private function postOneDocument(documentText:String):void
		{
			trace("======== POST =========");
			trace(documentText);
			pha.documents_POST(null, null, null, recordId, accessKey, accessSecret, documentText);
		}

		public function get results():DocumentCreationResults
		{
			return _results;
		}

		public function set results(value:DocumentCreationResults):void
		{
			_results = value;
		}

		override protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			super.indivoClientCompleteHandler(event);

		}
	}
}