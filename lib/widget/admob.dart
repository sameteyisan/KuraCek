import 'package:admob_flutter/admob_flutter.dart';

void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
  switch (event) {
    case AdmobAdEvent.loaded:
      break;
    case AdmobAdEvent.opened:
      break;
    case AdmobAdEvent.closed:
      break;
    case AdmobAdEvent.failedToLoad:
      break;
    case AdmobAdEvent.rewarded:
      break;
    default:
  }
}

AdmobBanner admobBanner(AdmobBannerSize gelen) {
  return AdmobBanner(
    adUnitId: "ca-app-pub-4589290119610129/6502664756",
    adSize: gelen,
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      handleEvent(event, args, 'Banner');
    },
    onBannerCreated: (AdmobBannerController controller) {},
  );
}

AdmobInterstitial admobInterstitial() {
  return AdmobInterstitial(
    adUnitId: "ca-app-pub-4589290119610129/5977252855",
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      if (event == AdmobAdEvent.closed)
        handleEvent(event, args, 'Interstitial');
    },
  );
}
