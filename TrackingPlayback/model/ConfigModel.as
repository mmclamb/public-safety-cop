////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2008-2011 Esri
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// License.txt and/or use_restrictions.txt.
//
////////////////////////////////////////////////////////////////////////////////
package widgets.TrackingPlayback.model
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.TimeExtent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.supportClasses.LayerDetails;
	import com.esri.ags.layers.supportClasses.TableDetails;
	import com.esri.ags.layers.supportClasses.TimeInfo;
	import com.esri.ags.renderers.Renderer;
	import com.esri.stl.ags.utils.FieldsConfigUtil;
	
	import mx.collections.ArrayCollection;

	public class ConfigModel
	{
		public var helpIcon:String;
		public var helpText:String;
		
		public var mapSpatialReference:SpatialReference;
		
		//--------------------------------------------------------------------------
		// Fields configuration
		//--------------------------------------------------------------------------
		public var fieldsTrackingTableFieldsXML:XML;
		
		public var fieldsTrackingTableFieldsUtil:FieldsConfigUtil = new FieldsConfigUtil();
		
		//--------------------------------------------------------------------------
		// Service Tracking Layer configuration
		//--------------------------------------------------------------------------
		public var serviceTrackingLayerUrl:String;
		public var serviceTrackingLayerUseAMF:Boolean;
		public var serviceTrackingLayerToken:String;
		public var serviceTrackingLayerProxyURL:String;

		public var queryTrackingLayerDefaultQuery:String;
		public var queryTrackingLayerOutFieldsArr:Array;

		public var layerTrackingLayerDefaultDefinitionExpression:String;
		public var layerTrackingLayerDetails:LayerDetails;
		public var layerTrackingLayerTimeExtent:TimeExtent;
		public var layerTrackingLayerExtent:Extent;

		public var layerTrackingLayerTrackIDField:String;
		public var layerTrackingLayerSymbolDirectionAttribute:String;
		public var layerTrackingLayerLabelSymbolLabelAttribute:String;
		public var layerTrackingLayerForeignKey:String;
		
		//--------------------------------------------------------------------------
		// Playback UI configuration
		//--------------------------------------------------------------------------
		public var playbackViewDefaultStartDateTime:String;
		public var playbackViewDefaultEndDateTime:String;
		
		public var playbackViewDateRange:Object;
		
		public var playbackViewStartDateTime:Date;
		public var playbackViewEndDateTime:Date;
		
		public var playbackViewTimeExtent:TimeExtent;
		public var playbackViewTimeInterval:Number = 30;
		public var playbackViewTimeIntervalUnits:String = TimeInfo.UNIT_SECONDS;
		
		public var playbackViewTrackingTableDataGridColumns:Array;
		public var playbackViewTrackingTableDataProvider:ArrayCollection;
		
		public var playbackViewDefinitionExpression:String;
		
		//public var playbackViewFilterIsDirty:Boolean;
		public var playbackViewNumberOfAssets:int;
		
		public var layerTrackingLayerRenderer:Renderer;
		//--------------------------------------------------------------------------
		// Service Tracking Table configuration
		//--------------------------------------------------------------------------
		public var serviceTrackingTableUrl:String;
		public var serviceTrackingTableUseAMF:Boolean;
		public var serviceTrackingTableToken:String;
		public var serviceTrackingTableProxyURL:String;

		public var queryTrackingTableDefaultQuery:String;
		public var queryTrackingTableOutFieldsArr:Array;

		public var tableTrackingTableDetails:TableDetails;
		public var tableTrackingTablePrimaryKey:String;
		
		//--------------------------------------------------------------------------
		// Symbol configuration
		//--------------------------------------------------------------------------
		[Bindable]
		public var symbolTimeRampSymbolAgerFromColor:uint;
		[Bindable]
		public var symbolTimeRampSymbolAgerToColor:uint;
		[Bindable]
		public var symbolTimeRampSymbolAgerFromAlpha:Number;
		[Bindable]
		public var symbolTimeRampSymbolAgerToAlpha:Number;
		
		[Bindable]
		public var symbolObservationSMSAlpha:Number;
		[Bindable]
		public var symbolObservationSMSSize:Number;
		[Bindable]
		public var symbolObservationSMSStyle:String;
		[Bindable]
		public var symbolObservationSMSOutlineWidth:Number;
			
		
		
		private static var instance:ConfigModel;
		
		public function ConfigModel()
		{
			if (instance)
			{
				throw new Error("Please call ConfigModel.getInstance() instead of new.");
			}
		}
		public static function getInstance():ConfigModel
		{
			if (!instance)
			{
				instance = new ConfigModel();
			}
			return instance;
		}
	}
}