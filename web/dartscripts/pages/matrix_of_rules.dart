import 'dart:html';
import 'dart:async';
import 'dart:js' as javascript;
import 'package:json/json.dart' as json;
import '../elements/elements.dart';
import '../network/http.dart';
import '../javascript/prettyprint.dart' as pp show prettyPrint;

const REMOTE_SERVICE = '/dry/service-rules-usage';
const MATRIX_HEADING = 'Rules / PMT';
const int MATRIX_HEIGHT = 750;

SelectElement datasources = new SelectElement();
SelectElement formats = new SelectElement();
SelectElement scropes = new SelectElement();
SelectElement segments = new SelectElement();
SelectElement fields = new SelectElement();
SelectElement cases = new SelectElement();
ButtonElement btnrefresh = new ButtonElement();

// Meta data of rules
Map metas;

main() {
   
  // Add navigation
  Navigation navigation = new Navigation();
  add2Dom(navigation, querySelector("#x-navigation"));
  navigation.currentActive(navigation.actives["rbase"]);
  
  // Sequence download options from remote
  fetchOptions({"opt":"datasources"}, datasources, "b2bowner@stg")
  .then((datasource) => fetchOptions({"opt":"formats","ds":datasource}, formats, "CTCS2X/315")
      .then((format) => fetchOptions({"opt":"convTypes","ds":datasource,"fmt":format}, scropes, "")
          .then((convertType) => fetchOptions({"opt":"segments","ds":datasource,"fmt":format,"cvt":convertType}, segments, "")
              .then((segment) => fetchOptions({"opt":"fields","ds":datasource,"fmt":format,"cvt":convertType,"seg":segment}, fields, "*","*")
                  .then((field) => fetchOptions({"opt":"cases","ds":datasource,"fmt":format,"cvt":convertType,"seg":segment,"snum":field}, cases, "*","*").then((e)=>fetchMatrix()))))));
  
  
  // Add selection
  datasources.classes.add("form-control");
  formats.classes.add("form-control");
  scropes.classes.add("form-control");
  segments.classes.add("form-control");
  fields.classes.add("form-control");
  cases.classes.add("form-control");
  
  // Prepare button
  btnrefresh..id = "btn-refresh"
      ..text = "Refresh"
      ..classes.add('btn btn-primary');

  // Bind to html
  querySelector("#x-datasource").nodes.add(datasources);
  querySelector("#x-formats").nodes.add(formats);
  querySelector("#x-scropes").nodes.add(scropes);
  querySelector("#x-segments").nodes.add(segments);
  querySelector("#x-fields").nodes.add(fields);
  querySelector("#x-cases").nodes.add(cases);
  querySelector('#x-btnrefresh').append(btnrefresh); 
  
  // Bind event listeners
  bind();
}

void datasourceOnChange(){
  fetchOptions({"opt":"formats","ds":datasources.value}, formats, "CTCS2X/315")
    .then((format) => fetchOptions({"opt":"convTypes","ds":datasources.value,"fmt":format}, scropes, "")
       .then((convertType) => fetchOptions({"opt":"segments","ds":datasources.value,"fmt":format,"cvt":convertType}, segments, "")
         .then((segment) => fetchOptions({"opt":"fields","ds":datasources.value,"fmt":format,"cvt":convertType,"seg":segment}, fields, "*","*")
            .then((field) => fetchOptions({"opt":"cases","ds":datasources.value,"fmt":format,"cvt":convertType,"seg":segment,"snum":field}, cases, "*","*").then((e)=>fetchMatrix())))));
}

void formatsOnChange(){
  fetchOptions({"opt":"convTypes","ds":datasources.value,"fmt":formats.value}, scropes, "")
    .then((convertType) => fetchOptions({"opt":"segments","ds":datasources.value,"fmt":formats.value,"cvt":convertType}, segments, "")
      .then((segment) => fetchOptions({"opt":"fields","ds":datasources.value,"fmt":formats.value,"cvt":convertType,"seg":segment}, fields, "*","*")
        .then((field) => fetchOptions({"opt":"cases","ds":datasources.value,"fmt":formats.value,"cvt":convertType,"seg":segment,"snum":field}, cases, "*","*").then((e)=>fetchMatrix()))));
}

