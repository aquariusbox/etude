// Copyright (c) 2012, Alexandre Ardhuin
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

part of google_maps;

class ScaleControlOptions extends jsw.TypedJsObject {
  static ScaleControlOptions $wrap(js.JsObject jsObject) => jsObject == null ? null : new ScaleControlOptions.fromJsObject(jsObject);
  ScaleControlOptions.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  ScaleControlOptions();

  set position(ControlPosition position) => $unsafe['position'] = position == null ? null : position.$unsafe;
  ControlPosition get position => ControlPosition.$wrap($unsafe['position']);
  set style(ScaleControlStyle style) => $unsafe['style'] = style == null ? null : style.$unsafe;
  ScaleControlStyle get style => ScaleControlStyle.$wrap($unsafe['style']);
}
