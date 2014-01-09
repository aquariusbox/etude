library entities;

import 'package:json_object/json_object.dart';

class CalcRuleGroup extends JsonObject{
  String name;
  String scrFmtId;
  String trgFmtId;
  int numOfItem;
  Map<String, CalcRule> mapOfCalcRules = {};
  
  CalcRuleGroup();
  
  factory CalcRuleGroup.fromJsonString(String jsonString) {
    var  o = new JsonObject.fromJsonString(jsonString);
    CalcRuleGroup group = new CalcRuleGroup();
    group.name = o.name;
    group.scrFmtId = o.scrFmtId;
    group.trgFmtId = o.trgFmtId;
    group.numOfItem = o.numOfItem;
    for(JsonObject current in o.mapOfCalcRules){
      CalcRule rule = new CalcRule.fromJsonObject(current);
      group.mapOfCalcRules[rule.fingerprint] = rule;
    }  
    return group;
  }
  
}

class CalcRule extends JsonObject {
  String fingerprint;
  int id;
  String srcFmtId;
  String trgFmtId;
  String convertTypeId;
  String dirId;
  String segId;
  String segNum;
  String ruleCase;
  String ruleName;
  String createTs;
  String updateTs;
  String updateBy;
  String activeFlag;
  String configType;
  
  CalcRule();
  
  factory CalcRule.fromJsonObject(JsonObject o) {
    CalcRule calcRule =  new CalcRule();
    calcRule.fingerprint = o.fingerprint;
    calcRule.id = o.id;
    calcRule.srcFmtId = o.srcFmtId;
    calcRule.trgFmtId = o.trgFmtId;
    calcRule.convertTypeId = o.convertTypeId;
    calcRule.dirId = o.dirId;
    calcRule.segId = o.segId;
    calcRule.segNum = o.segNum;
    calcRule.ruleCase = o.ruleCase;
    calcRule.ruleName = o.ruleName;
    calcRule.createTs = o.createTs;
    calcRule.updateTs = o.updateTs;
    calcRule.updateBy = o.updateBy;
    calcRule.activeFlag = o.activeFlag;
    calcRule.configType = o.configType;
    return calcRule;
  }
  
}
