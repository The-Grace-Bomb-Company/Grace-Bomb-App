import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';

class AppSettings {
  static final String apiAuthority = getApiAuthority();
  static final String apiCode = getSetting<String>('apiCode');
  static final getSetting = GlobalConfiguration().getValue;

  static String getApiAuthority() {
    String uri = getSetting<String>('apiAuthority');
    if (kDebugMode) {
      uri += ':${getSetting<String>('apiDevPort')}';
    }
    return uri;
  }
}
