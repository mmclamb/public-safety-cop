package widgets.EMCoordinate
{
	import com.esri.ags.geod.geom.MoreUtils;
	import com.esri.ags.geometry.MapPoint;
	
	import flash.geom.Point;

	public final class DegToUSNG
	{
		
		public static const LAT:String = "lat";
		
		public static const LON:String = "lon";
		
		
		public static function format(mapPoint:MapPoint):String
		{
			
			var pt:Point = new Point(mapPoint.x, mapPoint.y);
			var a:String=MoreUtils.getMGRSString(pt.y, pt.x).toString();
			return MoreUtils.getMGRSString(pt.y, pt.x); 
			
		}
	}

}