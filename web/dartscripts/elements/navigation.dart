part of elements;

class Navigation extends View {

  String _activeTag = '';
  DivElement _navbar;
  DivElement _navbarHeader;
  DivElement _navbarCollapse;
  Map<String, String> actives = {"home":"t-home","rbase":"t-rbase"};
<<<<<<< HEAD
  Map<String, String> hrefs = {"home":"dry.html","md_page_of_rulebase":"md_of_rules.html","matrix_page_of_rulebase":"matrix_of_rules.html","update_rules_detail":"update_rules_detail.html"};
  Map<String, String> texts = {"home":"Home","md_page_of_rulebase":"Mapping Document","matrix_page_of_rulebase":"Matrix of rules","update_rules_detail":"Edit Rule"};
=======
  Map<String, String> hrefs = {"home":"dry.html","md_page_of_rulebase":"md_of_rules.html","matrix_page_of_rulebase":"matrix_of_rules.html","md_page_of_rulebase_blbc":"blbc_md_of_rules.html","matrix_page_of_rulebase_blbc":"blbc_matrix_of_rules.html"};
  Map<String, String> texts = {"home":"Home","md_page_of_rulebase":"Mapping Document - CT","matrix_page_of_rulebase":"Matrix of rules - CT","md_page_of_rulebase_blbc":"Mapping Document - BLBC","matrix_page_of_rulebase_blbc":"Matrix of rules - BLBC"};
>>>>>>> cf67c472752735f0865abf51d353e0f31368bc0d
  
  Navigation(){
    _navbar = new Element.div();
    _navbar.classes.add("navbar navbar-white");
    elements.add(_navbar);
    // Container 
    DivElement container = new Container().create();
    
    // Navbar header
    _navbarHeader = new Element.div();
    _navbarHeader.classes.add("navbar-header");
    ButtonElement navbarHeaderButton = new ButtonElement();
    navbarHeaderButton.attributes = {'type':'button','class':'navbar-toggle','data-toggle':'collapse','data-target':'.navbar-collapse'};
    _navbarHeader.nodes.add(navbarHeaderButton);
    SpanElement span0 = new SpanElement();
    span0.classes.add("icon-bar");
    SpanElement span1 = new SpanElement();
    span1.classes.add("icon-bar");
    SpanElement span2 = new SpanElement();
    span2.classes.add("icon-bar");
    navbarHeaderButton.nodes.add(span0);
    navbarHeaderButton.nodes.add(span1);
    navbarHeaderButton.nodes.add(span2);
    AnchorElement navbarHeaderAnchor = new AnchorElement();
    navbarHeaderAnchor.classes.add("navbar-brand");
    navbarHeaderAnchor.href = "#";
    navbarHeaderAnchor.text = "Dry";
    _navbarHeader.nodes.add(navbarHeaderAnchor);
    container.nodes.add(_navbarHeader);
    
    // Navbar collapse
    DivElement _navbarCollapse = new Element.div();
    _navbarCollapse.classes.add("navbar-collapse collapse");
    container.nodes.add(_navbarCollapse);
    UListElement ulNav = new UListElement();
    ulNav.classes.add("nav navbar-nav");
    _navbarCollapse.nodes.add(ulNav);
    LIElement liTDry = new LIElement();
    liTDry.id = actives["home"];
    ulNav.nodes.add(liTDry);
    AnchorElement anchorTDry = new AnchorElement();
    anchorTDry.href = hrefs["home"];
    anchorTDry.text = texts["home"];
    liTDry.nodes.add(anchorTDry);
    
    LIElement liTRbase = new LIElement();
    liTRbase.id = actives["rbase"];
    liTRbase.classes.add("dropdown");
    ulNav.nodes.add(liTRbase);
    AnchorElement anchorTRbase = new AnchorElement();
    anchorTRbase.attributes = {"name":"top","data-toggle":"dropdown"};
    anchorTRbase.text = "Rbase";
    anchorTRbase.href = "#";
    anchorTRbase.classes.add("dropdown-toggle");
    anchorTRbase.nodes.add(new Caret().create());

    liTRbase.nodes.add(anchorTRbase);
    UListElement dropdownRbase = new DropdownMenu().create();
    liTRbase.nodes.add(dropdownRbase);

    addPageAnchor(dropdownRbase, "md_page_of_rulebase_blbc");
    addPageAnchor(dropdownRbase, "md_page_of_rulebase");
<<<<<<< HEAD
    addPageAnchor(dropdownRbase, "matrix_page_of_rulebase");   
    addPageAnchor(dropdownRbase, "update_rules_detail");   
=======
    addPageAnchor(dropdownRbase, "matrix_page_of_rulebase_blbc");
    addPageAnchor(dropdownRbase, "matrix_page_of_rulebase");
>>>>>>> cf67c472752735f0865abf51d353e0f31368bc0d
    
    // Navbar Right
    UListElement ulNavbarRight = new UListElement();
    ulNavbarRight.classes.add("nav navbar-nav navbar-right");
    ulNavbarRight.nodes.add(new LIElement());
    ulNavbarRight.nodes.first.nodes.add(new Span().create("LOADING", "x-navbar-msg", "label label-warning hidden"));
    _navbarCollapse.nodes.add(ulNavbarRight);
    // build tree
    _navbar.nodes.add(container);
  }
  
  /*
   * Current active tag
   */
  void currentActive(String id){
    _activeTag = id;
    querySelector('#$_activeTag').className="active";
  }
  
  void addPageAnchor(UListElement parentUl, String refName){
    LIElement li = new LIElement();
    AnchorElement anchor = new AnchorElement(href: hrefs[refName]);
    anchor.text = texts[refName];
    li.nodes.add(anchor);
    parentUl.nodes.add(li);
  }
}

void loading(bool show){
  if(show)
    querySelector('#x-navbar-msg').classes.remove('hidden');
  else
    querySelector('#x-navbar-msg').classes.add('hidden');
}
