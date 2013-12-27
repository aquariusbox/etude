library javascript;
import 'dart:js' as js;

/*
 * Call Google javascript pretty print.
 */
void prettyPrint(){
    js.context.callMethod('prettyPrint');
}
