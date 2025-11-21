public class Intervaltype{
    public String temp ;
    public int reg = -1;
    public int stack_loc = -1;

    public int start;
    public int end;
    
    public Intervaltype(){}
    public Intervaltype(String t,int s){
        temp = t;
        start = s;
    }
    public Intervaltype(String t,int s,int e){
        temp = t;
        start = s;
        end = e;
    }

}