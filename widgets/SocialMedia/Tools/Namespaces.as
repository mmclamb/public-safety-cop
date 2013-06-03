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
package widgets.SocialMedia.Tools
{

public class Namespaces
{
    public static const ATOM_NS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
    public static const GEORSS_NS:Namespace = new Namespace("http://www.georss.org/georss");
    public static const GML_NS:Namespace = new Namespace("http://www.opengis.net/gml");
 	public static const MEDIA_NS:Namespace   = new Namespace("http://search.yahoo.com/mrss/");
	public static const YOUTUBE_NS:Namespace = new Namespace("http://gdata.youtube.com/schemas/2007");
	public static const TWITTER_NS:Namespace = new Namespace("http://api.twitter.com/");

    public function Namespaces(singletonEnforcer:SingletonEnforcer)
    {
    }
}

}

class SingletonEnforcer
{
}
