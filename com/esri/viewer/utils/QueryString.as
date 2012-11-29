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
package com.esri.viewer.utils
{
	import flash.external.*;
	import flash.utils.*;

	public class QueryString
	{

		public var _queryString:String;
		private var _all:String;
		private var _params:Object;

		public function get queryString():String
		{
			return _queryString;
		}
		public function get url():String
		{
			return _all;
		}
		public function get parameters():Object
		{
			return _params;
		}


		public function QueryString()
		{

			readQueryString();
		}

		private function readQueryString():void
		{
			_params = {};
			try
			{
				_all =  ExternalInterface.call("window.location.href.toString");
				_queryString = ExternalInterface.call("window.location.search.substring", 1);
				if(_queryString)
				{

					var params:Array = _queryString.split('&');
					var length:uint = params.length;

					for (var i:uint=0,index:int=-1; i<length; i++)
					{
						var kvPair:String = params[i];
						if((index = kvPair.indexOf("=")) > 0)
						{
							var key:String = kvPair.substring(0,index);
							var value:String = kvPair.substring(index+1);
							_params[key] = value;
						}
					}
				}
			}catch(e:Error) { trace("Some error occured. ExternalInterface doesn't work in Standalone player."); }
		}

	}
}
