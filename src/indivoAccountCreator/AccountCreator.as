package indivoAccountCreator
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	import mx.logging.ILogger;
	import mx.logging.Log;

	public class AccountCreator extends EventDispatcher
	{
		import flash.filesystem.*;
		import flash.net.URLVariables;
		
		import org.indivo.client.*;

		public function AccountCreator()
		{
			_logger = Log.getLogger(getQualifiedClassName(this).replace("::", "."));
		}
		
		private var _source:XML;
		private var _contactXml:XML;
		private var _demographicsXml:XML;
		private var _admin:Admin;
		private var _accountId:String;
		private var _externalRecordId:String;
		private var _recordId:String;
		private var _shouldCreateRecord:Boolean = true;
		private var _appId:String;
		protected var _logger:ILogger;
		private var _setupPhaAppId:String;

		public function get appId():String
		{
			return _appId;
		}

		public function set appId(value:String):void
		{
			_appId = value;
		}

		public function get shouldCreateRecord():Boolean
		{
			return _shouldCreateRecord;
		}

		public function set shouldCreateRecord(value:Boolean):void
		{
			_shouldCreateRecord = value;
		}

		public function get demographicsXml():XML
		{
			return _demographicsXml;
		}

		public function set demographicsXml(value:XML):void
		{
			_demographicsXml = value;
		}

		public function get contactXml():XML
		{
			return _contactXml;
		}

		public function set contactXml(value:XML):void
		{
			_contactXml = value;
		}

		public function get source():XML
		{
			return _source;
		}

		public function set source(value:XML):void
		{
			_source = value;
		}

		public function get admin():Admin
		{
			return _admin;
		}

		public function set admin(value:Admin):void
		{
			_admin = value;
		}

		public function createAccount():void
		{
			updateStatus("Creating account.");
			//abortOnError("test abort");

			_admin.addEventListener(IndivoClientEvent.COMPLETE, accountCreatedHandler);
			_admin.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			
			var params:URLVariables = new URLVariables;
			params["account_id"] = _source.accountId.toString();
			params["contact_email"] = _source.contactEmail.toString();
			params["full_name"] = _source.fullName.toString();
			
			trace(params.toString());
			//				_admin.accounts_POST("account_id=user2%40records.media.mit.edu&contact_email=sgilroy%40mit.edu&full_name=User2%20Testing");
			_admin.accounts_POST(params.toString());
		}
		
		private function indivoClientEventErrorHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, accountCreatedHandler);
			_admin.removeEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			
			var responseXml:XML = event.response;
			var responseSummaryText:String = responseXml.name() + " (" + responseXml.children().length() + ") , " + responseXml.toXMLString().length + " characters";
			trace(responseSummaryText);
			var message:String = " Failed on " + event.urlRequest.method + " " + event.urlRequest.url + " Response: " + responseXml.toXMLString();
			updateOnError(message);
		}
		
		private function updateStatus(status:String):void
		{
			_source.status = status;
		}
		
		private function updateOnError(message:String):void
		{
			_logger.error(message);
			_source.status += message;
		}
		
		private function abortOnError(message:String):void
		{
			updateOnError(message);
			throw new Error(message);
		}
		
		private function accountCreatedHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, accountCreatedHandler);
			
			var responseXml:XML = event.response;
			if (responseXml.name() != "ok")
			{
				if (responseXml.name() == "Account")
				{
					if (responseXml.@id.toString() != _source.accountId.toString())
						abortOnError("Account id " + responseXml.@id.toString() + " of new account does not match expected value " + _source.accountId + " ; response: " + responseXml.toXMLString());
				}
				else
					abortOnError("Unexpected result: " + responseXml.toXMLString());
			}
			
			updateStatus("Account created. Setting password.");

			_accountId = _source.accountId.toString();
			
			_admin.addEventListener(IndivoClientEvent.COMPLETE, passwordSetHandler);
			
			var params:URLVariables = new URLVariables;
			params["system"] = "password";
			params["username"] = _source.username.toString();
			params["password"] = _source.password.toString();
			
			//				_admin.accounts_X_authsystems_POST(_accountId, "system=password&username=user2&password=user2testing454");
			_admin.accounts_X_authsystems_POST(_accountId, params.toString());
		}
		
		private function passwordSetHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, passwordSetHandler);
			
			var responseXml:XML = event.response;
			//				if (responseXml.name() != "ok")
			//					throw new Error("Unexpected result: " + responseXml.toXMLString());
			//				
			//				_accountId = responseXml.id;
			
			trace("Response after password set: " + responseXml.toXMLString());
			
			if (shouldCreateRecord)
			{
				updateStatus("Password set. Creating record");

				createRecord();
			}
			else
			{
				updateStatus("Password set.");
			}
		}
		
		public function createRecord():void
		{
			_admin.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);

			_externalRecordId = _source.username.toString() + "-primary";
			if (_source.recordSeed.length() > 0)
			{
				_externalRecordId += "-" + _source.recordSeed;
			}
			_admin.addEventListener(IndivoClientEvent.COMPLETE, recordCreatedHandler);
			_admin.records_external_X_XPUT(_appId, _externalRecordId, _demographicsXml.toXMLString());
		}
		
		private function recordCreatedHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, recordCreatedHandler);
			
			var responseXml:XML = event.response;
			if (responseXml.name() != "Record")
				throw new Error("Unexpected result: " + responseXml.toXMLString());
			
			updateStatus("Record created. Associating with account.");
			
			_recordId = responseXml.@id;
			_source.recordId = _recordId;
			_accountId = _source.accountId.toString();
			
			_admin.addEventListener(IndivoClientEvent.COMPLETE, recordAssociatedHandler);
			_admin.records_X_ownerPUT(_recordId, _accountId);
		}
		
		private function recordAssociatedHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, recordAssociatedHandler);
			
			var responseXml:XML = event.response;
			if (responseXml.name() != "Account")
				throw new Error("Unexpected result: " + responseXml.toXMLString());
			
			//_recordId = responseXml.@id;
			
			if (responseXml.@id != _accountId)
				throw new Error("Account id " + responseXml.id + " of record " + _recordId + " does not match expected value " + _accountId + " ; response: " + responseXml.toXMLString());

			updateStatus("Record associated with account.");

			if (_setupPhaAppId)
				setupPha();
			else
				complete();
		}

		public function setupPha():void
		{
			_admin.addEventListener(IndivoClientEvent.ERROR, indivoClientEventErrorHandler);
			_admin.addEventListener(IndivoClientEvent.COMPLETE, setupPhaCompleteHandler);
			_admin.records_X_apps_X_setupPOST(_recordId, _setupPhaAppId);
		}

		private function setupPhaCompleteHandler(event:IndivoClientEvent):void
		{
			_admin.removeEventListener(IndivoClientEvent.COMPLETE, setupPhaCompleteHandler);

			var responseXml:XML = event.response;
//			if (responseXml.name() != "Account")
//				throw new Error("Unexpected result: " + responseXml.toXMLString());

			//_recordId = responseXml.@id;

//			if (responseXml.@id != _accountId)
//				throw new Error("Account id " + responseXml.id + " of record " + _recordId + " does not match expected value " + _accountId + " ; response: " + responseXml.toXMLString());

			trace(responseXml.toString());

			updateStatus("Setup app " + _setupPhaAppId);

			complete();
		}

		private function complete():void
		{
			this.dispatchEvent(new AccountCreatorEvent(AccountCreatorEvent.COMPLETE, _source));
		}

		public function get setupPhaAppId():String
		{
			return _setupPhaAppId;
		}

		public function set setupPhaAppId(value:String):void
		{
			_setupPhaAppId = value;
		}

		public function get recordId():String
		{
			return _recordId;
		}

		public function set recordId(value:String):void
		{
			_recordId = value;
		}
	}
}