class Config {
  static bool _isProduction = false;
  static String apiBaseUrl = 'https://www.righttouchcrm.net/y/clientportal';
  // _isProduction
  //     ? 'https://www.righttouchcrm.net/y/clientportal'
  //     : 'https://mosby-connect.ngrok.io/y/clientportal';

  static String sentryDSN =
      'https://68ec41201fec49799d5097f5ce7ced52@o259570.ingest.sentry.io/5413881';

  static String paymentUrl = 'http://pay.mosbybuildingarts.com';

  static void setIsProduction() {
    _isProduction = true;
  }

  static void setIsDevelopment() {
    _isProduction = false;
  }
}
