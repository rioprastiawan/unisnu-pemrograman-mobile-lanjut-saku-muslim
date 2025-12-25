# Audio Assets

## Adzan Sound Required

Untuk notifikasi adzan berfungsi dengan suara adzan, Anda perlu menambahkan file audio:

### 1. Download Suara Adzan
Cari dan download file MP3 suara adzan (durasi 1-2 menit recommended)

Sumber yang bisa digunakan:
- https://www.zapsplat.com (search "adhan" atau "azan")
- https://freesound.org (search "adhan")
- Atau rekam sendiri

### 2. Prepare File untuk Android

#### a. Convert ke format yang tepat:
```bash
# Recommended: 16000Hz sample rate, mono
ffmpeg -i input_adzan.mp3 -ar 16000 -ac 1 adzan.mp3
```

#### b. Copy file ke folder Android:
```bash
# File harus ada di folder raw Android
cp adzan.mp3 android/app/src/main/res/raw/adzan.mp3
```

#### c. Jika folder `raw` belum ada, buat dulu:
```bash
mkdir -p android/app/src/main/res/raw
```

### 3. Untuk iOS (Optional)

Copy file ke folder iOS:
```bash
# iOS menggunakan format .mp3 langsung
cp adzan.mp3 ios/Runner/adzan.mp3
```

Lalu tambahkan ke `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

---

## Quick Setup (Copy-Paste)

### Android Only (Minimum):
```bash
# 1. Buat folder raw
mkdir -p android/app/src/main/res/raw

# 2. Download contoh adzan (atau pakai file sendiri)
# Simpan sebagai: android/app/src/main/res/raw/adzan.mp3

# 3. File size: maksimal 1-2 MB (agar tidak membengkakkan APK)
```

### Setelah file ditambahkan:
```bash
# Rebuild app
flutter clean
flutter pub get
flutter run
```

---

## Format File yang Disarankan

- **Format**: MP3
- **Sample Rate**: 16000 Hz atau 44100 Hz
- **Channels**: Mono (1 channel)
- **Bitrate**: 64-128 kbps
- **Duration**: 30-90 detik (cukup untuk adzan singkat)
- **File Size**: < 1 MB

---

## Troubleshooting

### Suara tidak keluar?
1. Pastikan file ada di `android/app/src/main/res/raw/adzan.mp3`
2. Nama file harus `adzan.mp3` (lowercase, no spaces)
3. Rebuild app dengan `flutter clean`
4. Check notification permission di Settings HP

### File terlalu besar?
```bash
# Compress dengan ffmpeg
ffmpeg -i adzan.mp3 -b:a 64k -ar 16000 adzan_compressed.mp3
```

### Masih pakai default sound?
- Uninstall app dulu
- Reinstall
- Notification channel ter-cache di Android, perlu fresh install

---

## Alternative: Use Default Sound (Temporary)

Jika belum ada file adzan, app akan pakai default notification sound. 
Setelah file adzan ditambahkan, uninstall & reinstall untuk apply perubahan.
