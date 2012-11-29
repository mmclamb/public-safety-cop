/*
 | Version 10.1.1
 | Copyright 2012 Esri
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 |
 |    http://www.apache.org/licenses/LICENSE-2.0
 |
 | Unless required by applicable law or agreed to in writing, software
 | distributed under the License is distributed on an "AS IS" BASIS,
 | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 | See the License for the specific language governing permissions and
 | limitations under the License.
 */
package widgets.PDC.utils{
	final public class DateParser {
		private static var MONTH_NAMES		: Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private static var MONTH_ABB_NAMES	: Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		private static var DAY_NAMES		: Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		private static var DAY_ABB_NAMES	: Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

		public static function parseToString(dateString:String):String {
			var result	:String = "Parsing error.";
			var splitted:Array = dateString.split(" ");
			switch(splitted.length){
				case 6:
					if(DAY_ABB_NAMES.indexOf(splitted[0]) > -1){
						var time_splitted:Array = splitted[3].split(":");
						result = splitted[5] + "-" + doubleDigit(MONTH_ABB_NAMES.indexOf(splitted[1]) + 1) + "-" + splitted[2] + " " + time_splitted[0] + ":" + time_splitted[1];
						break;
					};
				break;
			};
			return result;
		};

		public static function doubleDigit(num:Number):String {
			if(num < 10) return ("0" + num.toString());
			return num.toString();
		};
	};
};