package indivoAccountCreator
{
	public class AccountDataBuilder
	{
		import flash.filesystem.*;
		
		import org.indivo.client.*;
		
		private var _source:XML;
		private var _contactXml:XML;
		private var _demographicsXml:XML;
		
		public function get demographicsXml():XML
		{
			return _demographicsXml;
		}

		public function get contactXml():XML
		{
			return _contactXml;
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
			
			_contactXml =
				<Contact xmlns="http://indivo.org/vocab/xml/documents#">
					<name>
						<fullName>{_source.fullName.toString()}</fullName>
						<givenName>{givenName}</givenName>
						<familyName>{familyName}</familyName>
					</name>
					<email type="personal">
					{_source.username.toString()}@records.media.mit.edu
					</email>
					<email type="work">
					{_source.username.toString()}.work@records.media.mit.edu
					</email>
					<address type="home">
						<streetAddress>17 Green St</streetAddress>
						<postalCode>02134</postalCode>
						<locality>Allston</locality>
						<region>Massachusetts</region>

						<country>US</country>
						<timeZone>-7GMT</timeZone>
					</address>
					<location type="home">
						<latitude>46N</latitude>
						<longitude>109W</longitude>
					</location>

					<phoneNumber type="home">8575557751</phoneNumber>
					<phoneNumber type="work">6175557535</phoneNumber>
					<instantMessengerName protocol="aim">{_source.username.toString()}medialab</instantMessengerName>
				</Contact>;
			
			_demographicsXml =
				<Demographics xmlns="http://indivo.org/vocab/xml/documents#">
					<dateOfBirth>1975-07-11</dateOfBirth>
					<dateOfDeath>2095-10-11</dateOfDeath>
					<gender>Male</gender>
					<ethnicity>Caucasian</ethnicity>
					<language>EN</language>
					<maritalStatus>Single</maritalStatus>
					<employmentStatus>Employed</employmentStatus>
					<employmentIndustry>Software</employmentIndustry>
					<occupation>Developer</occupation>
					<religion>None</religion>
					<income>44,000 USD</income>
					<highestEducation>University</highestEducation>
					<organDonor>true</organDonor>
				</Demographics>;
		}
		
		private function capitalize(value:String):String
		{
			return value.substr(0, 1).toUpperCase() + value.substr(1);
		}
		
		public function buildDataFromSource(source:XML):void
		{
			_source = source;
			
			_contactXml =
				<Contact xmlns="http://indivo.org/vocab/xml/documents#">
					<name>
						<fullName>{_source.fullName.toString()}</fullName>
						<givenName>{_source.givenName.toString()}</givenName>
						<familyName>{_source.familyName.toString()}</familyName>
					</name>
					<email type="personal">
						{_source.emailPersonal.toString()}
					</email>
					<email type="work">
						{_source.emailWork.toString()}
					</email>
					<address type="home">
						<streetAddress>{_source.streetAddress.toString()}</streetAddress>
						<postalCode>{_source.postalCode.toString()}</postalCode>
						<locality>{_source.locality.toString()}</locality>
						<region>{_source.region.toString()}</region>

						<country>{_source.country.toString()}</country>
						<timeZone>{_source.timeZone.toString()}</timeZone>
					</address>
					<location type="home">
						<latitude>{_source.latitudeHome.toString()}</latitude>
						<longitude>{_source.longitudeHome.toString()}</longitude>
					</location>

					<phoneNumber type="home">{_source.phoneNumberHome.toString()}</phoneNumber>
					<phoneNumber type="work">{_source.phoneNumberWork.toString()}</phoneNumber>
					<instantMessengerName protocol="aim">{_source.instantMessengerName.toString()}</instantMessengerName>
				</Contact>;
			
			_demographicsXml =
				<Demographics xmlns="http://indivo.org/vocab/xml/documents#">
					<dateOfBirth>{_source.dateOfBirth.toString()}</dateOfBirth>
					<gender>{_source.gender.toString()}</gender>
					<ethnicity>{_source.ethnicity.toString()}</ethnicity>
					<language>{_source.language.toString()}</language>
					<maritalStatus>{_source.maritalStatus.toString()}</maritalStatus>
					<employmentStatus>{_source.employmentStatus.toString()}</employmentStatus>
					<employmentIndustry>{_source.employmentIndustry.toString()}</employmentIndustry>
					<occupation>{_source.occupation.toString()}</occupation>
					<religion>{_source.religion.toString()}</religion>
					<income>{_source.income.toString()}</income>
					<highestEducation>{_source.highestEducation.toString()}</highestEducation>
					<organDonor>{_source.organDonor.toString()}</organDonor>
				</Demographics>;			
		}
		
		public function AccountDataBuilder()
		{
		}
	}
}