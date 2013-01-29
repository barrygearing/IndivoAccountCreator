package indivoAccountCreator
{
	public class AccountDataBuilder
	{
		import flash.filesystem.*;
		
		import org.indivo.client.*;
		
		private var _source:XML;
		private var _demographicsXml:XML;
		
		public function get demographicsXml():XML
		{
			return _demographicsXml;
		}

		public function get source():XML
		{
			return _source;
		}

		public function set source(value:XML):void
		{
			_source = value;
		}

		public function buildTestUserData(username:String):void
		{
			_source = 
				<Source>
					<username>{username}</username>
					<contactEmail>sgilroy@mit.edu</contactEmail>
				</Source>;
			
			_source.appendChild(<accountId>{_source.username.toString()}@records.media.mit.edu</accountId>);
			var givenName:String = capitalize(_source.username.toString());
			var familyName:String = "Testing";
			_source.appendChild(<fullName>{givenName} {familyName}</fullName>);
			_source.appendChild(<password>{_source.username.toString()}testing454</password>);
			
			_demographicsXml =
					<Demographics xmlns="http://indivo.org/vocab/xml/documents#">
					    <dateOfBirth>1939-11-15</dateOfBirth>
					    <gender>male</gender>
					    <email>test@fake.org</email>
					    <ethnicity>Scottish</ethnicity>
					    <preferredLanguage>EN</preferredLanguage>
					    <race>caucasian</race>
					    <Name>
					        <familyName>Wayne</familyName>
					        <givenName>Bruce</givenName>
					        <middleName>Quentin</middleName>
					        <prefix>Mr</prefix>
					        <suffix>Jr</suffix>
					    </Name>
					    <Telephone>
					        <type>h</type>
					        <number>555-5555</number>
					        <preferred>true</preferred>
					    </Telephone>
					    <Telephone>
					        <type>c</type>
					        <number>555-6666</number>
					    </Telephone>
					    <Address>
					        <country>USA</country>
					        <city>Gotham</city>
					        <postalCode>90210</postalCode>
					        <region>secret</region>
					        <street>1007 Mountain Drive</street>
					    </Address>
					</Demographics>;
		}
		
		private function capitalize(value:String):String
		{
			return value.substr(0, 1).toUpperCase() + value.substr(1);
		}
		
		public function buildDataFromSource(source:XML):void
		{
			_source = source;

			var dateOfBirthString:String = _source.dateOfBirth.toString();
			var dateOfBirth:Date = DateUtil.parseW3CDTF(dateOfBirthString);
			_demographicsXml =
					<Demographics xmlns="http://indivo.org/vocab/xml/documents#">
						<dateOfBirth>{DateUtil.format(dateOfBirth, false)}</dateOfBirth>
						<gender>{_source.gender.toString().toLowerCase()}</gender>
						<email>{_source.emailPersonal.toString()}</email>
						<ethnicity>{_source.ethnicity.toString()}</ethnicity>
						<preferredLanguage>{_source.language.toString()}</preferredLanguage>
						<Name>
							<familyName>{_source.familyName.toString()}</familyName>
							<givenName>{_source.givenName.toString()}</givenName>
						</Name>
						<Telephone>
							<type>h</type>
							<number>{_source.phoneNumberHome.toString()}</number>
							<preferred>true</preferred>
						</Telephone>
						<Telephone>
							<type>c</type>
							<number>{_source.phoneNumberWork.toString()}</number>
						</Telephone>
						<Address>
							<country>{_source.country.toString()}</country>
							<city>{_source.locality.toString()}</city>
							<postalCode>{_source.postalCode.toString()}</postalCode>
							<region>{_source.region.toString()}</region>
							<street>{_source.streetAddress.toString()}</street>
						</Address>

					</Demographics>;
//			(_source.race.hasSimpleContent())}<race>{_source.race.toString()}</race>
		}
		
		public function AccountDataBuilder()
		{
		}
	}
}