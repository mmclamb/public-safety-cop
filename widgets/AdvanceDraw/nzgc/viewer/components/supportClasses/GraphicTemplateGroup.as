/*
 | Version 10.2
 | Copyright 2013 Esri
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
package widgets.AdvanceDraw.nzgc.viewer.components.supportClasses
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.collections.ArrayCollection;

	public class GraphicTemplateGroup extends EventDispatcher
	{
		public function GraphicTemplateGroup(target:IEventDispatcher=null)
		{
			super(target);
		}

		/* --------------
		Public Properties
		-------------- */

		/**
		 * The name of the graphic template group.
		 */
		[Bindable]
		public var name:String;

		/**
		 * The description of the graphic template group.
		 */
		[Bindable]
		public var description:String;

		/**
		 * The visibility status of the graphic template group in template pickers.
		 */
		[Bindable]
		public var visible:Boolean = true;


		private var _templates:Array = [];


		[Bindable]
		public function get templates():Array
		{
			if (!_templates)
				_templates = [];
			return _templates;
		}

		public function set templates(value:Array):void
		{
			if (value)
			{
				_templates = value;
			}
			else
			{
				_templates = [];
			}
		}

		public function addTemplate(value:GraphicTemplate):void
		{
			if (value)
			{
				// Set the templates name if not already set
				if (value.groupname && !name)
				{
					this.name = value.groupname;
				}
				else if (name && value.groupname != name)
				{
					value.groupname = this.name;
				}

				_templates.push(value);
			}
		}

		public function removeTemplate(value:GraphicTemplate):void
		{
			if (value && _templates.indexOf(value) > -1)
			{
				_templates.splice(_templates.indexOf(value),1);
			}
		}


		public function contains(value:GraphicTemplate):Boolean
		{
			var result:Boolean = false;
			if (_templates.indexOf(value) > -1)
			{
				result = true;
			}
			return result;
		}

	}
}