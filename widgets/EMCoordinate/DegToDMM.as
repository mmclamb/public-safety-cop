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