import 'dart:html';
//import 'package:google_maps/google_maps.dart';
import 'dart:math' as math;
import '../elements/elements.dart';
import 'dart:js' show context, JsObject;

void main() {
  
  // Add navigation
  Navigation navigation = new Navigation();
  add2Dom(navigation, querySelector("#x-navigation"));
  navigation.currentActive(navigation.actives["home"]);
  
  // Embed google map 
  embedGoogleMap(); 
}

//void embedGoogleMap(){
//  var rng = new math.Random();
//  final mapOptions = new MapOptions()
//      ..zoom = (rng.nextInt(9) + 5)
//      ..disableDoubleClickZoom = true
//      ..center = new LatLng(randomInRange(-85,85,3), randomInRange(-180,180,3))
//      ..mapTypeId = MapTypeId.TERRAIN
//      ;
//    mapOptions.disableDefaultUI = true;
//    mapOptions.zoomControl = false;
//    final map = new GMap(querySelector("#map_canvas"), mapOptions);
//}

void embedGoogleMap(){
  
  // The top-level getter context provides a JsObject that represents the global
  // object in JavaScript.
  final google_maps = context['google']['maps'];

  // new JsObject() constructs a new JavaScript object and returns a proxy
  // to it.
  var center = new JsObject(google_maps['LatLng'], [randomInRange(-85,85,3), randomInRange(-180,180,3)]);

  var mapTypeId = google_maps['MapTypeId']['TERRAIN'];

  var rng = new math.Random();
  var zoom = (rng.nextInt(9) + 5);
  
  // new JsObject.jsify() recursively converts a collection of Dart objects
  // to a collection of JavaScript objects and returns a proxy to it.
  var mapOptions = new JsObject.jsify({
      "center": center,
      "zoom": zoom,
      "mapTypeId": mapTypeId,
      "disableDoubleClickZoom":true,
      "disableDefaultUI":true,
      "zoomControl":false
  });

  // Nodes are passed though, or transferred, not proxied.
  new JsObject(google_maps['Map'], [querySelector('#map-canvas'), mapOptions]);
}


// Random generate longitude & latitude range
double randomInRange(var from, var to, var fixed){
  var rng = new math.Random();
  var str = (rng.nextDouble() * (to - from) + from).toStringAsFixed(fixed);
  return double.parse(str) * 1; 
}