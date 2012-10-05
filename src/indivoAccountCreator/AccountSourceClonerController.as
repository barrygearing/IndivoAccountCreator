package indivoAccountCreator
{

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.events.FlexEvent;

	public class AccountSourceClonerController extends EventDispatcher
	{
		private var _view:AccountSourceClonerView;
		private var _model:AccountSourceClonerModel;

		public function AccountSourceClonerController(model:AccountSourceClonerModel, view:AccountSourceClonerView)
		{
			_model = model;
			_view = view;

			_view.addEventListener(Event.COMPLETE, view_completeHandler);
			_view.addEventListener(FlexEvent.UPDATE_COMPLETE, view_updateCompleteHandler);
		}

		private function view_completeHandler(event:Event):void
		{
			updateModel();
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function updateTemplate():void
		{
			updateModel();
			_model.updateTemplate();
		}

		private function updateModel():void
		{
			_model.seriesStartValue = Number(_view.seriesStartValueTextInput.text);
			_model.seriesCount = Number(_view.seriesCountTextInput.text);
			_model.replaceNumericPart = _view.replaceNumericPartTextInput.text;
		}

		private function view_updateCompleteHandler(event:FlexEvent):void
		{
			updateTemplate();
		}
	}
}
