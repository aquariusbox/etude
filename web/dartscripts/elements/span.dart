part of elements;

class Span{
  
  SpanElement create(String text, [String id, String _class]){
    SpanElement span = new SpanElement();
    span.text = text;
    if(id != null)
      span.id = id;
    if(_class != null)
      span.classes.add(_class);
    return span;
  }
  
}