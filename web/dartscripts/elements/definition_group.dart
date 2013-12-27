part of elements;

/*
 * Component show definition for each rule.
 */
class DefinitionGroup extends View {
  DivElement _div;
  
  DefinitionGroup(){
    _div = new Element.div();
    _div.classes = ['container'];
    _div.id = 'definition';
  }
  
  /*
   * fingerprint is id unique identify a rule_ref setup
   * rule is current b2b_edi_rule_ref
   * meta is the meta data of b2b_edi_rule_ref
   */
  void bindData(String fingerprint, Map rule, Map meta){
    Element h4 = new Element.tag('h4');
    h4.text = 'Definition of ${rule['ruleName']}';
    _div.nodes.add(h4);
    // Prepare anchor
    Element anchor = new Element.a();
    anchor.attributes = {"name":fingerprint};
    anchor.text ="#";
    h4.nodes.add(anchor);
    
    Element p = new Element.p(); 
    p.id = 'description';
    p.innerHtml = meta != null ? meta['description'] : "No description";

    Element pre = new Element.pre();
    pre.classes = ['prettyprint lang-dart'];
    pre.text = meta != null ? meta['pseudocode'] : "No logic";
    
    anchor = new Element.a();
    anchor.attributes = {'href':'#top'};
    anchor.classes = ['anchor-top'];
    anchor.text = 'Back to top';
    
    _div.nodes.add(p);
    _div.nodes.add(pre);
    _div.nodes.add(anchor);
  }
  
  // Returns a list of elements to be added to DOM.
  List<Element> get elements {
    List<Element> result = new List();
    result.add(_div);
    return result;
  }    
}
