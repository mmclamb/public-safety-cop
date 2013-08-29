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