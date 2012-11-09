package widgets.EMHeaderController
{
	import flash.display.DisplayObject;

	import mx.controls.Image;
	import mx.controls.TextInput;
	import mx.core.mx_internal;

	use namespace mx_internal;



	public class MyTextInput extends TextInput
	{
		[Embed(source='assets/images/locate.png')]
		public var searchIcon:Class;
		public var searchImg:Image;

		public var _image:Image;

		public function MyTextInput()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();

			_image = new Image();
			_image.source = searchIcon;
			addChild(DisplayObject(_image));
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			this._image.width = 20;
			this._image.height = 20;
			this._image.buttonMode=true;
			this._image.x = this.width - this._image.width ;
			this._image.y = this.height - this._image.height;
			this.textField.width = this.width - this._image.width - 10;

		}
	}
}