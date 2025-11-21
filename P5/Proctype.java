import java.util.*;

public class Proctype{
    public String name;
    public int args = 0;
    public int stack_slots;
    public int max_call_args = -1;
    public int sp = 0;
    public int temp_store_sp = 0;
    public ArrayList<Blocktype> blocks = new ArrayList<>();
    public HashMap<String,Intervaltype> intervals_map = new HashMap<>();
    public String spill_stat = "NOTSPILLED";
    public TreeSet<Intervaltype> intervals = new TreeSet<>(
        (a,b)->{
            if(a.temp.equals(b.temp)) return 0;
            else if(a.start >= b.start) return 1;
            return -1;
        }
    );

    public Proctype(){}
    public Proctype(String n){
        name = n;
    }

}