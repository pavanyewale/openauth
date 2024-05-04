class BaseURL {
  String baseURL = "http://192.168.1.100:8000"; //default prod url
  Map<String,String> baseURLMap = {
    "prod": "http://localhost:8000"
    };
  
  // Private constructor to prevent instantiation from outside
  BaseURL._();

  // Singleton instance variable
  static final BaseURL _instance = BaseURL._();

  // Getter to access the singleton instance
  static BaseURL get instance => _instance;

  void setBaseURL(String url){
    if (url.isNotEmpty){
      baseURL = url;
    }
  }

  void setEnv(String env){
    baseURL = baseURLMap[env] == null ? baseURLMap["prod"].toString() : baseURLMap[env].toString();
  }

  String getBaseURL() {
    return baseURL;
  }
}