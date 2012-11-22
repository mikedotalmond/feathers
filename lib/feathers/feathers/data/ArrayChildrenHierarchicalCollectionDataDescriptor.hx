package feathers.data;
import flash.Vector;
/**
 * A hierarchical data descriptor where children are defined as arrays in a
 * property defined on each branch. The property name defaults to <code>"children"</code>,
 * but it may be customized.
 *
 * <p>The basic structure of the data source takes the following form. The
 * root must always be an Array.</p>
 * <pre>
 * [
 *     {
 *         text: "Branch 1",
 *         children:
 *         [
 *             { text: "Child 1-1" },
 *             { text: "Child 1-2" }
 *         ]
 *     },
 *     {
 *         text: "Branch 2",
 *         children:
 *         [
 *             { text: "Child 2-1" },
 *             { text: "Child 2-2" },
 *             { text: "Child 2-3" }
 *         ]
 *     }
 * ]</pre>
 */
extern class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The field used to access the Array of a branch's children.
	 */
	public var childrenField:String;// = "children";

	/**
	 * @inheritDoc
	 */
	public function getLength(data:Dynamic, rest:Array):Int;

	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Dynamic, index:Int, rest:Array):Dynamic;
	}

	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Dynamic, item:Dynamic, index:Int, rest:Array):Void;

	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Dynamic, item:Dynamic, index:Int, rest:Array):Void;

	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Dynamic, index:Int, rest:Array):Dynamic;

	/**
	 * @inheritDoc
	 */
	public function getItemLocation(data:Dynamic, item:Dynamic, result:Vector<Int> = null, rest:Array):Vector<Int>;
	
	/**
	 * @inheritDoc
	 */
	public function isBranch(node:Dynamic):Bool;

	/**
	 * @private
	 */
	private function findItemInBranch(branch:Array, item:Dynamic, result:Vector<Int>):Bool;
}
