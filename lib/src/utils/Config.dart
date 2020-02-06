class Config {
  static bool _isProduction = false;
  static String apiBaseUrl = _isProduction
      ? 'https://clientportal.mosby.com/clientportal'
      : 'http://localhost:8080/clientportal';

  static void setIsProduction() {
    _isProduction = true;
  }

  static void setIsDevelopment() {
    _isProduction = false;
  }
}
