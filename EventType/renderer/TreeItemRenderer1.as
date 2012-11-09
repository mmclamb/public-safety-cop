
package widgets.EventType.renderer
{

	import com.esri.viewer.ViewerContainer;
	import com.esri.viewer.AppEvent;
	
	import flash.events.MouseEvent;
	import flash.xml.*;
	
	import mx.collections.*;
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.controls.Tree;
	import mx.controls.listClasses.*;
	import mx.controls.treeClasses.*;
	
	import widgets.EventType.event.COPEvent;


/**
 * A custom tree item renderer for a map Table of Contents.
 */
public class TreeItemRenderer1 extends TreeItemRenderer
{
	protected var myImage:Image;
	
	// set image properties
	private var imageWidth:Number 	= 6;
	private var imageHeight:Number 	= 6;
	private var inner:String 	= "inner.png";
	
	protected var myCheckBox:CheckBox;
	
	static private var STATE_SCHRODINGER:String = "schrodinger";
	static private var STATE_CHECKED:String = "checked";
	static private var STATE_UNCHECKED:String = "unchecked";
	
	
	private static const PRE_CHECKBOX_GAP:Number = 5;
	private static const POST_CHECKBOX_GAP:Number = 4;
	
	public var itemXml:XML;
	
	private var dataObject:Object;
	private var layerDetails:Array= new Array();
	
	
	public function TreeItemRenderer1(){
		super();
		mouseEnabled = false;
	}
	
	private function toggleParents (item:Object, tree:Tree, state:String):void
	{
		if (item == null)
		{
			return;
		}
		else
		{
			item.@state = state;
			
			
			
			toggleParents(tree.getParentItem(item), tree, getState (tree, tree.getParentItem(item)));
		}
	}
	

	private function toggleChildren (item:Object, tree:Tree, state:String):void
	{
		if (item == null)
		{
			return;
		}
		else
		{
			item.@state = state;
			var treeData:ITreeDataDescriptor = tree.dataDescriptor;
			if (treeData.hasChildren(item))
			{
				
				var children:ICollectionView = treeData.getChildren (item);
			
				//this for multiple item checked
				var layerDetails1:XMLListCollection=children as XMLListCollection ;
				var cursor:IViewCursor = children.createCursor();
				while (!cursor.afterLast)
				{
					
					toggleChildren(cursor.current, tree, state);
					cursor.moveNext();
				}
				
			}
			else
			{
				trace('child')
				
				
				
			}
		
			
		}
	}
	
	private function getState(tree:Tree, parent:Object):String
	{
		var noChecks:int = 0;
		var noCats:int = 0;
		var noUnChecks:int = 0;
		if (parent != null)
		{
			var treeData:ITreeDataDescriptor = tree.dataDescriptor;
			var cursor:IViewCursor = treeData.getChildren(parent).createCursor();
			while (!cursor.afterLast)
			{
				if (cursor.current.@state == STATE_CHECKED)
				{
					noChecks++;
				}
				else if (cursor.current.@state == STATE_UNCHECKED)
				{
					noUnChecks++
				}
				else
				{
					noCats++;
				}
				cursor.moveNext();
			}
		}
		if ((noChecks > 0 && noUnChecks > 0) || (noCats > 0))
		{
			return STATE_SCHRODINGER;
		}
		else if (noChecks > 0)
		{
			return STATE_CHECKED;
		}
		else
		{
			return STATE_UNCHECKED;
		}
	}
	private function imageToggleHandler(event:MouseEvent):void
	{
		myCheckBox.selected = !myCheckBox.selected;
		checkBoxToggleHandler(event);
	}
	private function checkBoxToggleHandler(event:MouseEvent):void
	{
		if (data)
		{
			
			var myListData:TreeListData = TreeListData(this.listData);
			var selectedNode:Object = myListData.item;
			var tree:Tree = Tree(myListData.owner);
			var toggle:Boolean = myCheckBox.selected;
			dataObject= new Object();
			layerDetails= new Array();
			var obj:Object;
			var arrleafs:ArrayCollection=new ArrayCollection();
			
			if (toggle)
			{
				dataObject.isVisible=STATE_CHECKED;
				toggleChildren(data, tree, STATE_CHECKED);
			}
			else
			{
				dataObject.isVisible=STATE_UNCHECKED;
				toggleChildren(data, tree, STATE_UNCHECKED);
			}
			
			
			var parent:Object = tree.getParentItem (data);
			toggleParents (parent, tree, getState (tree, parent));
			var parentIsSelected:Boolean=false;
			var parentName:String='';
			var arrleafsTypes:ArrayCollection=new ArrayCollection();
			if(tree.dataDescriptor.hasChildren(data))
			{
				var children:ICollectionView = tree.dataDescriptor.getChildren (data);
				
				dataObject.type=data.@type.toString()
				
				for each(var itemXml:XML in children)
				{
					if(itemXml.@type.toString()=='feature'){
						obj= new Object();
						obj.id=itemXml.@label.toString()
						obj.type=itemXml.@type.toString();	
						arrleafs.addItem(obj);
					}
					else
					{
						var subchildren:ICollectionView=tree.dataDescriptor.getChildren (itemXml);
						dataObject.rootId=itemXml.@label.toString()			
						if(subchildren.length==0)  // only a single node
						{
										
							if(dataObject.type!='')
								arrleafs.addItem(itemXml.@id.toString());
							else
							{
								parentIsSelected=true;
								obj= new Object();
								parentName=itemXml.@label.toString()
								obj.rootId=itemXml.@label.toString()
								obj.type=itemXml.@type.toString();	
								arrleafs.addItem(obj);
								arrleafsTypes.addItem(itemXml.@id.toString())
							}
						}
						else // its having children
						{
							// Has leafs
							parentIsSelected=true;
							
							for each(var itemXml1:XML in subchildren)
							{
								if(dataObject.type!='')
									arrleafs.addItem(itemXml1.@id.toString());
								else
								{
									obj= new Object();
									
									obj.rootId=itemXml.@label.toString()
									obj.type=itemXml1.@type.toString();	
									arrleafs.addItem(obj);
									arrleafsTypes.addItem(itemXml1.@id.toString())
								}
								
							}
							
						
						}
					}	
					
				}
				dataObject.leafId=arrleafs;
				
				if(parentIsSelected==true)
				{
					dataObject.leafIdsIds=arrleafsTypes;
				}
				else
					dataObject.rootId=data.@label.toString();
				
				layerDetails.push(dataObject);
				
				
			}
			else
			{
				/**
				 * Leaf Selection & its child selection
				 */ 
				dataObject.type=data.@type.toString()
				/*if(data.@type.toString()=='feature')
				{	
					if(data.@rootId.toString()=='')
					{
						dataObject.rootId=data.@rootId.toString();
						arrleafs.addItem(data.@label.toString());
					}
					dataObject.leafId=arrleafs;
				}
				else
				{
					if(data.@rootId.toString()=='')
					{
						arrleafs.addItem(data.@id.toString());
						dataObject.rootId=data.@label.toString();
					}
					else{
						dataObject.rootId=data.@rootId.toString();
						arrleafs.addItem(data.@id.toString());
					}
					dataObject.leafId=arrleafs;
				}*/
				
				dataObject=setLeafData(data,dataObject.isVisible);
				layerDetails.push(dataObject);
			
			}
				
			var obj1:Object= new Object();
			obj1.layerdata=layerDetails;
			AppEvent.dispatch(COPEvent.SET_LAYER_VISIBLE_ON_OFF,obj1);
			
		}
	}
	
	private function setLeafData(data:Object,visible:String):Object{
		var dataObject:Object= new Object;
		var arrleafs:ArrayCollection=new ArrayCollection();
		dataObject.type=data.@type.toString()
		dataObject.isVisible=visible;
		if(data.@type.toString()=='feature')
		{	
			if(data.@rootId.toString()!=null)
			{
				dataObject.rootId=data.@rootId.toString();
				
			}
			else
			{
				dataObject.rootId=data.@label.toString();
				
			}
			dataObject.leafId=data.@label.toString();
			//dataObject.leafId=arrleafs;
		}
		else
		{
			if(data.@rootId.toString()=='')
			{
				arrleafs.addItem(data.@id.toString());
				dataObject.rootId=data.@label.toString();
			}
			else{
				dataObject.rootId=data.@rootId.toString();
				arrleafs.addItem(data.@id.toString());
			}
			dataObject.leafId=arrleafs;
		}
		return dataObject;
	}
	
	
	override protected function createChildren():void
	{
		super.createChildren();
		myCheckBox = new CheckBox();
		myCheckBox.setStyle( "verticalAlign", "middle" );
		myCheckBox.addEventListener( MouseEvent.CLICK, checkBoxToggleHandler );
		addChild(myCheckBox);
		myImage = new Image();
		myImage.source = inner;
		myImage.addEventListener( MouseEvent.CLICK, imageToggleHandler );
		myImage.setStyle( "verticalAlign", "middle" );
		addChild(myImage);
		
	}	
	
	private function setCheckState (checkBox:CheckBox, value:Object, state:String):void
	{
		if (state == STATE_CHECKED)
		{
			checkBox.selected = true;
		}
		else if (state == STATE_UNCHECKED)
		{
			checkBox.selected = false;
		}
		else if (state == STATE_SCHRODINGER)
		{
			checkBox.selected = false;
		}
	}	    
	override public function set data(value:Object):void
	{
		super.data = value;
		
		setCheckState (myCheckBox, value, value.@state);
		if(TreeListData(super.listData).item.@type == 'dimension')
		{
			setStyle("fontStyle", 'italic');
		}
		else
		{
			if (this.parent != null)
			{
				var _tree:Tree = Tree(this.parent.parent);
				_tree.setStyle("defaultLeafIcon", null);
			}
			setStyle("fontStyle", 'normal');
		}
	}
	override protected function measure():void
	{
		super.measure();
		
		// Add space for the checkbox and gaps
		if (isNaN(explicitWidth) && !isNaN(measuredWidth))
		{
			var w:Number = measuredWidth;
			w += myCheckBox.measuredWidth;
			w += PRE_CHECKBOX_GAP + POST_CHECKBOX_GAP;
			measuredWidth = w;
		}
	}
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var startx:Number = data ? TreeListData(listData).indent : 0;
		if (icon)
		{
			startx = icon.x;
		}
		else if (disclosureIcon)
		{
			startx = disclosureIcon.x + disclosureIcon.width;
		}
		startx += PRE_CHECKBOX_GAP;
		
		// Position the checkbox between the disclosure icon and the item icon
		myCheckBox.x = startx;
		myCheckBox.setActualSize(myCheckBox.measuredWidth, myCheckBox.measuredHeight);
		myCheckBox.y = (unscaledHeight - myCheckBox.height) / 2;
		startx = myCheckBox.x + myCheckBox.width + POST_CHECKBOX_GAP;
		
		if (icon)
		{
			icon.x = startx;
			startx = icon.x + icon.width;
		}
		
		label.x = startx;
		label.setActualSize(unscaledWidth - startx, measuredHeight);
		
	}
}

}
