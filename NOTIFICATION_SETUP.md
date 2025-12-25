# 🔔 Setup Notifikasi Adzan

## ✅ Bug yang Sudah Diperbaiki

1. **Notifikasi tidak muncul** ✅ 
   - Fixed: Sekarang pakai `matchDateTimeComponents.time` untuk recurring daily
   - Fixed: Cancel all notifications sebelum schedule ulang
   - Fixed: Handle waktu yang sudah lewat (schedule untuk besok)

2. **Suara default notification** ✅
   - Fixed: Sekarang pakai custom sound channel 'adzan_channel'
   - Fixed: RawResourceAndroidNotificationSound('adzan')

## 📁 Yang Perlu Ditambahkan: File Suara Adzan

### Option 1: Quick Download (Recommended)

1. **Download file adzan sample:**
   - Link: https://www.zapsplat.com (search "adhan")
   - Atau: https://freesound.org (search "islamic call to prayer")
   - Durasi: 30-60 detik cukup

2. **Copy ke folder Android:**
```bash
# Buat folder raw jika belum ada
mkdir -p android/app/src/main/res/raw

# Copy file adzan (rename menjadi adzan.mp3)
cp path/to/your/adzan.mp3 android/app/src/main/res/raw/adzan.mp3
```

3. **Rebuild app:**
```bash
flutter clean
flutter pub get
flutter run
```

### Option 2: Pakai File yang Ada

Jika sudah punya file MP3 adzan:

```bash
# 1. Pastikan format compatible
# Jika terlalu besar, compress dulu:
ffmpeg -i original_adzan.mp3 -b:a 64k -ar 16000 adzan.mp3

# 2. Copy ke folder raw
mkdir -p android/app/src/main/res/raw
cp adzan.mp3 android/app/src/main/res/raw/

# 3. Rebuild
flutter clean && flutter run
```

## ⚠️ PENTING - Notification Channel

Android meng-cache notification channel settings. Setelah tambah file audio:

1. **Uninstall app** dari device
2. **Reinstall** dengan `flutter run`
3. Atau clear app data di Settings → Apps → Saku Muslim → Clear Data

## 🧪 Testing Notifikasi

### Test 1: Permission Check
```dart
// Di settings_page.dart, notif permission sudah auto-request
// Check di Settings HP → Apps → Saku Muslim → Notifications
```

### Test 2: Manual Test
Tambahkan tombol test di settings page:
- Show immediate notification
- Check sound plays
- Check vibration works

### Test 3: Schedule Test
1. Buka Settings → Notifikasi
2. Enable Subuh notification
3. Set waktu 1-2 menit ke depan (ubah di database untuk testing)
4. Wait dan lihat apakah notif muncul

## 📱 Cara Kerja Sekarang

1. **Home Page load** → Fetch prayer times → Call `scheduleDailyPrayerNotifications()`
2. **NotificationService** → Cancel all existing → Schedule 5 prayers (recurring daily)
3. **When time comes** → Show notification with adzan sound → Auto-repeats next day
4. **Settings changed** → Re-schedule semua notifications

## 🐛 Troubleshooting

### Notifikasi masih tidak muncul?

**1. Check Permission:**
```dart
// Permission di-request otomatis saat app start
// Manual check: Settings HP → Apps → Saku Muslim → Notifications → Allow
```

**2. Check Battery Optimization:**
```
Settings → Battery → Battery Optimization → Saku Muslim → Don't optimize
```

**3. Check Exact Alarm Permission (Android 12+):**
```
Settings → Apps → Saku Muslim → Alarms & reminders → Allow
```

**4. Check Jadwal Sholat:**
- Buka Home page → pastikan ada jadwal sholat
- Notif hanya schedule jika ada data prayer time

**5. Re-schedule Notifikasi:**
```dart
// Pull-to-refresh di home page
// Atau restart app
```

### Suara masih default?

**1. File adzan belum ditambahkan:**
```bash
# Check file exists
ls -la android/app/src/main/res/raw/adzan.mp3
```

**2. Channel ter-cache:**
```bash
# Uninstall & reinstall
flutter clean
adb uninstall com.example.app  # atau package name kamu
flutter run
```

**3. Format file salah:**
```bash
# Must be MP3, lowercase filename, no spaces
# Compress if too large:
ffmpeg -i adzan.mp3 -b:a 64k adzan_compressed.mp3
mv adzan_compressed.mp3 android/app/src/main/res/raw/adzan.mp3
```

## 📝 Code Changes Summary

### NotificationService Updates:

1. **Added custom channel** dengan adzan sound
2. **Changed to recurring** dengan `matchDateTimeComponents.time`
3. **Cancel all before schedule** untuk avoid duplicates
4. **Handle past times** - schedule untuk besok jika waktu udah lewat
5. **Full screen intent** untuk show notification even if locked
6. **Category alarm** untuk bypass DND (if user allows)

### Permissions Added:

- ✅ POST_NOTIFICATIONS (Android 13+)
- ✅ SCHEDULE_EXACT_ALARM (Android 12+)
- ✅ USE_EXACT_ALARM
- ✅ VIBRATE
- ✅ WAKE_LOCK
- ✅ RECEIVE_BOOT_COMPLETED

## 🎯 Expected Behavior

**Before fix:**
- ❌ Notif hanya muncul sekali (tidak recurring)
- ❌ Tidak muncul kalau waktu udah lewat
- ❌ Default notification sound

**After fix:**
- ✅ Notif muncul setiap hari pada waktu yang sama
- ✅ Auto-schedule untuk besok jika waktu sudah lewat
- ✅ Custom adzan sound (setelah file ditambahkan)
- ✅ Vibration works
- ✅ Show even on lock screen
- ✅ Bypass DND if user allows

## 📞 Next Steps

1. **Add file adzan** ke `android/app/src/main/res/raw/adzan.mp3`
2. **Test dengan time yang dekat** (1-2 menit ke depan)
3. **Verify recurring** - check besok apakah notif muncul lagi
4. **Polish UX** - maybe add test button di settings

---

**Status: READY** 🚀

Setelah file adzan ditambahkan, system notifikasi siap production!
