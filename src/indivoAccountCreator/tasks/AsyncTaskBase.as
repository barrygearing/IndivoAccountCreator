package indivoAccountCreator.tasks
{

	import indivoAccountCreator.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	import mx.logging.ILogger;
	import mx.logging.Log;

	import org.indivo.client.IndivoClientEvent;
	import org.indivo.client.Pha;

	/**
	 * Dispatched when the task is complete. 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	public class AsyncTaskBase extends EventDispatcher
	{
		private var _pha:Pha;
		private var _recordId:String;
		private var _accessKey:String;
		private var _accessSecret:String;
		protected var logger:ILogger;

		private var _performer:AsyncPerformer;

		public function AsyncTaskBase()
		{
			logger = Log.getLogger(getQualifiedClassName(this).replace("::", "."));
		}
		
		public function get recordId():String
		{
			return _recordId;
		}

		public function set recordId(value:String):void
		{
			_recordId = value;
		}

		public function get accessKey():String
		{
			return _accessKey;
		}

		public function set accessKey(value:String):void
		{
			_accessKey = value;
		}

		public function get accessSecret():String
		{
			return _accessSecret;
		}

		public function set accessSecret(value:String):void
		{
			_accessSecret = value;
		}

		public function get pha():Pha
		{
			return _pha;
		}
		
		public function set pha(value:Pha):void
		{
			_pha = value;
		}
		
		protected function indivoClientCompleteHandler(event:IndivoClientEvent):void
		{
			logger.info("Task complete. Result: " + event.response);
			_pha.removeEventListener(IndivoClientEvent.COMPLETE, indivoClientCompleteHandler);
			_pha.removeEventListener(IndivoClientEvent.ERROR, indivoClientErrorHandler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function indivoClientErrorHandler(event:IndivoClientEvent):void
		{
			logger.error("Unexpected error occurred performing task: " + event.response);
			_pha.removeEventListener(IndivoClientEvent.COMPLETE, indivoClientCompleteHandler);
			_pha.removeEventListener(IndivoClientEvent.ERROR, indivoClientErrorHandler);
//			dispatchEvent(new Event(Event.EXITING));
			abortOnError("Task failed. Aborting. " + event.requestXml + " " + event.response);
		}
		
		public function performTask():void
		{
			// override in subclass
			addPhaEventListeners();
		}
		
		protected function addPhaEventListeners():void
		{
			_pha.addEventListener(IndivoClientEvent.COMPLETE, indivoClientCompleteHandler);
			_pha.addEventListener(IndivoClientEvent.ERROR, indivoClientErrorHandler);
		}

		public function get performer():AsyncPerformer
		{
			return _performer;
		}

		public function set performer(performer:AsyncPerformer):void
		{
			_performer = performer;
		}

		protected function abortOnError(message:String):void
		{
			// TODO: abort gracefully without crashing
			logger.error(message);
			throw new Error(message);
		}

		public static function describeRequest(event:IndivoClientEvent):String
		{
			return event.urlRequest.url
		}
	}
}