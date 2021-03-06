// Copyright (c) 2013, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of google_maps_visualization;

class DemographicsPropertyStyle extends jsw.TypedJsObject {
  static DemographicsPropertyStyle $wrap(js.JsObject jsObject) => jsObject == null ? null : new DemographicsPropertyStyle.fromJsObject(jsObject);
  DemographicsPropertyStyle.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  DemographicsPropertyStyle()
      : super();

  set expression(String expression) => $unsafe['expression'] = expression;
  String get expression => $unsafe['expression'];
  set gradient(List<String> gradient) => $unsafe['gradient'] = gradient == null ? null : (gradient is jsw.TypedJsObject ? (gradient as jsw.TypedJsObject).$unsafe : jsw.jsify(gradient));
  List<String> get gradient => jsw.TypedJsArray.$wrap($unsafe['gradient']);
  set min(num min) => $unsafe['min'] = min;
  num get min => $unsafe['min'];
  set max(num max) => $unsafe['max'] = max;
  num get max => $unsafe['max'];
}
