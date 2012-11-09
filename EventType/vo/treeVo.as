package widgets.EventType.vo
{
	public class treeVo
	{
		import mx.collections.ArrayCollection;
		public var name:String;
		public var children:ArrayCollection;
		public var state:String;
		public var checked:String;
		public function treeVo(_name:String=null, _children:ArrayCollection = null,_state:String='unchecked',_checked:String='0')
		{
			this.name = _name;
			this.state = _state;
			this.checked = _checked;
			if(_children != null)
				this.children = _children;
		}
		
		
		
		

	}
}