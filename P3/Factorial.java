class Factorial${
    public static void main(String[] a){
        System.out.println(new Fac().ComputeFac((10+0))); // Initially it was 10. MiniJava/MicroJava code uses the older expression.
    }
}

class Fac {
    int na;
    int[] naa;
    public int ComputeFac(int num){
        int num_aux ;
        na = 1;
        naa = new int[3];
        naa[2] = 1;
        // System.out.println(naa[2]);
        if ((num <= 1)&&(num != 1)) // Initially it was num <= 0. MiniJava/MicroJava code uses the older expression.
            num_aux = (1+0) ; // Initially it was num_aux = 1. MiniJava/MicroJava code uses the older expression.
        else
            num_aux = num * (this.ComputeFac(num-1)) ;
        return num_aux ;
    }
}