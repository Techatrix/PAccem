class Debugger {
	private final DebuggerItem[] items;

	Debugger() {
		println("Load Debugger");
		items = new DebuggerItem[15];
		items[0] = new DebuggerItem("Name") {@ Override public String getvalue() {return rm.name;}};
		items[1] = new DebuggerItem("X-off") {@ Override public String getvalue() {return str(rm.xoff);}};
		items[2] = new DebuggerItem("Y-off") {@ Override public String getvalue() {return str(rm.yoff);}};
		items[3] = new DebuggerItem("Scale") {@ Override public String getvalue() {return str(rm.scale);}};
		items[4] = new DebuggerItem("Angle 1") {@ Override public String getvalue() {return str(rm.angle1);}};
		items[5] = new DebuggerItem("Angle 2") {@ Override public String getvalue() {return str(rm.angle2);}};
		items[6] = new DebuggerItem("X-gridsize") {@ Override public String getvalue() {return str(rm.xgridsize);}};
		items[7] = new DebuggerItem("Y-gridsize") {@ Override public String getvalue() {return str(rm.ygridsize);}};
		items[8] = new DebuggerItem("Gridtilesize") {@ Override public String getvalue() {return str(rm.gridtilesize);}};
		items[9] = new DebuggerItem("Tool") {@ Override public String getvalue() {return str(rm.tool);}};
		items[10] = new DebuggerItem("Setup") {@ Override public String getvalue() {return str(rm.setup);}};
		items[11] = new DebuggerItem("Viewmode") {@ Override public String getvalue() {return str(rm.viewmode);}};
		items[12] = new DebuggerItem("New Furnitureid") {@ Override public String getvalue() {return str(rm.newfurnitureid);}};
		items[13] = new DebuggerItem("New Roomtilegroup") {@ Override public String getvalue() {return str(rm.newroomtilegroup);}};
		items[14] = new DebuggerItem("Selectionid") {@ Override public String getvalue() {return str(rm.selectionid);}};
	}
}
abstract class DebuggerItem{
	String name;

	DebuggerItem(String newname) {
		name = newname;
	}

	abstract String getvalue();
}