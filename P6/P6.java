
import syntaxtree.*;

public class P6{
    public static void main(String args[]){
        try{
            Node root = new MiniRAParser(System.in).Goal();
            pass1<Object,Object> v1 = new pass1<>();
            root.accept(v1,null);


        }
        catch(ParseException e){
            System.err.println(e.toString());
        }
    }

}