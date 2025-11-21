import java.util.*;

public class Method{
    public String name;
    public String return_type;
    public HashMap<String,Variable> arg_list = new HashMap<>();
    public ArrayList<Variable> arg_list_ordered = new ArrayList<>();

    public HashMap<String,Variable> var_decl = new HashMap<>();
    public String classname;

    public void make_arg_map(){
        for(Variable v : arg_list_ordered){
            arg_list.put(v.name,v);
        }
    }

    public Method(){}
    public Method(String name){
        this.name = name;
    }
    public Method(String return_type,String name){
        this.name = name;
        this.return_type  = return_type;
    } 

}