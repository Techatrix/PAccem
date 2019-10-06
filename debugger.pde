class Debugger {
	DebuggerItem[] items;

	Debugger() {
		items = new DebuggerItem[13];
		items[0] = new DebuggerItem("Xoff") {@ Override public String getvalue() {return str(rm.xoff);}};
		items[1] = new DebuggerItem("Yoff") {@ Override public String getvalue() {return str(rm.yoff);}};
		items[2] = new DebuggerItem("Scale") {@ Override public String getvalue() {return str(rm.scale);}};
		items[3] = new DebuggerItem("Name") {@ Override public String getvalue() {return rm.name;}};
		items[4] = new DebuggerItem("Selectionid") {@ Override public String getvalue() {return str(rm.selectionid);}};
		items[5] = new DebuggerItem("Xgridsize") {@ Override public String getvalue() {return str(rm.xgridsize);}};
		items[6] = new DebuggerItem("Ygridsize") {@ Override public String getvalue() {return str(rm.ygridsize);}};
		items[7] = new DebuggerItem("Gridtilesize") {@ Override public String getvalue() {return str(rm.gridtilesize);}};
		items[8] = new DebuggerItem("Tool") {@ Override public String getvalue() {return str(rm.tool);}};
		items[9] = new DebuggerItem("Viewmode") {@ Override public String getvalue() {return str(rm.viewmode);}};
		items[10] = new DebuggerItem("Newfurniturewidth") {@ Override public String getvalue() {return str(rm.newfurniturewidth);}};
		items[11] = new DebuggerItem("Newfurnitureheight") {@ Override public String getvalue() {return str(rm.newfurnitureheight);}};
		items[12] = new DebuggerItem("Newroomtilegroup") {@ Override public String getvalue() {return str(rm.newroomtilegroup);}};
	}


}
abstract class DebuggerItem{
	String name;

	DebuggerItem(String newname) {
		name = newname;
	}

	abstract String getvalue();
}