void scropesOnChange(){
  fetchOptions({"opt":"segments","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value}, segments, "")
    .then((segment) => fetchOptions({"opt":"fields","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segment}, fields, "*","*")
      .then((field) => fetchOptions({"opt":"cases","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segment,"snum":field}, cases, "*","*").then((e)=>fetchMatrix())));
}

void segmentsOnChange(){
  fetchOptions({"opt":"fields","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segments.value}, fields, "*","*")
    .then((field) => fetchOptions({"opt":"cases","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segments.value,"snum":field}, cases, "*","*").then((e)=>fetchMatrix()));
}

void fieldsOnChange(){
  fetchOptions({"opt":"cases","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segments.value,"snum":fields.value}, cases, "*","*").then((e)=>fetchMatrix());
}

void casesOnChange(){
  fetchMatrix();
}


/*
 * Bind event listeners to elements
 */
void bind(){
  datasources.onChange.listen((event) =>
    datasourceOnChange()
  );
  formats.onChange.listen((event) =>
    formatsOnChange()
  );
  scropes.onChange.listen((event) =>
      scropesOnChange()
  );
  segments.onChange.listen((event) =>
      segmentsOnChange()
  );
  fields.onChange.listen((event) =>
      fieldsOnChange()
  );
  cases.onChange.listen((event) =>
      casesOnChange()
  );
  btnrefresh.onClick.listen((event) => 
      fetchMatrix()
  );
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
    completer.complete(selectElm.value);
  });
  return completer.future;
}


void fetchMatrix(){
  loading(true);
  var url = getBaseUrl(REMOTE_SERVICE)+getParamsString({"opt":"matrix","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segments.value,"snum":fields.value,"case":cases.value});
  var request = HttpRequest.getString(url).then((jstr){
    Map jmap = json.parse(jstr);
    // Create matrix table
    Matrix matrix = new Matrix("matrix", ['fancyTable']);
    List<String> headings = new List();
    headings.add(MATRIX_HEADING);
    headings.addAll(jmap['tpIds']);
    matrix.bindHeader(headings);
    matrix.bindData(headings, jmap['keys'], jmap['sequences'],jmap['detail']);
    
    var parent = querySelector('#x-matrix');
    if(parent.hasChildNodes())
      parent.children.removeLast();
    
    add2Dom(matrix, parent);
    
    // Call native javascript to build an table with fix column.
    jsFixTableHeader("#matrix",  jmap['detail'].length);
    
    loading(false);
    
    fetchDefinition();
  }); 
}

/*
 * Fetch definition of each rules from sever and add them to HTML page.
 */
void fetchDefinition(){
  loading(true);
  var url = getBaseUrl(REMOTE_SERVICE)+getParamsString({"opt":"document","ds":datasources.value,"fmt":formats.value,"cvt":scropes.value,"seg":segments.value,"snum":fields.value,"case":cases.value});
  var request = HttpRequest.getString(url).then((jstr){
      metas = json.parse(jstr);
      // Remove previous result from HTML
      if(querySelector('#definition') != null){
        var divs = querySelectorAll('#definition');
        for(Element div in divs){
          div.remove();
        }
      }
      // Add new definition group to HTML
      for(String fingerprint in metas.keys){
        var rule = metas[fingerprint]['rule'];
        var meta = metas[fingerprint]['meta'];
        DefinitionGroup def = new DefinitionGroup();
        def.bindData(fingerprint, rule, meta);
        add2Dom(def);    
      }
      // Pretty print code.
      pp.prettyPrint();
      loading(false);
  });
  return; 
}

/**
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
  
  /**
   * Assign value into table cell.
   */
  void bindData(List<String> headings, List<String> fingerprints, Map<String,String> sequences,  Map<String,Map<String,String>> detail){
    Element tbody = new Element.tag('tbody');
    fingerprints.forEach((fingerprint){
      TableRowElement tr = new Element.tr();
      tbody.nodes.add(tr);
      
      var idxColn = 0;
      headings.forEach((heading){
        var fingerprintTp = fingerprint+"-"+heading;
        var fieldValue = ' ';
        // Not 1st column
        if(heading != MATRIX_HEADING){
          if(sequences.containsKey(fingerprintTp))
            fieldValue = '<span class="label label-info">'+sequences[fingerprintTp]+'</span>';  
        } else { 
            // Print the rule name
            fieldValue = '<p><span class="badge">'+detail[fingerprint]['ruleCase']+'</span> ' + 
                '<a href="#$fingerprint">'+detail[fingerprint]['segNum']+" / "+detail[fingerprint]['ruleName']+'</a>'
                "</p>"; 
        }
          
        TableCellElement td = new Element.td();
        if(fieldValue.contains("span")){
          if(idxColn++ > 0)
             td.attributes = {"align":"center"};
          td.nodes.add(new Element.html(fieldValue));
        }
        else
          td.text = fieldValue;
        tr.nodes.add(td);
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
/**
 * Call javascript to fix the first row and first colume in matrix table.
 */
void jsFixTableHeader(String selector, int numOfRec){
  var height = (numOfRec+1) * 40 > MATRIX_HEIGHT ? MATRIX_HEIGHT : ((numOfRec+1) * 40) + 10;
  // Need footer if height of table LT matrix height.
  var param = new javascript.JsObject.jsify({'footer': height >= MATRIX_HEIGHT, 'cloneHeadToFoot': true,'height':height,'fixedColumns' : 1});
  var jquery = new javascript.JsObject(javascript.context['jQuery'], [selector]);
  jquery.callMethod('fixedHeaderTable', [param]);
}