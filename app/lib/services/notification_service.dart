import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/services.dart';
import '../models/prayer_time.dart';
import 'database_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  bool _isInitialized = false;

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
    if (_isInitialized) return;
    
    // Initialize timezone data
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Create notification channel for Android with custom sound
    const androidChannel = AndroidNotificationChannel(
      'adzan_channel',
      'Adzan Notifications',
      description: 'Notifications for prayer times with adzan sound',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('adzan'),
    );

    // Register the channel
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

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
    
    _isInitialized = true;
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

  // Schedule all prayer notifications for today and recurring
  Future<void> scheduleDailyPrayerNotifications(PrayerTime prayerTime) async {
    final settings = await _dbHelper.getAllNotificationSettings();

    // Cancel all existing notifications first
    await cancelAllNotifications();

    for (final setting in settings) {
      if (setting['is_enabled'] == 1) {
        final prayerName = setting['prayer_name'] as String;
        final timeString = _getPrayerTimeString(prayerTime, prayerName);
        
        if (timeString != null) {
          final scheduledTime = _parseTimeString(timeString);
          
          // Schedule for today and recurring daily
          await _scheduleRecurringNotification(
            id: _notificationIds[prayerName]!,
            title: 'Waktu ${_getPrayerDisplayName(prayerName)} Tiba',
            body: 'Saatnya menunaikan sholat ${_getPrayerDisplayName(prayerName)} 🕌',
            scheduledTime: scheduledTime,
            soundEnabled: setting['sound_enabled'] == 1,
            vibrateEnabled: setting['vibrate_enabled'] == 1,
          );
        }
      }
    }
  }

  // Schedule a recurring daily notification
  Future<void> _scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool soundEnabled = true,
    bool vibrateEnabled = true,
  }) async {
    final now = DateTime.now();
    var scheduleDate = scheduledTime;
    
    // If time has passed today, schedule for tomorrow
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    
    final tzScheduledTime = tz.TZDateTime.from(scheduleDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'adzan_channel', // Use custom channel with adzan sound
      'Adzan Notifications',
      channelDescription: 'Notifications for prayer times with adzan sound',
      importance: Importance.high,
      priority: Priority.high,
      playSound: soundEnabled,
      sound: soundEnabled ? const RawResourceAndroidNotificationSound('adzan') : null,
      enableVibration: vibrateEnabled,
      icon: '@mipmap/ic_launcher',
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.mp3', // iOS custom sound
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule with daily recurring using matchDateTimeComponents
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // This makes it recurring daily!
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

  // TEST: Show immediate notification (for testing only)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    await initialize();
    
    const androidDetails = AndroidNotificationDetails(
      'adzan_channel',
      'Adzan Notifications',
      channelDescription: 'Notifications for prayer times with adzan sound',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adzan'),
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.mp3',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      title,
      body,
      details,
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
