package indivoAccountCreator
{
	import flash.events.Event;
	
	public class AccountCreatorEvent extends Event
	{
		public static const COMPLETE:String = "creationComplete";
		private var _accountSourceXml:XML;
		
		public function AccountCreatorEvent(type:String, accountSourceXml:XML, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_accountSourceXml = accountSourceXml;
		}

		public function get accountSourceXml():XML
		{
			return _accountSourceXml;
		}

		public function set accountSourceXml(value:XML):void
		{
			_accountSourceXml = value;
		}

	}
}