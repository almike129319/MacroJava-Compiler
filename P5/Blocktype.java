import java.util.*;

public class Blocktype{

    public int lnumber;
    public int next_lnumber = -1;
    public String jump_label = null;
    public Blocktype next_block;
    public Blocktype jump_block;
    public String name;
    
    public Set<String> in_var = new HashSet<>();
    public Set<String> out_var = new HashSet<>();
    public Set<String> def_var = new HashSet<>();
    public Set<String> use_var = new HashSet<>();

    public Blocktype(){}
    public Blocktype(int l){
        lnumber = l;
    }
    
}