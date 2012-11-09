	package widgets.BombThreat.utils
	{   
		import flash.net.SharedObject;
		
		import mx.collections.ArrayCollection;

		[Bindable]
		public class DataParserUtils
		{
			private static var instance : DataParserUtils;
			
			public static const BOMBGRAPHICLAYER:String = 'bombGraphicLayer';
			public var mandatoryBufferColor:String;
			public var preferrdBufferColor:String;			
			
			
			/**
			 * Constructor of DataParserUtil.
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