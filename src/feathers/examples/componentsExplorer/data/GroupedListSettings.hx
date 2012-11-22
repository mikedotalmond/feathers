package feathers.examples.componentsExplorer.data;

class GroupedListSettings
{
	public static inline var STYLE_NORMAL:String = "normal";
	public static inline var STYLE_INSET:String = "inset";

	public function new() {
		
	}

	public var isSelectable:Bool = true;
	public var hasElasticEdges:Bool = true;
	public var style:String = STYLE_NORMAL;
}
