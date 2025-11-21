
import syntaxtree.Goal;

public class P4{
    public static void main(String args[]){
        try{
            Goal root = new MiniIRParser(System.in).Goal();

            converter<Object,Object> c = new converter<>();
            c.visit(root,null);
            
        }
        catch(ParseException e){
            System.err.println(e.toString());
        }
    }

}