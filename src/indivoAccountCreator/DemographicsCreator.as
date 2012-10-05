package indivoAccountCreator
{

	import org.indivo.client.IndivoClientEvent;

	public class DemographicsCreator extends PhrTaskPerformerBase
	{
		private var _demographicsXml:XML;

		public function DemographicsCreator()
		{
		}
		
		public function get demographicsXml():XML
		{
			return _demographicsXml;
		}

		public function set demographicsXml(value:XML):void
		{
			_demographicsXml = value;
		}

		protected override function performNextSubTask():void
		{
			createDemographicsDocument();
		}

		private function createDemographicsDocument():void
		{
			updateStatus("Creating demographics.");
			//abortOnError("test abort");
			
			_pha.addEventListener(IndivoClientEvent.COMPLETE, demographicsCreatedHandler);
			_pha.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			
			_pha.special_demographicsPUT(null, null, null, _source.recordId, _source.accessKey, _source.accessSecret, _demographicsXml.toXMLString());
		}
		
		private function demographicsCreatedHandler(event:IndivoClientEvent):void
		{
			_pha.removeEventListener(IndivoClientEvent.COMPLETE, demographicsCreatedHandler);
			
			var responseXml:XML = event.response;
			if (responseXml.name() != "ok")
			{
				if (responseXml.name() == "Document")
				{
					updateStatus("Demographics document created. Id: " + responseXml.@id.toString());
					_source.demographicsId = responseXml.@id.toString();
					this.dispatchEvent(new AccountCreatorEvent(AccountCreatorEvent.COMPLETE, _source));
				}
				else
					abortOnError("Unexpected result: " + responseXml.toXMLString());
			}
		}
		
	}
}