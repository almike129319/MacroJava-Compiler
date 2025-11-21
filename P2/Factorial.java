import java.util.function.Function;

class Main {
  public static void main(String[] args) {
    System.out.println(new Child().exercise((((z) -> z)),12, new Parent()));
  }
}

class Parent {
  Function<Box,Box> f;
  int m(){
    return 4;
  }
}

class Child extends Parent {
  public int exercise(Function<Box,Box> f, int z, Parent k) {
    Box c;
    Child h ;
    Parent p;
    
    f = (((x) -> x));
    f = (y) -> y;   
    c = f.apply(new Box());
    return 5;
  }
  boolean m(  ){
      return true;
    }
}

class Box { }
