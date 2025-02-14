import 'package:global_configuration/global_configuration.dart';

class AppSettings {
  static final String apiAuthority = getSetting<String>('apiAuthority');
  static final String apiCode = getSetting<String>('apiCode');
  static final bool isDebug = getSetting<bool>('isDebug');
  static final getSetting = GlobalConfiguration().getValue;

  static const int maxBombTitleLength = 30;
  static const int maxBombStoryLength = 2200;
  static const String pendingApprovalDescription =
      'Description is Pending Approval';
}
