import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socialapp/app.dart';

class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fcmToken = await _firebaseMessaging.getToken();

    // print the token (normally you would send this to your server)
    print('Token: $fcmToken');

    setupMessageListener();
    initPushNotifications();
  }

  // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // If the message is null, do nothing
    if (message == null) return;

    // Navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

// Function to initialize background settings
  Future initPushNotifications() async {
    // Handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // Add this to your FirebaseApi class
  void setupMessageListener() {
    // For foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // You can show a local notification here even when app is in foreground
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // You can use flutter_local_notifications package to show notification
        // when app is in foreground
      }
    });
  }
}
