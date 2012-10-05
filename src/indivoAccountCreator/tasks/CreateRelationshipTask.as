package indivoAccountCreator.tasks
{

	import indivoAccountCreator.*;

	import org.indivo.client.IndivoClientEvent;

	public class CreateRelationshipTask extends AsyncTaskBase
	{
		private var _relatesFromDocumentTask:CreateLoadableIndivoDocumentTask;
		private var _relationType:String;
		private var _relatesToDocumentTask:CreateLoadableIndivoDocumentTask;
		private var _results:DocumentCreationResults;

		public function CreateRelationshipTask(relatesFromDocumentTask:CreateLoadableIndivoDocumentTask,
											   relationType:String,
											   relatesToDocumentTask:CreateLoadableIndivoDocumentTask)
		{
			_relatesFromDocumentTask = relatesFromDocumentTask;
			_relationType = relationType;
			_relatesToDocumentTask = relatesToDocumentTask;
		}

		override public function performTask():void
		{
			super.performTask();

			if (relatesFromDocumentId == null)
				abortOnError("relatesFromDocumentId is not specified. The task may have failed or may have been queued in the wrong order. Document: " + relatesFromDocumentTask.documentXmlString);

			if (relatesToDocumentId == null)
				abortOnError("relatesToDocumentId is not specified. The task may have failed or may have been queued in the wrong order. Document: " + relatesToDocumentTask.documentXmlString);

			pha.documents_X_rels_X_XPUT(null, null, null, recordId, relatesFromDocumentId, relationType,
										relatesToDocumentId, accessKey, accessSecret);
		}

		private function get relatesToDocumentId():String
		{
			return relatesToDocumentTask.documentId;
		}

		private function get relatesFromDocumentId():String
		{
			return relatesFromDocumentTask.documentId;
		}

		public function get relatesFromDocumentTask():CreateLoadableIndivoDocumentTask
		{
			return _relatesFromDocumentTask;
		}

		public function set relatesFromDocumentTask(value:CreateLoadableIndivoDocumentTask):void
		{
			_relatesFromDocumentTask = value;
		}

		public function get relationType():String
		{
			return _relationType;
		}

		public function set relationType(value:String):void
		{
			_relationType = value;
		}

		public function get relatesToDocumentTask():CreateLoadableIndivoDocumentTask
		{
			return _relatesToDocumentTask;
		}

		public function set relatesToDocumentTask(value:CreateLoadableIndivoDocumentTask):void
		{
			_relatesToDocumentTask = value;
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
			results.addCreatedRelationship();
		}
	}
}
