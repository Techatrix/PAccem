class Debugger {
	final DebuggerItem[] items;

	Debugger() {
		if(deb) {
			println("Load Debugger");
		}
		items = new DebuggerItem[17];
		items[0] = new DebuggerItem("Name") {@ Override public String getvalue() {return rm.name;}};
		items[1] = new DebuggerItem("X-off") {@ Override public String getvalue() {return str(rm.xoff);}};
		items[2] = new DebuggerItem("Y-off") {@ Override public String getvalue() {return str(rm.yoff);}};
		items[3] = new DebuggerItem("Scale") {@ Override public String getvalue() {return str(rm.scale);}};
		items[4] = new DebuggerItem("3D X-off") {@ Override public String getvalue() {return str(rm.dxoff);}};
		items[5] = new DebuggerItem("3D Y-off") {@ Override public String getvalue() {return str(rm.dyoff);}};
		items[6] = new DebuggerItem("3D Z-off") {@ Override public String getvalue() {return str(rm.dzoff);}};
		items[7] = new DebuggerItem("Angle 1") {@ Override public String getvalue() {return str(rm.angle1);}};
		items[8] = new DebuggerItem("Angle 2") {@ Override public String getvalue() {return str(rm.angle2);}};
		items[9] = new DebuggerItem("X-gridsize") {@ Override public String getvalue() {return str(rm.xgridsize);}};
		items[10] = new DebuggerItem("Y-gridsize") {@ Override public String getvalue() {return str(rm.ygridsize);}};
		items[11] = new DebuggerItem("Gridtilesize") {@ Override public String getvalue() {return str(rm.gridtilesize);}};
		items[12] = new DebuggerItem("Tool") {@ Override public String getvalue() {return str(rm.tool);}};
		items[13] = new DebuggerItem("Viewmode") {@ Override public String getvalue() {return str(rm.viewmode);}};
		items[14] = new DebuggerItem("New Furnitureid") {@ Override public String getvalue() {return str(rm.newfurnitureid);}};
		items[15] = new DebuggerItem("New Roomtilegroup") {@ Override public String getvalue() {return str(rm.newroomtilegroup);}};
		items[16] = new DebuggerItem("Selectionid") {@ Override public String getvalue() {return str(rm.selectionid);}};
	}
}
abstract class DebuggerItem{
	String name;

	DebuggerItem(String newname) {
		name = newname;
	}

	abstract String getvalue();
}