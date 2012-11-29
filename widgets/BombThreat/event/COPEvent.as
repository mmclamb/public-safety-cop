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
package widgets.BombThreat.event
{
	import flash.events.Event;

	public class COPEvent extends Event
	{
		public static const DROP_THE_IMAGE:String = "dropTheImage";

		public var data:Object = new Object()

		public function COPEvent(type:String,data:Object=null )
		{
			super(type);
			if(data!=null)
				this.data = data;
		}

		override public function clone():Event
		{
			return new COPEvent(type,data);
		}
	}

}


