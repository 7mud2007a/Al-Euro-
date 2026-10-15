import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initPushNotifications() async {
    // 1. طلب صلاحيات الإشعارات على iOS و Android 13+
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. الاشتراك في قنوات العملاء (Segments / Topics)
    await _messaging.subscribeToTopic('all_customers');
    await _messaging.subscribeToTopic('offers');

    // 3. الاستماع للإشعارات أثناء فتح التطبيق (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // يتم تمرير الإشعار مباشرة إلى AppState لتحديث شارة الجرس (Burgundy Badge)
    });
  }
}
