package indivoAccountCreator
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import indivoAccountCreator.tasks.AsyncTaskBase;

	/**
	 * Dispatched when all tasks are complete. 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	public class AsyncPerformer extends EventDispatcher
	{
		private var _tasks:Vector.<AsyncTaskBase> = new Vector.<AsyncTaskBase>();
		private var _nextTask:AsyncTaskBase;
		
		public function AsyncPerformer()
		{
		}
		
		public function get tasks():Vector.<AsyncTaskBase>
		{
			return _tasks;
		}

		public function set tasks(value:Vector.<AsyncTaskBase>):void
		{
			_tasks = value;
		}

		public function performTasks():void
		{
			performNextTask();
		}
		
		private function performNextTask():void
		{
			if (_tasks != null && _tasks.length > 0)
			{
				_nextTask = _tasks.shift();
				_nextTask.addEventListener(Event.COMPLETE, taskComplete);
				_nextTask.addEventListener(Event.EXITING, taskComplete);
				_nextTask.performTask();
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function taskComplete(event:Event):void
		{
			_nextTask.removeEventListener(Event.COMPLETE, taskComplete);
			_nextTask.removeEventListener(Event.EXITING, taskComplete);
			performNextTask();
		}
	}
}