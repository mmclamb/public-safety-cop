package widgets.PDC.utils {
	import com.esri.ags.layers.GraphicsLayer;
	
	public class GraphicsLayerExtended extends GraphicsLayer {
		private var _url:String;
		
		public function GraphicsLayerExtended():void {
			super();
		};
		
		public function set url(val:String):void {
			_url = url;
		};
		
		public function get url():String {
			return _url;
		};
	};
};