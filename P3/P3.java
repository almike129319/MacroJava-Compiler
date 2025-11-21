import java.util.*;
import syntaxtree.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();

         // System.err.println("Program parsed successfully");

	      pass1<Object,Object> v = new pass1<>();
         root.accept(v,null);
         HashMap<String,ClassInfo> classes = v.classes;
         // print_classes(classes);
         // System.err.println("pass1 complete");
         
         pass2<Object,Object> v2 = new pass2<>();
         v2.classes = classes;
         root.accept(v2,null);

      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }

    public static void print_classes(HashMap<String,ClassInfo> classes){
      for(HashMap.Entry<String,ClassInfo> entry : classes.entrySet()){
         ClassInfo c = entry.getValue();
         System.err.println("class " + entry.getKey());
         
         if(entry.getValue().parent != null){
            System.err.println("\tpar : "+entry.getValue().parent);
         }
         for(String m : c.methods){
            System.err.println("\tmethod : "+ m);
            System.err.println("\t\t");
            System.err.println(c.meth_arg_types);
            // for(String arg_type : c.meth_arg_types.get(m))
               // System.err.print(arg_type+",");
         }
         for(String v : c.variables)
            System.err.println("\tvar: "+v);
         // for(String vt : c.types_var.keySet()){
         //    System.err.println("type of "+vt+" : "+c.types_var.get(vt));
         // }
         for(String vt : c.types_meth.keySet()){
            System.err.println("ret type of "+vt+" : "+c.types_meth.get(vt));
         }
      }
   }
   
}
