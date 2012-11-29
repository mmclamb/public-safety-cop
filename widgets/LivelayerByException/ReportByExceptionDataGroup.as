/*
 | Version 10.1.1
 | Copyright 2010 Esri
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
package widgets.LivelayerByException
{

    import mx.core.ClassFactory;
	import widgets.LivelayerByException.ReportByExceptionItemRenderer;

    import spark.components.DataGroup;

    // these events bubble up from the GeoRSSFeedItemRenderer
    [Event(name="rbeClick", type="flash.events.Event")]
    [Event(name="rbeMouseOver", type="flash.events.Event")]
    [Event(name="rbeouseOut", type="flash.events.Event")]

    public class ReportByExceptionDataGroup extends DataGroup
    {
        public function ReportByExceptionDataGroup()
        {
            super();
            this.itemRenderer = new ClassFactory(ReportByExceptionItemRenderer);
        }
    }

}
