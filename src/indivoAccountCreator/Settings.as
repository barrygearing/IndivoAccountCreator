/**
 * Copyright 2011 John Moore, Scott Gilroy
 *
 * This file is part of CollaboRhythm.
 *
 * CollaboRhythm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later
 * version.
 *
 * CollaboRhythm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with CollaboRhythm.  If not, see
 * <http://www.gnu.org/licenses/>.
 */
package indivoAccountCreator
{
	[Bindable]
	public class Settings
	{
		private var _accountDataPath:String;
		private var _androidSdkPlatformToolsPath:String;
		private var _collaboRhythmDeviceLocalStorePath:String;
		private var _collaboRhythmLocalStorePath:String;
		private var _collaboRhythmAndroidPackage:String;
		private var _autoDeploy:Boolean = true;
		private var _autoRun:Boolean = true;

		public function Settings()
		{
		}

		public function get accountDataPath():String
		{
			return _accountDataPath;
		}

		public function set accountDataPath(value:String):void
		{
			_accountDataPath = value;
		}

		public function get androidSdkPlatformToolsPath():String
		{
			return _androidSdkPlatformToolsPath;
		}

		public function set androidSdkPlatformToolsPath(value:String):void
		{
			_androidSdkPlatformToolsPath = value;
		}

		public function get collaboRhythmDeviceLocalStorePath():String
		{
			return _collaboRhythmDeviceLocalStorePath;
		}

		public function get collaboRhythmLocalStorePath():String
		{
			return _collaboRhythmLocalStorePath;
		}

		public function set collaboRhythmDeviceLocalStorePath(value:String):void
		{
			_collaboRhythmDeviceLocalStorePath = value;
		}

		public function set collaboRhythmLocalStorePath(value:String):void
		{
			_collaboRhythmLocalStorePath = value;
		}

		public function get collaboRhythmAndroidPackage():String
		{
			return _collaboRhythmAndroidPackage;
		}

		public function set collaboRhythmAndroidPackage(value:String):void
		{
			_collaboRhythmAndroidPackage = value;
		}

		public function get autoDeploy():Boolean
		{
			return _autoDeploy;
		}

		public function set autoDeploy(value:Boolean):void
		{
			_autoDeploy = value;
		}

		public function get autoRun():Boolean
		{
			return _autoRun;
		}

		public function set autoRun(value:Boolean):void
		{
			_autoRun = value;
		}
	}
}