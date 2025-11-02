import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/prayer_time.dart';
import 'database_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Notification IDs for each prayer
  static const Map<String, int> _notificationIds = {
    'subuh': 1,
    'dzuhur': 2,
    'ashar': 3,
    'maghrib': 4,
    'isya': 5,
  };

  // Initialize notification service
  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();
  }

  // Request notification permissions
  Future<bool> _requestPermissions() async {
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific page
    // For now, just log it
    print('Notification tapped: ${response.payload}');
  }

  // Schedule all prayer notifications for today
  Future<void> scheduleDailyPrayerNotifications(PrayerTime prayerTime) async {
    final settings = await _dbHelper.getAllNotificationSettings();
    final now = DateTime.now();

    for (final setting in settings) {
      if (setting['is_enabled'] == 1) {
        final prayerName = setting['prayer_name'] as String;
        final timeString = _getPrayerTimeString(prayerTime, prayerName);
        
        if (timeString != null) {
          final scheduledTime = _parseTimeString(timeString);
          
          // Only schedule if time hasn't passed today
          if (scheduledTime.isAfter(now)) {
            await _scheduleNotification(
              id: _notificationIds[prayerName]!,
              title: 'Waktu ${_getPrayerDisplayName(prayerName)}',
              body: 'Saatnya menunaikan sholat ${_getPrayerDisplayName(prayerName)}',
              scheduledTime: scheduledTime,
              soundEnabled: setting['sound_enabled'] == 1,
              vibrateEnabled: setting['vibrate_enabled'] == 1,
            );
          }
        }
      }
    }
  }

  // Schedule a single notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool soundEnabled = true,
    bool vibrateEnabled = true,
  }) async {
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'prayer_times',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: soundEnabled,
      enableVibration: vibrateEnabled,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel a specific prayer notification
  Future<void> cancelPrayerNotification(String prayerName) async {
    final id = _notificationIds[prayerName];
    if (id != null) {
      await _notifications.cancel(id);
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'prayer_times',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Helper: Get prayer time string from PrayerTime object
  String? _getPrayerTimeString(PrayerTime prayerTime, String prayerName) {
    switch (prayerName) {
      case 'subuh':
        return prayerTime.subuh;
      case 'dzuhur':
        return prayerTime.dzuhur;
      case 'ashar':
        return prayerTime.ashar;
      case 'maghrib':
        return prayerTime.maghrib;
      case 'isya':
        return prayerTime.isya;
      default:
        return null;
    }
  }

  // Helper: Parse time string (HH:mm) to DateTime for today
  DateTime _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Helper: Get display name for prayer
  String _getPrayerDisplayName(String prayerName) {
    switch (prayerName) {
      case 'subuh':
        return 'Subuh';
      case 'dzuhur':
        return 'Dzuhur';
      case 'ashar':
        return 'Ashar';
      case 'maghrib':
        return 'Maghrib';
      case 'isya':
        return 'Isya';
      default:
        return prayerName;
    }
  }
}
