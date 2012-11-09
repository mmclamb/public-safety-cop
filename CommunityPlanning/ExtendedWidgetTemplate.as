package widgets.CommunityPlanning
{
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.ViewerContainer;
	import com.esri.viewer.WidgetTemplate;

	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class ExtendedWidgetTemplate extends WidgetTemplate
	{

		public function ExtendedWidgetTemplate()
		{
			super();
		}

		/**
		 *
		 * On clicking close button if graphicslayer contains any unsaved graphics
		 * user is asked if he wants to clear all unsaved data
		 */
		override protected function close_clickHandler(event:MouseEvent):void
		{
			if((((this.parent as CommunityPlanningWidget).map.getLayer("communityPlanningGraphicsLayer") as GraphicsLayer).graphicProvider as ArrayCollection).length > 0)
			{
				Alert.show("Are you sure you want to close without saving?\nAll the unsaved features will be cleared.","Confirm",(Alert.YES|Alert.NO),null,confirmHandler);
			}
			else
			{
				super.widgetState = "closed";

				var data:Object =
					{
						id: super.widgetId,
							state: super.widgetState
					};
				AppEvent.dispatch(AppEvent.WIDGET_STATE_CHANGED, data);
			}
		}

		/**
		 *
		 * If user selects yes, graphicslayer is cleared and widget is closed
		 */
		private function confirmHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				((this.parent as CommunityPlanningWidget).map.getLayer("communityPlanningGraphicsLayer") as GraphicsLayer).clear();
				super.widgetState = "closed";

				var data:Object =
					{
						id: super.widgetId,
						state: super.widgetState
					};
				AppEvent.dispatch(AppEvent.WIDGET_STATE_CHANGED, data);
			}
		}
	}
}