package widgets.PDC.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	final public class AssetExtractor extends Sprite {
		public function getAssetAsMovieClip(asset:String):MovieClip {
			try{
				return new (getDefinitionByName(asset) as Class)() as MovieClip;
			}catch(error:ArgumentError){
				//источник - не мувик. Битмапдата ?
				var _bmpdt = new (getDefinitionByName(asset) as Class)(0, 0) as BitmapData;
				if(_bmpdt is BitmapData){
					var mc:MovieClip = new MovieClip();
						mc.addChild(new Bitmap(_bmpdt));
					return mc;
				};
			};
			return null;
		};
		
		public function getAssetAsBitmap(asset:String):Bitmap {
			var _bmpdt;
			try{
				var _movie = new (getDefinitionByName(asset) as Class)() as MovieClip;
				if(_movie is MovieClip){
					var _movieRect:Rectangle = _movie.getRect(this);
					_bmpdt = new BitmapData(_movieRect.width, _movieRect.height, true, 0x00000000);
					_bmpdt.draw(_movie, new Matrix(1, 0, 0, 1, -_movieRect.x, -_movieRect.y));
					var _bmp:Bitmap = new Bitmap(_bmpdt);
						_bmp.x = _movieRect.x;
						_bmp.y = _movieRect.y;
					return _bmp;
				};
			}catch(error:ArgumentError){
				_bmpdt = new (getDefinitionByName(asset) as Class)(0, 0) as BitmapData;
				if(_bmpdt is BitmapData){
					return new Bitmap(_bmpdt);
				};
			};
			return null;
		};
		
		public function getAssetAsBitmapData(asset:String):BitmapData {
			try{
				return new (getDefinitionByName(asset) as Class)(0, 0) as BitmapData;
			}catch(error:ArgumentError){
				var _movie = new (getDefinitionByName(asset) as Class)() as MovieClip;
				if(_movie is MovieClip){
					var _movieRect:Rectangle = _movie.getRect(this);
					var _bmpdt:BitmapData = new BitmapData(_movieRect.width, _movieRect.height);
					_bmpdt.draw(_movie, new Matrix(1, 0, 0, 1, -_movieRect.x, -_movieRect.y));
					return _bmpdt;
				};
			};
			return null;
		};
	};
};