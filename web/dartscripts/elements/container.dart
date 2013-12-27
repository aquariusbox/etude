part of elements;
/*
 * bootstrap <div class="container">
 */
class Container {
  
  DivElement create(){
    DivElement div = new Element.div();
    div.classes.add("container");
    return div;
  }
}