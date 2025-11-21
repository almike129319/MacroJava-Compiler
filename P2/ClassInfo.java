
import java.util.*;

public class ClassInfo{
    public String name;
    public HashMap<String,Variable> variables = new HashMap<>();
    public HashMap<String,Method> methods = new HashMap<>();
    public ArrayList<String> children = new ArrayList<>();
    
    public String parent = null;

    public ClassInfo(){}
    public ClassInfo(String name){
        this.name = name;
    }
}