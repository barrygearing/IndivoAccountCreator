package indivoAccountCreator
{

	import spark.formatters.NumberFormatter;

	[Bindable]
	public class AccountSourceClonerModel
	{
		private var _seedAccountSource:XML;
		private var _seriesStartValue:Number;
		private var _seriesCount:Number;
		private var _replaceNumericPart:String;
		private var _template:String;

		public function AccountSourceClonerModel()
		{
		}

		public function set seedAccountSource(seedAccountSource:XML):void
		{
			_seedAccountSource = seedAccountSource;
		}

		public function set seriesStartValue(seriesStartValue:Number):void
		{
			_seriesStartValue = seriesStartValue;
		}

		public function set seriesCount(seriesCount:Number):void
		{
			_seriesCount = seriesCount;
		}

		public function set replaceNumericPart(replaceNumericPart:String):void
		{
			_replaceNumericPart = replaceNumericPart;
		}

		public function get seedAccountSource():XML
		{
			return _seedAccountSource;
		}

		public function get seriesStartValue():Number
		{
			return _seriesStartValue;
		}

		public function get seriesCount():Number
		{
			return _seriesCount;
		}

		public function get replaceNumericPart():String
		{
			return _replaceNumericPart;
		}

		public function updateTemplate():void
		{
			if (replaceNumericPart != null && replaceNumericPart.length > 0)
				template = StringHelper.replace(seedAccountSource, replaceNumericPart, "{SERIES_NUMBER}");
			else
				template = seedAccountSource;
		}

		public function set template(template:String):void
		{
			_template = template;
		}

		public function get template():String
		{
			return _template;
		}

		public function generateAccountSources():Vector.<XML>
		{
			var result:Vector.<XML> = new Vector.<XML>();
			for (var seriesNumber:int = seriesStartValue; seriesNumber < seriesStartValue + seriesCount; seriesNumber++)
			{
				var accountSource:XML = new XML(StringHelper.replace(template, "{SERIES_NUMBER}", StringHelper.padLeft(seriesNumber.toString(), "0", 2)));
				accountSource.password = PasswordGenerator.generateRandomPassword();
				result.push(accountSource);
			}
			return result;
		}
	}
}
