package indivoAccountCreator
{

	public class PasswordGenerator
	{
		public function PasswordGenerator()
		{
		}

		public static function generateRandomPassword(length:int = 15):String
		{
			var possibleCharacters:String = "abchefghjkmnpqrstuvwxyz0123456789ABCHEFGHJKMNPQRSTUVWXYZ";

			var password:String = "";
			var i:int = 0;

			while (i < length)
			{
				var characterIndex:int = Math.random() * possibleCharacters.length;
				password += possibleCharacters.charAt(characterIndex);
				i++;
			}

			return password;
		}
	}
}
