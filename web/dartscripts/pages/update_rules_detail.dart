import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:js' as javascript;
import 'package:json/json.dart' as json;
import '../elements/elements.dart';
import '../network/http.dart';
import '../entities/calc_rule_group.dart';
import '../javascript/prettyprint.dart' as pp show prettyPrint;

// Servlet service path
const REMOTE_SERVICE = '/dry/service-rules-usage';
const REMOTE_SERVICE_EDIT = '/dry/service-rules-edit';

const X_CALC_RULE_GROUPS = '#x-calc-rule-groups';



// Height of matrix table
const int MATRIX_HEIGHT = 1400;
// Heading of matrix table
const MATRIX_HEADING = 'Rules / PMT';
// UI elements
SelectElement datasources = new SelectElement();
SelectElement formats = new SelectElement();
SelectElement tps = new SelectElement();
ButtonElement btnrefresh = new ButtonElement();

ButtonElement btnSearch = new ButtonElement();
InputElement inputSearch;

Map metas;

main(){ 
 
  // Add navigation
  Navigation navigation = new Navigation();
  add2Dom(navigation, querySelector("#x-navigation"));
  navigation.currentActive(navigation.actives["rbase"]);
  
//  // Download option value from remote server and add to select elements
//  initOptions();
//  
  // Prepare refresh button
  btnSearch = querySelector("#x-search");
  inputSearch = querySelector("#x-searchbox");
  
//  
//  // Add bootstrap CSS to selections
//  datasources.classes.add("form-control");
//  formats.classes.add("form-control");
//  tps.classes.add("form-control");
//  
//  // Add selections to HTML
//  querySelector("#x-datasource").nodes.add(datasources);
//  querySelector("#x-formats").nodes.add(formats);
//  querySelector("#x-tps").nodes.add(tps);
//  
//  // Bind event listeners
  bind();
}

void submitSearch(Event e) {
  var body = inputSearch.value;
  String jsonData = '{"action":"search","body":$body}'; 
  HttpRequest.requestCrossOrigin(getBaseUrl(REMOTE_SERVICE_EDIT),
      method: 'POST',
      sendData: jsonData).then((req) =>
        renderCalcRuleGroups(JSON.decode(req))
      ).catchError((e) => print(e));
}

/*
void submitSearch(Event e){
  print("submitForm"); 
  print(inputSearch.value); 
  HttpRequest request = new HttpRequest(); // create a new XHR
  // POST the data to the server
  var url = getBaseUrl(REMOTE_SERVICE_EDIT);
  request.open("POST", url, async: true);

  // add an event handler that is called when the request finishes
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      print(request.responseText);
      // data saved OK.
      // Render UI
      //renderCalcRuleGroups(JSON.decode(request.responseText));
    }
  });

  
  var body = inputSearch.value;
  String jsonData = '{"action":"search","body":$body}'; 
  request.send(jsonData); 
  // perform the async POST
}

*/
void renderCalcRuleGroups(Map jsonObject){
  Element x_calc_rule_group = querySelector(X_CALC_RULE_GROUPS);
  x_calc_rule_group.children.clear();  
  jsonObject.forEach((key, value) => createCalcRuleGroup(x_calc_rule_group, new CalcRuleGroup.fromJsonString(JSON.encode(value))));
}

void createCalcRuleGroup(Element x_calc_rule_group, CalcRuleGroup group){
  
  for(CalcRule rule in group.mapOfCalcRules.values){
     DivElement panel = new DivElement();
     panel.classes.add("panel panel-default");
     DivElement heading = new DivElement()..
         classes = ['panel-heading'] ..
         text = 'From: ${group.scrFmtId} to ${group.trgFmtId} ${rule.segId}/${rule.segNum}/${rule.ruleName}';
     panel.children.add(heading);
     heading.children.add(new Span().create(rule.ruleCase, null, "badge pull-right"));
     
     DivElement bdoy = new DivElement();
     bdoy.classes.add("panel-body");
     ParagraphElement p = new ParagraphElement();
     p.text = rule.ruleName;
     x_calc_rule_group.children.add(panel);
     panel.children.add(bdoy);
     bdoy.children.add(p);
  }
}


