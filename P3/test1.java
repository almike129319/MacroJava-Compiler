class Case60 {
    public static void main(String[] a){
        System.out.println(new Ack().ack1(3,2));
    }
}

class Ack{
    public int ack1(int m, int n){
        int retval;
        System.out.println(m);
        if (!(m != 0)) {
            retval = n + 1;
            // System.out.println(m);
            // System.out.println(retval);
        }
        else if (!(m <= 0) && !(n != 0)) {
            retval = this.ack1((m - 1), 1);
            // System.out.println(2000);
            // System.out.println(retval);
        }
        else if (!(m <= 0) && !(n <= 0)) {
            retval = this.ack1((m - 1), (this.ack1(m, (n - 1))));
            // System.out.println(3000);
            // System.out.println(retval);
        } else {
            retval = 0;
            // System.out.println(4000);
            // System.out.println(retval);
        }
        return retval;
    }
}
