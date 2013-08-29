package widgets.EMCoordinate
{
	public class DegToDMM
	{
		// Constants to define the format.
		public static const LAT:String = "lat";
		
		public static const LON:String = "lon";
		
		/**
		 * Utility function to format a decimal degree number into a pretty string with degrees, minutes and seconds.
		 * @param decDeg the decimal degree number.
		 * @param decDir "lat" for a latitude number, "lon" for a longitude value.
		 * @return A pretty print string with degrees, minutes and seconds.
		 */
		public static function format(decDeg:Number, decDir:String):String
		{
			var d:Number = Math.abs(decDeg);
			var deg:Number = Math.floor(d);
			d = d - deg;
			var min:Number = new Number((d * 60).toPrecision(4));
			
			if (min == 60)
			{
				deg++;
				min = 0;
			}
			var smin:String = min < 10 ? "0" + min + "' " : min + "' ";
		
			var sdir:String = (decDir == LAT) ? (decDeg < 0 ? "S" : "N") : (decDeg < 0 ? "W" : "E");
			
			return deg + "\xB0 " + smin + sdir;
		}
	}
}