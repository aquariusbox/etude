part of elements;
/*
 * Create element <b class="caret"></b> 
 */
class Caret{
  
  Element create(){
    Element b = new Element.tag("b");
    b.classes.add("caret");
    return b;
  }
  
}