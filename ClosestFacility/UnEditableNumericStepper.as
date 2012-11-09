package widgets.ClosestFacility
{
	import mx.controls.NumericStepper;
	import mx.core.mx_internal;

	public class UnEditableNumericStepper extends NumericStepper
	{
		use namespace mx_internal;
		public function UnEditableNumericStepper()
		{
			super();
		}
		
		override protected function createChildren():void
    	{
    		super.createChildren();
    		mx_internal::inputField.editable = false;
    	}
	}
}