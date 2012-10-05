package indivoAccountCreator.tasks
{

	import indivoAccountCreator.*;

	public class DeletePhrDocumentTask extends AsyncTaskBase
	{
		private var _documentId:String;

		public function DeletePhrDocumentTask()
		{
		}

		override public function performTask():void
		{
			super.performTask();
			
			pha.documents_XDELETE(null, null, null, recordId, documentId, accessKey, accessSecret);
		}

		public function get documentId():String
		{
			return _documentId;
		}

		public function set documentId(value:String):void
		{
			_documentId = value;
		}
	}
}
