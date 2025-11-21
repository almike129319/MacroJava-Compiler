
import java.util.*;
import syntaxtree.*;

public class P5{
    public static void main(String args[]){
        try{
            Node root = new microIRParser(System.in).Goal();
            pass1<Object,Object> v1 = new pass1<>();
            root.accept(v1,null);

            HashMap<Integer,Blocktype> line_to_block = v1.line_to_block;

            // printBlocks(line_to_block);

            HashMap<String,Proctype> procs = v1.procedures;
            printIntervals(procs);

            // System.err.println("pass1 complete");

            pass2<Object,Object> v2 = new pass2<>();
            v2.procedures = v1.procedures;
            root.accept(v2,null);

        }
        catch(ParseException e){
            System.err.println(e.toString());
        }
    }

    public static void printBlocks(HashMap<Integer, Blocktype> line_to_block) {
        for (Map.Entry<Integer, Blocktype> entry : line_to_block.entrySet()) {
            Blocktype block = entry.getValue();
            System.out.println("Line " + entry.getKey() + ":");
            System.out.println("Name : "+ block.name);
            System.out.println("  lnumber        = " + block.lnumber);
            System.out.println("  next_lnumber   = " + block.next_lnumber);
            System.out.println("  jump_label     = " + block.jump_label);
            System.out.println("  next_block     = " + 
                (block.next_block != null ? block.next_block.lnumber : "null"));
            System.out.println("  jump_block     = " + 
                (block.jump_block != null ? block.jump_block.lnumber : "null"));
            System.out.println("  def_var        = " + block.def_var);
            System.out.println("  use_var        = " + block.use_var);
            System.out.println("  in_var         = " + block.in_var);
            System.out.println("  out_var        = " + block.out_var);
            System.out.println("-----------------------------------");
        }
    }

    public static void printIntervals(HashMap<String,Proctype> procedures) {
        
        for (Proctype proc : procedures.values()) {
            if(proc.name.equals("LL_Start")||proc.name.equals("LS_Search")) {
            // if(false){
            System.err.println("Procedure: " + proc.name);
            System.err.println("-----------------------------------");

            if (proc.intervals.isEmpty()) {
                System.err.println("  (No intervals)");
            } else {
                for (Intervaltype interval : proc.intervals_map.values()) {
                    System.err.println("  Temp: " + interval.temp +
                                    " | Start: " + interval.start +
                                    " | End: " + interval.end +
                                    " | Reg: " + interval.reg +
                                    " | Loc: " + interval.stack_loc);
                }
            }

            System.err.println();
            }
        }
    }



}