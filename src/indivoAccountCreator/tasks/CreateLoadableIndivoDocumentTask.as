package indivoAccountCreator.tasks
{

	import indivoAccountCreator.*;

	import org.indivo.client.IndivoClientEvent;
	import org.indivo.client.Pha;

	public class CreateLoadableIndivoDocumentTask extends AsyncTaskBase
	{
		private static const LOADABLE_INDIVO_DOCUMENT_LOCAL_NAME:String = "LoadableIndivoDocument";
		private var _loadableIndivoDocumentXml:XML;
		private var _documentId:String;
		private var _results:DocumentCreationResults;

		public function get documentId():String
		{
			return _documentId;
		}

		public function set documentId(value:String):void
		{
			_documentId = value;
		}

		public function CreateLoadableIndivoDocumentTask(loadableIndivoDocumentXml:XML)
		{
			_loadableIndivoDocumentXml = loadableIndivoDocumentXml;
		}

		override public function performTask():void
		{
			super.performTask();
			pushRelationTasks();
			postPrimaryDocument();
		}

		private function pushRelationTasks():void
		{
			if (_loadableIndivoDocumentXml.relatesTo.length() > 0)
			{
				if (_loadableIndivoDocumentXml.relatesTo.length() > 1)
					throw new Error("Expected 1 child element named relatesTo but found " + _loadableIndivoDocumentXml.relatesTo.length());

				for each (var relationXml:XML in _loadableIndivoDocumentXml.relatesTo.relation)
				{
					var relationType:String = relationXml.@type;

					for each (var relatedDocumentXml:XML in relationXml.LoadableIndivoDocument)
					{
						var relatesToDocumentTask:CreateLoadableIndivoDocumentTask = new CreateLoadableIndivoDocumentTask(relatedDocumentXml);
						relatesToDocumentTask.pha = pha.clone();
						relatesToDocumentTask.recordId = recordId;
						relatesToDocumentTask.accessKey = accessKey;
						relatesToDocumentTask.accessSecret = accessSecret;
						relatesToDocumentTask.performer = performer;
						relatesToDocumentTask.results = results;
						results.addDocumentToCreate();
						performer.tasks.push(relatesToDocumentTask);

						var createRelationshipTask:CreateRelationshipTask = new CreateRelationshipTask(this,
																									   relationType,
																									   relatesToDocumentTask);
						createRelationshipTask.pha = pha.clone();
						createRelationshipTask.recordId = recordId;
						createRelationshipTask.accessKey = accessKey;
						createRelationshipTask.accessSecret = accessSecret;
						createRelationshipTask.results = results;
						createRelationshipTask.performer = performer;
						results.addRelationshipToCreate();
						performer.tasks.push(createRelationshipTask);
					}
				}
			}
		}

		private function postPrimaryDocument():void
		{
			if (_loadableIndivoDocumentXml.localName() != LOADABLE_INDIVO_DOCUMENT_LOCAL_NAME)
				throw new Error("Expected element named " + LOADABLE_INDIVO_DOCUMENT_LOCAL_NAME + " but found " + _loadableIndivoDocumentXml.localName());

			if (_loadableIndivoDocumentXml.document.length() != 1)
				throw new Error("Expected 1 child element named document but found " + _loadableIndivoDocumentXml.document.length());

			if (_loadableIndivoDocumentXml.document.children().length() != 1)
				throw new Error("Expected document element to have 1 child element, but found " + _loadableIndivoDocumentXml.document.children().length());

			postOneDocument(documentXmlString);
		}

		/**
		 * The XML string defining the Indivo document that should be loaded via the Indivo API.
		 */
		public function get documentXmlString():String
		{
			return _loadableIndivoDocumentXml.document.children()[0].toXMLString();
		}

		private function postOneDocument(documentText:String):void
		{
			trace("======== POST =========");
			trace(documentText);
			pha.documents_POST(null, null, null, recordId, accessKey, accessSecret, documentText);
		}

		override protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			var responseXml:XML = event.response;
			if (responseXml.name() == "Document")
			{
				documentId = responseXml.@id.toString();
				results.addCreatedDocument(documentId);
			}
			else
				abortOnError("Indivo request " + describeRequest(event) + " resulted in unexpected result: " + responseXml.toXMLString());

			super.indivoClientCompleteHandler(event);
		}

		private function describeRequest(event:IndivoClientEvent):String
		{
			return event.urlRequest.url
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
