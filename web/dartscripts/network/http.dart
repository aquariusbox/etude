library network;

import 'dart:html';

const SERVICE_PORT = '8888';
const EDITOR_PORT = '3030';
/*
 * Root folder in tomcat webapps
 */
const String ROOT_WAR_FOLDER = '/dry';

/*
 * If port equals EDITOR PORT, return local testing server port.
 * If port not equals EDITOR PORT (Production), return actal deploy port.
 */
String getPort(){
  return window.location.port == EDITOR_PORT ? SERVICE_PORT : window.location.port;
}

/*
 * Return service part of connection. 
 */
String getService(String serviceName){
  return window.location.port == EDITOR_PORT ? serviceName : ROOT_WAR_FOLDER + serviceName;
}

/*
 * Get the base url http://hostname:prot/service
 */
String getBaseUrl(String serviceName){
  return window.location.protocol + '//'+ window.location.hostname + ':' + getPort() + getService(serviceName);
}

/*
 * Generate parameter strings
 */
String getParamsString(Map<String, String> parameters){
  int idx = 0;
  var url = '?';
  for(String key in parameters.keys){
    if(idx > 0){
      url = url + '&';
    }
    url = url + key + '=' + parameters[key];
    idx++;
  }
  return url;
}
