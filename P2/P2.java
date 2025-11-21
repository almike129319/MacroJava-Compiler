import java.util.HashMap;
import syntaxtree.*;

public class P2 {
   public static void main(String [] args) {

      try {
         
         Node root = new MiniJavaParser(System.in).Goal();
         // Invoke the parser, match the Goal production and return the
         // syntax tree.

	      visitor_pass1 v1 = new visitor_pass1();
         // pass the visitor to each syntax tree node.
         root.accept(v1,null);
         
         HashMap<String,ClassInfo> classes = v1.classes;   
         // print_classes(classes);
         parent_exists(classes);

         visitor_pass2<Object,Object> v2 = new visitor_pass2<>();
         v2.classes = classes;

         root.accept(v2,null);
         System.out.println("Program type checked successfully");
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
      catch (TypeCheckException e){
         System.out.println(e.getMessage());
      }
      catch (RuntimeException e){
         System.out.println("Program type checked successfully");
      }
   }

   public static boolean parent_exists(HashMap<String,ClassInfo> classes){

      for(String cname : classes.keySet()){
         if(classes.get(cname).parent == null) continue;
         String parname = classes.get(cname).parent;
         if(!classes.containsKey(parname)) throw new TypeCheckException("Symbol not found");
      }
      return true;
   }

   public static void print_classes(HashMap<String,ClassInfo> classes){
      for(HashMap.Entry<String,ClassInfo> entry : classes.entrySet()){
         System.out.println("class " + entry.getKey());
         
         if(entry.getValue().parent != null){
            System.out.println("par : "+entry.getValue().parent);
         }

         for(HashMap.Entry<String,Variable> var_entry : entry.getValue().variables.entrySet()){
            System.out.println("    "+var_entry.getValue().type + var_entry.getValue().name);
         }
         for(String str : entry.getValue().methods.keySet()){
            Method m = entry.getValue().methods.get(str);
            System.out.println("    "+m.return_type+" "+m.name);
               for(String str1 : m.arg_list.keySet()){
                  Variable v = m.arg_list.get(str1);
                  System.out.println("          "+v.type + " " + v.name);
               }
         }
      }
   }
}

