import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
//import 'package:masterise_mcm/base/firebase_manager/fire_base_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordzoo/base/widgets/dialog_common/confirm_popup_page.dart';
import 'package:wordzoo/generated/l10n.dart';

class AppVersionCheckerManager {
  static final AppVersionCheckerManager _singletonAppVersionCheckerManager = AppVersionCheckerManager._internal();

  static AppVersionCheckerManager get getInstance => _singletonAppVersionCheckerManager;

  factory AppVersionCheckerManager() {
    return _singletonAppVersionCheckerManager;
  }

  bool _isAppVersionOnStore = true;
  int? _firebaseAppVersion;
  AppVersionCheckerManager._internal();

  Future<void> checkAppNewVersion(BuildContext context) async {
    //final _checker = AppVersionChecker();
    if (kIsWeb) return;
    try {
      String? storeVersionStr;
      String? storeUrl;
      if (Platform.isAndroid) {
        InStoreAppVersionCheckerResponse inStoreAppVersionCheckerResponse = (await getCurrentVersionOnGoogleStore());
        storeVersionStr = inStoreAppVersionCheckerResponse.currentVersion;
        storeUrl = inStoreAppVersionCheckerResponse.appURL;

      }
      else
      {
        AppVersionResult appVersionResult = await AppVersionUpdate.checkForUpdates();
        storeVersionStr = appVersionResult.storeVersion ?? '0';
        storeUrl = appVersionResult.storeUrl;
      }
      final PackageInfo info = await PackageInfo.fromPlatform();
      int currentVersion = ((double.tryParse(info.version.toString().replaceAll('.', ''))) ?? 0).toInt();
      int storeVersion = (double.tryParse((storeVersionStr).replaceAll('.', '')) ?? 0).toInt();
      // FirebaseEnv firebaseAppEnv = FirebaseManager().getFirebaseEnv();
      // if (Platform.isIOS && EnviromentManager().getEnviromentDomain() == EVIROMENT_DOMAIN.pro) {
      //   if (firebaseAppEnv == FirebaseEnv.prod) {
      //     storeVersion = await getStoreVersionFromFirebaseRemote();
      //   } else {
      //     storeVersion = currentVersion;
      //   }
      // }
      if (storeVersion > currentVersion) {
        ConfirmPopupPage(
          title: S().notification,
          content: S().update_notify,
          onCancel: () {},
          onAccept: () {
            Uri uri = Uri.parse(storeUrl ?? "");
            launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        ).show(context);
      }
      print("value");
    }
    catch(e){
        print("error check version: ${e.toString()}");
    }
  }

  Future<bool> newAppVersionIsAcceptedOnStore() async {
    if (kIsWeb) {
      _isAppVersionOnStore = true;
      return true;
    }
    try {
      String? storeVersion;
      if (Platform.isAndroid) {
        storeVersion = (await getCurrentVersionOnGoogleStore()).currentVersion;
      }
    else
      {
        AppVersionResult appVersionResult = await AppVersionUpdate.checkForUpdates();
        storeVersion = appVersionResult.storeVersion ?? "0";
      }
      final PackageInfo info = await PackageInfo.fromPlatform();

      int currentLocalVersion = ((double.tryParse(info.version.toString().replaceAll(".", ""))) ?? 0).toInt();
      int currentstoreVersion = (double.tryParse((storeVersion).replaceAll(".", "")) ?? 0).toInt();
      // FirebaseEnv firebaseAppEnv = FirebaseManager().getFirebaseEnv();
      //
      // if (Platform.isIOS && EnviromentManager().getEnviromentDomain() == EVIROMENT_DOMAIN.pro) {
      //   if (firebaseAppEnv == FirebaseEnv.prod) {
      //     currentstoreVersion = await getStoreVersionFromFirebaseRemote();
      //   } else {
      //     currentstoreVersion = currentLocalVersion;
      //   }
      // }
      // print("currentstoreVersion: ${currentstoreVersion}");
      // print("currentLocalVersion: ${currentLocalVersion}");

      if (currentstoreVersion >= currentLocalVersion) {
        _isAppVersionOnStore = true;

        return true;
      } else {
        _isAppVersionOnStore = false;
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

  bool isAppVersionOnAppleStore() {
   // if (Platform.isIOS && EnviromentManager().getEnviromentDomain() == EVIROMENT_DOMAIN.pro) {
      return _isAppVersionOnStore;
    //}
   // return true;
  }

/*
  Future<int> getStoreVersionFromFirebaseRemote() async {
    print("call getStoreVersionFromFirebaseRemote");

    FirebaseEnv firebaseAppEnv = FirebaseManager().getFirebaseEnv();
    if ((firebaseAppEnv == _firebaseAppEnv) && _firebaseAppVersion != null) {
      print("call getStoreVersionFromFirebaseRemote when version exit");
      return _firebaseAppVersion!;
    }
    print("call getStoreVersionFromFirebaseRemote when version not exit");
    _firebaseAppEnv = firebaseAppEnv;
    final remoteConfig = FirebaseRemoteConfig.instance;
    // 2. Lấy dữ liệu từ Firebase
    // ⚠️ Disable cache khi dev
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // QUAN TRỌNG
      ),
    );
    await remoteConfig.fetchAndActivate();
    String store_version = remoteConfig.getString('MCMS_ios_current_apple_store_version');
    print("MCMS_ios_current_apple_store_version:${store_version}");
    int storeVersion = (double.tryParse((store_version ?? "0").replaceAll(".", "")) ?? 0).toInt();
    if (storeVersion == 0)

    /// truong hop khong co cau hinh tren firebase
    {
      final PackageInfo info = await PackageInfo.fromPlatform();
      storeVersion = ((double.tryParse(info.version.toString().replaceAll(".", ""))) ?? 0).toInt();
    }
    _firebaseAppVersion = storeVersion;
    return storeVersion;
  }
*/

  Future<InStoreAppVersionCheckerResponse> getCurrentVersionOnGoogleStore() async {
    const paramsAndroid = InStoreAppVersionCheckerParams(
      locale: 'en',
      androidStore: InStoreAppVersionCheckerAndroidStoreType.googlePlayStore,
    );
    final res = await InStoreAppVersionChecker.instance.checkUpdate(paramsAndroid);
    if (res.isSuccess) {
      print('Current version: ${res.currentVersion}');
      print('New version    : ${res.newVersion}');
      print('App url        : ${res.appURL}');
      print('Can update     : ${res.canUpdate}');
      return res;
    } else {
      print('Error          : ${res.errorMessage}');
      return res;
    }

  }
}
