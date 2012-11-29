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
package widgets.PDC.utils {


	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import widgets.PDC.ui.textContainer1;

	public class LegendBlock extends Sprite {
		private var title_mc: Object;
		private var title_mc1: Object;
		public var type		: String;
		public var id		: int;

		public function LegendBlock(master:*, type:String, id:int, description:String, url:String, fields:Array, titleHeight:int=48):void {
			this.type = type;
			this.id = id;

			title_mc1 = addChild(new textContainer());
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFFFFFF;
			format.bold=true;
			format.size=10;

			//new textContainer().getChildAt(
			title_mc = addChild(new textContainer1());
			title_mc.title_descrtxt.multiline = true;
			title_mc.title_descrtxt.defaultTextFormat=format
			title_mc.title_descrtxt.y=0;
			title_mc.title_descrtxt.autoSize = TextFieldAutoSize.LEFT;
			title_mc.title_descrtxt.height = titleHeight;
			title_mc.title_linktxt.multiline = true;
			title_mc.title_linktxt.autoSize = TextFieldAutoSize.LEFT;
			title_mc.title_linktxt.defaultTextFormat=format
			title_mc.title_linktxt.height = titleHeight;
			title_mc.title_descrtxt.htmlText ='<b><font size="12" face="verdana" color="#FFFFFF">' + type + '</font></b><font size="10" color="#FFFFFF">' + (description == '' ? '' : '<br>' + description) + '<br></font>';//'<b><font size="12">' + type + '</font></b>' + (description == '' ? '' : '<br>' + description) + '<br><font color="#80CBFD"><u><a   href="' + url + '" target="_blank">Click to view metadata summary</a></u></font>';
			title_mc.title_linktxt.y=title_mc.title_descrtxt.height;
			title_mc.title_linktxt.htmlText='<font color="#80CBFD" face="verdana" ><u><a   href="' + url + '" target="_blank">Click to view metadata summary</a></u></font>'

			var mc:MovieClip= new MovieClip();
			mc.addChild(title_mc.title_descrtxt);

			mc.addChild(title_mc.title_linktxt);
			addChild(mc);
			title_mc.title_linktxt.addEventListener(MouseEvent.CLICK, function onLink(e:MouseEvent):void{
				var int:int =(e.currentTarget as TextField).getLineIndexAtPoint(e.localX,e.localY);

				navigateToURL( new URLRequest(url), "_blank" );

			});

			for(var i:int=0;i<fields.length;i++){
				trace(i, fields[i]);
				var item:legend_item_mc = new legend_item_mc();

					item.title_txt.autoSize = TextFieldAutoSize.LEFT;
					item.title_txt.text = fields[i];
					var icon:* = master.bindedImages.getLegendIcon(fields[i]);
						icon.x = int(.5 * (item.title_txt.x - icon.width));
						icon.y = int(.5 * (item.height - icon.height)) + 1;
					item.addChild(icon);
					item.y = mc.height + 10 + i * 31;
				addChild(item);
			};
			/*var delimiter:MovieClip = new legend_delimiter();
				delimiter.y = item.y + item.height + 10;
			addChild(delimiter);*/
		};
	};


};