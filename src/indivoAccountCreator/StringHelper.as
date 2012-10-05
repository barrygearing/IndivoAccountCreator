package indivoAccountCreator
{
	public class StringHelper {
		public static function replace(str:String, oldSubStr:String, newSubStr:String):String {
			return str.split(oldSubStr).join(newSubStr);
		}

		/**
		 * Removes any whitespaces characters from the str. If chars is specified, those characters are removed instead.
		 * Whitespace characters include the following: space, tab, carriage return, new line
		 * @param str
		 * @param chars
		 * @return The specified str with any leading and trailing whitespace removed.
		 *
		 */
		public static function trim(str:String, chars:Vector.<String>=null):String {
			if (chars == null)
				chars = Vector.<String>([" ", "\t", "\n", "\r"]);

			return trimBack(trimFront(str, chars), chars);
		}

		public static function trimFront(str:String, chars:Vector.<String>):String {
			if (chars.indexOf(str.charAt(0)) != -1) {
				str = trimFront(str.substring(1), chars);
			}
			return str;
		}

		public static function trimBack(str:String, chars:Vector.<String>):String {
			if (chars.indexOf(str.charAt(str.length - 1)) != -1) {
				str = trimBack(str.substring(0, str.length - 1), chars);
			}
			return str;
		}

		public static function stringToCharacter(str:String):String {
			if (str.length == 1) {
				return str;
			}
			return str.slice(0, 1);
		}

		/**
		 * Pads p_string with specified character to a specified length from the left.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}
	}
}
