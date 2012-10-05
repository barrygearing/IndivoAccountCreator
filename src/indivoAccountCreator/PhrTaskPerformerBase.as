package indivoAccountCreator
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.utils.URLUtil;
	
	import org.indivo.client.Admin;
	import org.indivo.client.IndivoClientEvent;
	import org.indivo.client.Pha;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class PhrTaskPerformerBase extends EventDispatcher
	{
		protected var _source:XML;
		protected var _pha:Pha;
		protected var _admin:Admin;
		protected var _resultLogger:IResultLogger;

		public function PhrTaskPerformerBase(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get admin():Admin
		{
			return _admin;
		}
		
		public function set admin(value:Admin):void
		{
			_admin = value;
		}
		
		public function get pha():Pha
		{
			return _pha;
		}
		
		public function set pha(value:Pha):void
		{
			_pha = value;
		}
		
		public function get source():XML
		{
			return _source;
		}
		
		public function set source(value:XML):void
		{
			_source = value;
		}
		
		public function performTask():void
		{
			updateStatus("Performing login.");
			
			_admin.addEventListener(IndivoClientEvent.COMPLETE, loginCompleteHandler);
			_admin.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			
			_admin.create_session(_source.username.toString(), _source.password.toString());
		}
		
		private function loginCompleteHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, loginCompleteHandler);
			
			var responseText:String = event.response.toString();
			
			var appInfo:Object = URLUtil.stringToObject(responseText, "&");
			
			if (appInfo.hasOwnProperty("oauth_token"))
			{
				_source.accessKey = appInfo["oauth_token"];
				_source.accessSecret = appInfo["oauth_token_secret"];
				
				updateStatus("Login successful");
				performNextSubTask();
			}
			else
				abortOnError("Unexpected result: " + event.response.toXMLString());
		}
		
		protected function performNextSubTask():void
		{
			// override in subclass
		}
		
		protected function complete():void
		{
			dispatchEvent(new AccountCreatorEvent(AccountCreatorEvent.COMPLETE, _source));
		}
		
		protected function indivoClientEventErrorHandler(event:IndivoClientEvent):void
		{
			_pha.removeEventListener(IndivoClientEvent.COMPLETE, loginCompleteHandler);
			_pha.removeEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			
			var responseXml:XML = event.response;
			var responseSummaryText:String = responseXml.name() + " (" + responseXml.children().length() + ") , " + responseXml.toXMLString().length + " characters";
			trace(responseSummaryText);
			updateOnError(" Failed on " + event.urlRequest.method + " " + event.urlRequest.url + " Response: " + responseXml.toXMLString());
		}
		
		protected function updateStatus(status:String):void
		{
			_source.status = status;
		}
		
		protected function updateOnError(message:String):void
		{
			_source.status += message;
		}
		
		protected function abortOnError(message:String):void
		{
			updateOnError(message);
			throw new Error(message);
		}

		public function get resultLogger():IResultLogger
		{
			return _resultLogger;
		}

		public function set resultLogger(value:IResultLogger):void
		{
			_resultLogger = value;
		}

		protected function assertSourceRecordProperties():void
		{
// verify preconditions
			if (_source.recordId.length() != 1 || _source.recordId.toString().length <= 0)
				throw new Error("_source.recordId must be set");
			if (_source.accessKey.length() != 1 || _source.accessKey.toString().length <= 0)
				throw new Error("_source.accessKey must be set");
			if (_source.accessSecret.length() != 1 || _source.accessSecret.toString().length <= 0)
				throw new Error("_source.accessSecret must be set");
		}
	}
}