LIElement createCalcRuleGroupItem(CalcRuleGroup group){
  LIElement li = new LIElement();
  li.classes.add("list-group-item");
  li.text = group.name;
  li.children.add(new Span().create(group.numOfItem.toString(), 'group-span', "badge"));

  for(CalcRule rule in group.mapOfCalcRules.values){
    DivElement div = new DivElement();
    div.classes.add("list-group");
    AnchorElement a = new AnchorElement();
    a.classes.add("list-group-item");
    Element h5 = new Element.tag('h5');
    h5.classes.add("list-group-item-heading");
    h5.text = rule.ruleName;
    
    div.children.add(a);
    div.children.add(h5);
    
    li.children.add(div);
  }
  return li;
}

void initOptions(){
  // Download options from remote server.
  fetchOptions({"opt":"datasources"}, datasources, "b2bowner@stg")
  .then((datasource) => fetchOptions({"opt":"formats","ds":datasource}, formats, "CTCS2X/315")
      .then((format) => fetchOptions({"opt":"md_tps","ds":datasource,"fmt":format}, tps, "")
          .then((e)=>fetchMd())));
  
}
/*
 * Bind event listeners. 
 */
void bind(){
  btnSearch.onClick.listen((event) => submitSearch(event));
  
//  datasources.onChange.listen((event) =>datasourceOnChange());
//  formats.onChange.listen((event) =>formatsOnChange());
//  tps.onChange.listen((event) =>tpsOnChange()); 
//  btnrefresh.onClick.listen((event) => fetchMd());
}

void datasourceOnChange(){
  fetchOptions({"opt":"formats","ds":datasources.value}, formats, "CTCS2X/315")
      .then((format) => fetchOptions({"opt":"md_tps","ds":datasources.value,"fmt":format}, tps, "")
          .then((e)=>fetchMd()));
}

void formatsOnChange(){
  fetchOptions({"opt":"md_tps","ds":datasources.value,"fmt":formats.value}, tps, "")
    .then((e)=>fetchMd());
}

void tpsOnChange(){
  fetchMd();
}
/*
 * Get option values from remote server. return Future which contains current selected value.
 */
Future<String> fetchOptions(Map<String,String> parameter, SelectElement selectElm, String selectedValue, [String wildcard]){
  var completer = new Completer();
  var url = getBaseUrl(REMOTE_SERVICE)+getParamsString(parameter);
  var request = HttpRequest.getString(url).then((jstr){
    List<String> options = json.parse(jstr);
    selectElm.children.clear();
    if(wildcard != null && !wildcard.isEmpty){
      options.insert(0, wildcard);
    }
    for(String option in options){
      if(selectedValue == null || selectedValue.isEmpty){
        selectedValue = option;
      }
      selectElm.children.add(new OptionElement(data: option, value: option, selected: selectedValue == option));
    }
    // Assign current selected value
    completer.complete(selectElm.value);
  });
  return completer.future;
}

void fetchMd(){
//  loading(true);
//  var url = getBaseUrl(REMOTE_SERVICE)+getParamsString({"opt":"md_by_tp","ds":datasources.value,"fmt":formats.value,"tp":tps.value});

//  var request = HttpRequest.getString(url).then((jstr){
//    Map jmap = json.parse(jstr);
//    // Create matrix table
//    Matrix matrix = new Matrix("matrix", ['fancyTable']);
//    List<String> headings = ['Segment','Element','MOC','Type','Len','Max','Mapping'];
//    matrix.bindHeader(headings);
//    matrix.bindData(jmap, headings);
//    
//    var parent = querySelector('#x-matrix');
//    if(parent.hasChildNodes())
//      parent.children.removeLast();
//    
//    add2Dom(matrix, parent);
//    
//    // Call native javascript to build an table with fix column.
//    jsFixTableHeader("#matrix",  jmap.length - 1);
//    
//    // Pretty print code.
//    pp.prettyPrint();
//    
//    // Fetch customize logic 
//    fetchCustomization();
//  });
}

