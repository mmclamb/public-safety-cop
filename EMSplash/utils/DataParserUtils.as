	package widgets.EMSplash.utils
	{
		import flash.net.SharedObject;

		import mx.collections.ArrayCollection;

		[Bindable]
		public class DataParserUtils
		{
			private static var instance : DataParserUtils;

			public var sharedObj:SharedObject;

			public var esfRolesArr:ArrayCollection= new ArrayCollection();
			public var eventArr:Array= new Array();
			public var widgetTitle:String='';
			public var eventGroupTitle:String='';
			public var saveBtnLabel:String='';

			public var windowsUrl:String;

			/**
			 * Constructor of DataParserUtil.
			 *
			 * @param enforcer instance of class SingletonEnforcer
			 */
			public function DataParserUtils(enforcer:SingletonEnforcer=null)
			{
				if(enforcer == null)
				{
					//trace("ApplicationController is a singleton.use getInstance() to access it")
				}
				else
				{
					//Dispatches event for InfoWindow.

				}

			}

			public static function getInstance() : DataParserUtils
			{
				if (instance == null ){
					instance = new DataParserUtils(new SingletonEnforcer);
				}
				return instance;
			}

		}
	}

	class SingletonEnforcer{

	}