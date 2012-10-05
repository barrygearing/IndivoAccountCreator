package indivoAccountCreator
{

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class DocumentCreationResults extends EventDispatcher
	{
		private var _documentsToCreate:Number = 0;
		private var _relationshipsToCreate:Number = 0;
		private var _documentIds:Vector.<String> = new Vector.<String>();
		private var _relationshipsCreated:Number = 0;
		private var _accountSourceXml:XML;

		public function DocumentCreationResults()
		{
		}

		public function addCreatedDocument(id:String):void
		{
			_documentIds.push(id);
			dispatchChangeEvent();
		}

		private function dispatchChangeEvent():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get documentIds():Vector.<String>
		{
			return _documentIds;
		}

		public function set documentIds(value:Vector.<String>):void
		{
			_documentIds = value;
		}

		public function addCreatedRelationship():void
		{
			_relationshipsCreated++;
			dispatchChangeEvent();
		}

		public function addDocumentToCreate():void
		{
			_documentsToCreate++;
			dispatchChangeEvent();
		}

		public function addRelationshipToCreate():void
		{
			_relationshipsToCreate++;
			dispatchChangeEvent();
		}

		public function get accountSourceXml():XML
		{
			return _accountSourceXml;
		}

		public function set accountSourceXml(value:XML):void
		{
			_accountSourceXml = value;
		}

		public function get statusSummary():String
		{
			return "Created " + _documentIds.length + "/" + _documentsToCreate + " documents, " + _relationshipsCreated + "/" + _relationshipsToCreate + " relationships";
		}
	}
}
