library elements;

import 'dart:html';
import 'package:json/json.dart' as json;
import 'dart:async';

part 'navigation.dart';
part 'caret.dart';
part 'container.dart';
part 'dropdown_menu.dart';
part 'span.dart';
part 'definition_group.dart';

abstract class View{
  List<Element> elements = [];
}

/**
 * Add view to DOM tree
 */
void add2Dom(View view, [Element parent]){
  if(parent == null){
    parent = document.body;
  }
  parent.nodes.addAll(view.elements);
}

