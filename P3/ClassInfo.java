
import java.util.*;

public class ClassInfo{
    public String name;
    public ArrayList<String> variables = new ArrayList<>();
    public HashMap<String,String> types_var = new HashMap<>();
    public ArrayList<String> methods = new ArrayList<>();
    public HashMap<String,String> types_meth = new HashMap<>();
    public ArrayList<String> children = new ArrayList<>();
    public HashMap<String,ArrayList<String>> meth_arg_types = new HashMap<>();

    public String parent = null;

    public ClassInfo(){}
    public ClassInfo(String name){
        this.name = name;
    }
}