# 🕌 Saku Muslim - Aplikasi Islami Lengkap

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Aplikasi mobile Islamic companion lengkap dengan fitur jadwal sholat, Al-Qur'an digital, kalender Hijriyah, kiblat compass, dan banyak lagi!

## ✨ Fitur Utama

### 🎯 Fitur Gratis
- 🕌 **Jadwal Sholat** - Otomatis berdasarkan lokasi GPS
- 📿 **Al-Qur'an Digital** - 114 Surah lengkap dengan terjemahan Indonesia
- 🎵 **Audio Al-Qur'an** - Murottal berkualitas tinggi (streaming)
- 🧭 **Kiblat Compass** - Petunjuk arah kiblat akurat
- 📅 **Kalender Hijriyah** - Kalender Islam lengkap
- ⏰ **Notifikasi Adzan** - Pengingat waktu sholat
- 📖 **99 Asmaul Husna** - Nama-nama Allah yang indah
- 🤲 **Dzikir & Doa** - Kumpulan doa harian
- ⭐ **Bookmark Ayat** - Simpan ayat favorit (limited)

### 🌟 Fitur Premium
- 🎵 **Audio Offline** - Download audio Al-Qur'an untuk didengar tanpa internet
- 🌙 **Dark Mode** - Tema gelap yang nyaman untuk mata
- 📚 **Unlimited Bookmarks** - Simpan ayat favorit tanpa batas
- � **Masjid Terdekat** - Temukan masjid di sekitar lokasi Anda
- 🧮 **Kalkulator Zakat** - Hitung zakat fitrah dan mal dengan mudah
- 💾 **Backup & Restore** - Export/import semua data Anda
- 🎨 **Custom Themes** - Personalisasi tampilan aplikasi

[**📱 Upgrade ke Premium**](../PREMIUM_FEATURES.md) - Mulai dari Rp 19.000/bulan

## 🚀 Quick Start

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- Android Studio / VS Code
- Android device/emulator (Min SDK 21)

### Installation

```bash
# Clone repository
git clone [your-repo-url]
cd saku-muslim/app

# Install dependencies
flutter pub get

# Run app
flutter run
```

### Build Release

```bash
# Build APK
flutter build apk --release

# Build App Bundle (untuk Play Store)
flutter build appbundle --release
```

## 📱 Screenshots

[Tambahkan screenshots di sini]

## 🏗️ Arsitektur

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── prayer_schedule.dart
│   ├── surah.dart
│   └── ayat.dart
├── services/                 # Business logic
│   ├── location_service.dart
│   ├── prayer_time_api_service.dart
│   ├── quran_api_service.dart
│   ├── premium_service.dart
│   └── iap_service.dart
├── pages/                    # UI screens
│   ├── home_page.dart
│   ├── quran_page.dart
│   ├── calendar_page.dart
│   ├── menu_page.dart
│   └── premium_page.dart
└── widgets/                  # Reusable components
    ├── qibla_compass.dart
    └── premium_widgets.dart
```

## 🔧 Konfigurasi

### API Keys
App menggunakan API gratis:
- Prayer Times: [MuslimSalat API](https://muslimsalat.com/)
- Al-Qur'an: [Equran API](https://equran.id/apidev)

Tidak perlu API key khusus.

### Google Play Billing (Premium Features)
Untuk mengaktifkan fitur premium:

1. Setup Google Play Console
2. Buat 3 produk IAP dengan ID:
   - `premium_lifetime`
   - `premium_monthly`
   - `premium_yearly`
3. Upload app ke Play Console

[**Panduan Lengkap Setup IAP**](../IAP_SETUP_GUIDE.md)

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with specific device
flutter run -d [device-id]

# Enable debug logs
flutter run --verbose
```

### Test Premium Features Locally

```dart
// Di main.dart (temporary, untuk testing saja)
await PremiumService().setPremium(
  premiumType: 'lifetime',
);
```

**⚠️ Remove sebelum production!**

## 📦 Dependencies

### Core
```yaml
flutter: sdk
cupertino_icons: ^1.0.8
```

### Location & Prayer Times
```yaml
geolocator: ^14.0.2
geocoding: ^4.0.0
http: ^1.5.0
```

### Database & Storage
```yaml
sqflite: ^2.4.1
path: ^1.9.1
path_provider: ^2.1.5
shared_preferences: ^2.2.2
```

### Premium Features
```yaml
in_app_purchase: ^3.2.0
```

### UI & Features
```yaml
table_calendar: ^3.2.0
flutter_compass: ^0.8.1
audioplayers: ^6.5.1
flutter_local_notifications: ^17.2.3
```

[**Full Dependencies**](pubspec.yaml)

## 📚 Dokumentasi

- [**Premium Features Guide**](../PREMIUM_FEATURES.md) - Panduan fitur premium
- [**IAP Setup Guide**](../IAP_SETUP_GUIDE.md) - Setup Google Play billing
- [**Implementation Summary**](../IMPLEMENTATION_SUMMARY.md) - Summary implementasi
- [**Quick Start**](../QUICK_START.md) - Quick start guide
- [**Code Examples**](lib/examples/premium_feature_examples.dart) - Contoh kode
- [**Changelog**](../CHANGELOG_PREMIUM.md) - Version history

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

### Developer
**Rio Prastiawan**

### APIs Used
- [MuslimSalat API](https://muslimsalat.com/) - Prayer times
- [Equran API](https://equran.id/apidev) - Al-Qur'an content
- Google Play Billing - In-app purchases

### Open Source Libraries
Thanks to all Flutter package maintainers!

## 📞 Support

- **Email**: support@sakumuslim.com (ganti dengan email Anda)
- **Issues**: [GitHub Issues](your-repo/issues)
- **Discussions**: [GitHub Discussions](your-repo/discussions)

## 🌟 Star History

If you find this project helpful, please give it a ⭐!

---

**Jazakallahu khairan! May this app benefit Muslims worldwide! 🌙**

---

## 📱 Download

[Google Play Store Badge - Coming Soon]

---

*Last Updated: December 28, 2025*
*Version: 1.0.0+2*
