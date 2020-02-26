class Config {
  static bool _isProduction = false;
  static String apiBaseUrl = _isProduction
      ? 'https://clientportal.mosby.com/clientportal'
      : 'http://local.righttouch.net/y/clientportal';

  static void setIsProduction() {
    _isProduction = true;
  }

  static void setIsDevelopment() {
    _isProduction = false;
  }
}