/*
 * Matrix table of rules usage.
 */
class Matrix extends View{
  // Tag table
  TableElement _table;
  
  Matrix(String id, List<String> styles){
    _table = new Element.tag("table");
    _table.id = id;
    _table.classes = styles;
  }
  
  // Bind header
  void bindHeader(List<String> headings, [List<String> rowStyle, List<String> cellStyles]){
    Element thead = new Element.tag('thead');
    TableRowElement tr = new Element.tr();
    if(rowStyle != null)
      tr.classes = rowStyle;
    thead.nodes.add(tr);
    
    headings.forEach((heading){
      TableCellElement th = new Element.th();
      if(cellStyles != null)
        th.classes = cellStyles;
      th.text = heading;
      tr.nodes.add(th);      
    });
    _table.nodes.add(thead);
  }
  
  Element createAnchor(String id, String text){
    AnchorElement anchor = new Element.a();
    anchor.text = text;
    return anchor;
  }
  
  /*
   * Assign value into table cell.
   */
  void bindData(Map jmap, List<String> headings){
    Element tbody = new Element.tag('tbody');
     jmap.values.forEach((map){
      TableRowElement tr = new Element.tr();
      tbody.nodes.add(tr);
      headings.forEach((heading){
        TableCellElement td = new Element.td();
        tr.nodes.add(td);
        var text = '';
        if (heading == 'Segment')
          text = map['segId'];
        if (heading == 'Element')
          text = map['segNum'];        
        else if(heading == 'MOC')
          text = map['moc'];
        else if(heading == 'Type')
          text = map['dataType'];
        else if(heading == 'Len')
          text = map['dataLength'];    
        else if(heading == 'Max')
          text = map['maxUse'];  
        else if(heading == 'Mapping'){   
          if(map['code'] != ""){
            Element pre = new Element.pre();
            pre.classes = ['prettyprint lang-dart'];
            pre.text = map['code'];
            td.nodes.add(pre);
            return;
          }else{
            text = 'NOT USED';
            //td.text = text;
          }
        } 
        td.text = text;
      });
    });
    _table.nodes.add(tbody);
  }
  
  // Returns a list of elements to be added to DOM.
  List<Element> get elements {
    List<Element> result = new List();
    result.add(_table);
    return result;
  }  
}


/*
 * Call javascript to fix the first row and first colume in matrix table.
 */
void jsFixTableHeader(String selector, int numOfRec){
  var height = (numOfRec+1) * 40 > MATRIX_HEIGHT ? MATRIX_HEIGHT : ((numOfRec+1) * 40) + 10;
  // Need footer if height of table LT matrix height.
  var param = new javascript.JsObject.jsify({'footer': height >= MATRIX_HEIGHT, 'cloneHeadToFoot': true,'height':height,'fixedColumns' : 0});
  var jquery = new javascript.JsObject(javascript.context['jQuery'], [selector]);
  jquery.callMethod('fixedHeaderTable', [param]);
}

/*
 * Fetch customization part of rulebase
 */
void fetchCustomization(){
  loading(true);
  var url = getBaseUrl(REMOTE_SERVICE)+getParamsString({"opt":"customization","tp":tps.value,"ds":datasources.value,"fmt":formats.value,"cvt":'Customization',"seg":'Customization',"snum":'Rules',"case":'*'});
  var request = HttpRequest.getString(url).then((jstr){
      metas = json.parse(jstr);
      // Remove previous result
      if(querySelector('#definition') != null){
        var divs = querySelectorAll('#definition');
        for(Element div in divs){
          div.remove();
        }
      }
      
      for(String fingerprint in metas.keys){
        var rule = metas[fingerprint]['rule'];
        var meta = metas[fingerprint]['meta'];

        DefinitionGroup def = new DefinitionGroup();
        def.bindData(fingerprint, rule, meta);
        add2Dom(def);    
      }
      
      loading(false);
      
      // Pretty print code.
      pp.prettyPrint();
      
  });
  return;
}

