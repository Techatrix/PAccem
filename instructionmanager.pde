class InstructionManager {
	ArrayList<Instruction> instructions;

	/* Instructions:
	 * 
	 * settilestate
	 * fill tool
	 * place furniture
	 * move furniture
	 * remove furniture
	 * place window
	 * remove window
	 * new room
	 * 
	 * 
	 * 
	 * 
	 */

	InstructionManager() {
		instructions = new ArrayList<Instruction>();
	}

	void undo() {
		toovmessages.add("Undo");
		if(instructions.size() > 0) {
			HashMap<String,Object> dt = instructions.get(instructions.size() - 1).data;
			int id = (int)dt.get("id");
			println(id);
			switch(id) {
				case 0: // settilestate
				int xpos = (int)dt.get("xpos");
				int ypos = (int)dt.get("ypos");
				settilestateraw(xpos, ypos);
				break;
				case 1: // multi settilestate
				rm.roomgrid.tiles = ((GridTile[][])dt.get("tiles"));
				break;
			}
            instructions.remove(instructions.size() - 1);
		}
	}

	void setTool(int i) {
		rm.tool = i;
	}

	void settilestate(int xpos, int ypos) {
		settilestateraw(xpos, ypos);
		HashMap<String,Object> dt = new HashMap<String,Object>();
		dt.put("id", 0);
		dt.put("xpos", xpos);
		dt.put("ypos", ypos);
		instructions.add(new Instruction(dt));
	}
	void settilestateraw(int xpos, int ypos) {
		rm.settilestate(xpos, ypos);
	}
	void setmultitilestate(int xpos, int ypos) {
		HashMap<String,Object> dt = new HashMap<String,Object>();
		dt.put("id", 1);
		dt.put("tiles", rm.roomgrid.tiles);
		instructions.add((new Instruction(dt)).clone());
		setmultitilestateraw(xpos, ypos);
	}
	void setmultitilestateraw(int xpos, int ypos) {
		rm.filltool(xpos,ypos);
	}
	String execcommand(String cmd) {
		String[] a = split(cmd, " ");
		if(a.length > 0) {
			boolean found = false;
			if(a.length > 1) {
				println("Parameter: ");
				for (int i=0;i<a.length-1;i++) {
					println(a[i+1]);
				}
			}
			switch(a[0]) {
				case "undo":
					found = true;
					undo();
				break;
			}
			if(found) {
				return a[0];
			} else {
				return "cant find command: " + a[0];
			}
		}
		return " ";
	}

}
class Instruction implements Cloneable {
	HashMap<String,Object> data;

	Instruction(HashMap<String,Object> data) {
		this.data = data;
	}
	@Override
	public Instruction clone() {
		try {
			Instruction d = (Instruction) super.clone();
			return d;
		} catch (CloneNotSupportedException e) {
			println("CloneNotSupportedException in Instruction");
            return null;
        }
	}
}