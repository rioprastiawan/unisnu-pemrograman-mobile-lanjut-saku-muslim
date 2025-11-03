# Saku Muslim 📱🕌

> **Ibadah harianmu, di ujung jari. Simpel, ringan, dan fokus pada yang terpenting.**

Aplikasi mobile companion untuk ibadah harian umat Muslim yang dibangun dengan Flutter. Dirancang untuk menjadi **ringan, cepat, dan bebas dari gangguan** - kembali ke esensi kebutuhan spiritual tanpa fitur-fitur yang tidak perlu.

## 📋 Daftar Isi

- [Tentang Aplikasi](#-tentang-aplikasi)
- [Fitur Utama](#-fitur-utama)
- [Teknologi](#️-teknologi)
- [Arsitektur](#-arsitektur)
- [Instalasi & Setup](#-instalasi--setup)
- [Struktur Project](#-struktur-project)
- [API Reference](#-api-reference)
- [Kontribusi](#-kontribusi)
- [Tim Pengembang](#-tim-pengembang)
- [Dokumentasi](#-dokumentasi)
- [Lisensi](#-lisensi)

## 🎯 Tentang Aplikasi

### Latar Belakang

Banyak aplikasi Islami yang tersedia saat ini cenderung berat, dipenuhi iklan yang mengganggu, dan memiliki fitur yang terlalu kompleks (berita, konten video, media sosial) yang tidak dibutuhkan oleh pengguna untuk kebutuhan ibadah inti. Saku Muslim hadir untuk mengatasi masalah ini dengan menyediakan pengalaman yang **simpel, ringan, cepat, dan kembali ke esensi**.

### Target Pengguna

- **Mahasiswa Muslim** yang membutuhkan alat bantu ibadah yang tidak membebani perangkat
- **Pekerja Muda** yang ingin mengintegrasikan ibadah ke dalam kesibukan mereka
- **Setiap Muslim** yang menghargai kesederhanaan dan efisiensi dalam beribadah

### Visi Produk

Menjadi aplikasi pendamping ibadah harian yang paling **andal, ringan, dan mudah digunakan** di platform mobile, memungkinkan setiap Muslim untuk memenuhi kewajiban spiritualnya dengan mudah dan tanpa gangguan.

## ✨ Fitur Utama

### 🕕 Jadwal Sholat

- Jadwal sholat harian 8 waktu (Imsak, Subuh, Terbit, Dhuha, Dzuhur, Ashar, Maghrib, Isya) berdasarkan lokasi
- **Deteksi lokasi otomatis** dengan GPS menggunakan Geolocator & Geocoding
- **Jam digital real-time** dengan animasi colon berkedip
- **Countdown sholat selanjutnya** - menampilkan waktu tersisa hingga sholat berikutnya
- Indikator visual untuk waktu sholat yang sudah lewat vs belum lewat
- **Smart caching system** - data di-cache 10 menit untuk performa optimal
- **Background auto-refresh** - otomatis refresh jika cache stale atau lokasi berubah
- **Pull-to-refresh** manual untuk update data
- Normalisasi otomatis nama kota (Kabupaten/Kota format)
- Data dari **MyQuran API** - akurat untuk wilayah Indonesia

### 🧭 Arah Kiblat

- **Kompas interaktif** real-time menggunakan sensor magnetometer dan akselerometer
- Menampilkan **derajat arah Kiblat** dengan presisi tinggi
- Kalkulasi **jarak ke Ka'bah** (Mekah) dalam kilometer
- **Ikon Ka'bah** yang berputar mengikuti kompas menunjukkan arah Kiblat
- Panah merah fixed sebagai indikator arah depan perangkat
- **Custom compass painter** dengan mata angin Indonesia (U, S, T, B)
- Instruksi penggunaan yang jelas dan mudah dipahami
- Accessible via **Floating Action Button** di halaman Home

### 📅 Kalender Islam

- **Dual calendar system** - Masehi dan Hijriah ditampilkan bersamaan
- **Toggle mode** - pilih Masehi atau Hijriyah sebagai tampilan utama
- Setiap tanggal menampilkan **nomor ganda** (Masehi + Hijriyah)
- Navigasi bulan dengan chevron kiri/kanan
- Visual marker untuk hari ini (teal) dan tanggal dipilih (hijau)
- Highlight weekend dengan warna merah
- **Detail tanggal lengkap** saat cell diklik
- **Bottom sheet jadwal sholat per tanggal** - lihat jadwal sholat tanggal tertentu
- **FAB "Hari Ini"** untuk quick jump ke tanggal sekarang
- Integrasi dengan library **Hijri Calendar** untuk akurasi tinggi
- Cache jadwal sholat per tanggal

### � Al-Qur'an Digital

- **Daftar lengkap 114 Surah** dengan informasi:
  - Nomor urut dengan badge gradient hijau
  - Nama Arab (kanan) dan Nama Latin (kiri)
  - Arti/terjemahan surah
  - Jumlah ayat
  - Tempat turun (Mekah/Madinah) dengan badge berwarna
- **Detail Surah** dengan fitur lengkap:
  - Header gradient dengan info surah
  - **Audio player surah lengkap** (Qari: Mishari Rashid)
  - Deskripsi surah dengan expand/collapse
  - **List ayat** dengan format:
    - Teks Arab (font besar, right-aligned, line height 2)
    - Transliterasi Latin (italic, abu-abu)
    - Terjemahan Indonesia (dalam box hijau muda)
  - **Audio player per ayat** - play/pause dengan icon dinamis
  - Status playing dengan visual feedback
  - Navigasi surah sebelum/selanjutnya dengan **animasi slide**
- **Smart caching** - cache 30 hari untuk daftar dan detail surah
- Pull-to-refresh untuk update data
- Data dari **Equran API** (equran.id)

### 🌟 Asmaul Husna

- Daftar lengkap **99 Nama Allah SWT**
- Setiap nama menampilkan:
  - Nomor urut dengan badge gradient hijau
  - **Nama Arab** (font besar, bold)
  - **Transliterasi Latin** (uppercase, hijau, letter-spacing)
  - **Terjemahan singkat** (abu-abu)
- **Dialog detail** saat item diklik dengan:
  - Badge nomor circular
  - Nama Arab (font 32, bold)
  - Nama Latin (uppercase)
  - Terjemahan dalam box hijau muda
  - **Makna/penjelasan lengkap** dalam box abu-abu
- UI yang indah dan mudah dibaca
- **Data lokal** - tidak perlu koneksi internet

### 🔔 Notifikasi Adzan

- **Master toggle** - aktifkan/matikan semua notifikasi sekaligus
- Pengaturan individual per waktu sholat:
  - Subuh, Dzuhur, Ashar, Maghrib, Isya
  - Toggle enable/disable per sholat
  - Sub-setting **Suara** dan **Getar** per sholat
- **Auto-schedule** - notifikasi dijadwalkan otomatis setiap hari
- **Timezone aware** - menggunakan Asia/Jakarta timezone
- **Test notification** - fitur test untuk cek fungsi notifikasi
- Persistent settings menggunakan SQLite
- Integrasi dengan **flutter_local_notifications**

## 🛠️ Teknologi

### Framework & Tools

- **Flutter** - Framework UI cross-platform
- **Dart** - Bahasa pemrograman

### Dependencies Utama

- `geolocator` ^14.0.2 - Akses lokasi GPS
- `geocoding` ^4.0.0 - Reverse geocoding (koordinat ke nama kota)
- `http` ^1.5.0 - HTTP client untuk API calls
- `intl` ^0.20.2 - Internationalization dan date formatting
- `permission_handler` ^12.0.1 - Handling permissions
- `sqflite` ^2.4.1 - Local SQLite database untuk caching
- `path` ^1.9.1 - Path manipulation
- `shared_preferences` ^2.2.2 - Penyimpanan user settings
- `table_calendar` ^3.2.0 - Calendar widget
- `flutter_compass` ^0.8.1 - Compass sensor access
- `hijri` ^3.0.0 - Kalender Hijriyah
- `audioplayers` ^6.5.1 - Audio player untuk tilawah Al-Qur'an
- `flutter_local_notifications` ^17.2.3 - Local notifications
- `timezone` ^0.9.4 - Timezone handling untuk notifikasi

### Platform Target

- **Android** 6.0+ (API level 23)
- **iOS** 12.0+

### API External

- **MyQuran API** (`https://api.myquran.com/v2`)
  - Data jadwal sholat untuk kota-kota di Indonesia
  - Search kota/kabupaten
  - Mendukung filter berdasarkan tanggal
  
- **Equran API** (`https://equran.id/api/v2`)
  - Daftar 114 surah Al-Qur'an
  - Detail surah dengan ayat lengkap
  - Audio tilawah per ayat dan surah lengkap (Qari: Mishari Rashid)

## 🏗️ Arsitektur

Aplikasi menggunakan **Layered Architecture** dengan separation of concerns:

```
┌─────────────────────────────────┐
│      Presentation Layer         │ ← UI (Pages & Widgets)
│   - HomePage                    │
│   - CalendarPage                │
│   - QuranPage                   │
│   - SurahDetailPage             │
│   - AsmaulHusnaPage             │
│   - SettingsPage                │
└─────────────────────────────────┘
              ↕
┌─────────────────────────────────┐
│      Business Logic Layer       │ ← Services
│   - LocationService             │
│   - PrayerTimeApiService        │
│   - QuranApiService             │
│   - QuranAudioService           │
│   - QiblaService                │
│   - NotificationService         │
│   - DatabaseHelper              │
└─────────────────────────────────┘
              ↕
┌─────────────────────────────────┐
│         Data Layer              │ ← Models & Cache
│   - Models (PODOs)              │
│   - SQLite Database (Cache)     │
│   - Shared Preferences          │
│   - External APIs               │
└─────────────────────────────────┘
```

### State Management

- **StatefulWidget** dengan `setState()` untuk UI updates
- **Stream-based** untuk audio player state
- **FutureBuilder & async/await** untuk asynchronous operations
- **Database caching** untuk offline-first approach

## 🚀 Instalasi & Setup

### Prerequisites

- Flutter SDK (versi stabil terbaru)
- Android Studio / VS Code
- Git

### Langkah-langkah

1. **Clone repository**

   ```bash
   git clone https://github.com/rioprastiawan/unisnu-pemrograman-mobile-lanjut-saku-muslim.git
   cd unisnu-pemrograman-mobile-lanjut-saku-muslim/app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**

   ```bash
   # Debug mode
   flutter run

   # Release mode
   flutter run --release
   ```

### Build untuk Production

```bash
# Masuk ke folder app
cd app

# Android APK
flutter build apk --release

# Android App Bundle (untuk Google Play Store)
flutter build appbundle --release
```

### Permissions Required

Aplikasi membutuhkan permissions berikut (sudah dikonfigurasi di AndroidManifest.xml):

- **Location** - Untuk deteksi lokasi otomatis jadwal sholat
- **Internet** - Untuk mengambil data dari API
- **Notifications** - Untuk notifikasi adzan
- **Sensors** - Untuk kompas Kiblat (magnetometer)

## 📁 Struktur Project

```
saku-muslim/
├── app/                        # Folder aplikasi Flutter utama
│   ├── lib/
│   │   ├── main.dart          # Entry point aplikasi
│   │   │
│   │   ├── data/              # Static data
│   │   │   └── asmaul_husna_data.dart
│   │   │
│   │   ├── models/            # Data models (PODOs)
│   │   │   ├── asmaul_husna.dart
│   │   │   ├── ayat.dart
│   │   │   ├── city.dart
│   │   │   ├── prayer_schedule.dart
│   │   │   ├── prayer_time.dart
│   │   │   └── surah.dart
│   │   │
│   │   ├── pages/             # UI Pages
│   │   │   ├── splash_screen.dart
│   │   │   ├── home_page.dart
│   │   │   ├── calendar_page.dart
│   │   │   ├── quran_page.dart
│   │   │   ├── surah_detail_page.dart
│   │   │   ├── asmaul_husna_page.dart
│   │   │   ├── menu_page.dart
│   │   │   └── settings_page.dart
│   │   │
│   │   ├── services/          # Business logic & API services
│   │   │   ├── database_helper.dart
│   │   │   ├── location_service.dart
│   │   │   ├── prayer_time_api_service.dart
│   │   │   ├── quran_api_service.dart
│   │   │   ├── quran_audio_service.dart
│   │   │   ├── qibla_service.dart
│   │   │   └── notification_service.dart
│   │   │
│   │   └── widgets/           # Reusable widgets
│   │       ├── qibla_compass.dart
│   │       └── setting_widgets.dart
│   │
│   ├── android/               # Android platform files
│   ├── assets/                # Assets (icons, images)
│   ├── test/                  # Unit tests
│   └── pubspec.yaml           # Dependencies
│
├── docs/                      # Project documentation
│   ├── 1-PRD.md              # Product Requirements Document
│   ├── 2-ERD.md              # Entity Relationship Diagram
│   ├── 3-SRS.md              # Software Requirements Specification
│   ├── 4-SDD.md              # Software Design Document
│   └── 5-Timeline.md         # Project timeline
│
├── web/                       # Web version (Nuxt.js) - separate project
└── README.md                  # This file
```

## 🔌 API Reference

### MyQuran API

**Base URL:** `https://api.myquran.com/v2`

#### Search City

```http
GET /sholat/kota/cari/{keyword}
```

**Response Example:**

```json
{
  "status": true,
  "data": [
    {
      "id": "1301",
      "lokasi": "KAB. KUDUS"
    }
  ]
}
```

#### Get Prayer Schedule

```http
GET /sholat/jadwal/{cityId}/{year}/{month}/{day}
```

**Response Example:**

```json
{
  "status": true,
  "data": {
    "id": "1301",
    "lokasi": "KAB. KUDUS",
    "daerah": "Jawa Tengah",
    "jadwal": {
      "tanggal": "Minggu, 03/11/2024",
      "imsak": "04:05",
      "subuh": "04:15",
      "terbit": "05:29",
      "dhuha": "05:54",
      "dzuhur": "11:44",
      "ashar": "15:06",
      "maghrib": "17:53",
      "isya": "19:05",
      "date": "2024-11-03"
    }
  }
}
```

### Equran API

**Base URL:** `https://equran.id/api/v2`

#### Get All Surahs

```http
GET /surat
```

**Response Example:**

```json
{
  "code": 200,
  "message": "Success",
  "data": [
    {
      "nomor": 1,
      "nama": "الفاتحة",
      "namaLatin": "Al-Fatihah",
      "jumlahAyat": 7,
      "tempatTurun": "Mekah",
      "arti": "Pembukaan",
      "audioFull": {
        "05": "https://equran.id/audio-full/01-mishary.mp3"
      }
    }
  ]
}
```

#### Get Surah Detail

```http
GET /surat/{nomorSurah}
```

**Response includes:**
- Surah information
- Complete ayat list with Arabic text, Latin transliteration, and Indonesian translation
- Audio URL per ayat and full surah
- Previous/next surah navigation data

## 🤝 Kontribusi

Kami menyambut kontribusi dari komunitas! Berikut cara berkontribusi:

1. **Fork** repository ini
2. **Create** branch fitur (`git checkout -b feature/AmazingFeature`)
3. **Commit** perubahan (`git commit -m 'Add some AmazingFeature'`)
4. **Push** ke branch (`git push origin feature/AmazingFeature`)
5. **Open** Pull Request

### Guidelines

- Ikuti struktur arsitektur yang sudah ada
- Gunakan naming conventions yang konsisten
- Tambahkan comments untuk logic yang complex
- Test fitur baru sebelum PR
- Update dokumentasi jika diperlukan
- Keep PR focused (satu fitur per PR)

### Areas for Contribution

- 🐛 Bug fixes
- 🎨 UI/UX improvements
- 🧪 Writing tests
- 📝 Documentation improvements
- 🌐 Localization (Arabic, English, etc.)
- ✨ New features (lihat roadmap di Fitur Mendatang)

## 👥 Tim Pengembang

| Nama                       | NIM          | Role                             |
| -------------------------- | ------------ | -------------------------------- |
| **Bimo Rio Prastiawan**    | 221240001220 | Lead Developer & Project Manager |
| **Rizky Alhusani Ghifari** | 221240001300 | Developer & UI/UX Designer       |

**Institusi:** Universitas Islam Nahdlatul Ulama Jepara  
**Program Studi:** Teknik Informatika  
**Mata Kuliah:** Pemrograman Mobile Lanjut  
**Semester:** 7 (Semester Ganjil 2024/2025)

## 📖 Dokumentasi

Dokumentasi lengkap tersedia di folder `docs/`:

- **[PRD](docs/1-PRD.md)** - Product Requirements Document
- **[ERD](docs/2-ERD.md)** - Entity Relationship Diagram
- **[SRS](docs/3-SRS.md)** - Software Requirements Specification
- **[SDD](docs/4-SDD.md)** - Software Design Document
- **[Timeline](docs/5-Timeline.md)** - Project Timeline

## 📄 Lisensi

Project ini dikembangkan untuk keperluan akademik di Universitas Islam Nahdlatul Ulama Jepara.

Untuk penggunaan komersial atau distribusi, silakan hubungi tim pengembang.

---

## 🎨 Tech Stack Summary

**Frontend (Mobile)**
- Flutter 3.9.2+ (Dart)
- Material Design 3
- SQLite untuk caching
- AudioPlayers untuk tilawah
- Flutter Compass untuk Kiblat

**APIs**
- MyQuran API - Jadwal sholat
- Equran API - Al-Qur'an digital

**Services**
- Geolocator - GPS Location
- Local Notifications - Adzan reminders
- Timezone - Scheduling

---

## 🚀 Quick Start Commands

```bash
# Clone & Setup
git clone https://github.com/rioprastiawan/unisnu-pemrograman-mobile-lanjut-saku-muslim.git
cd unisnu-pemrograman-mobile-lanjut-saku-muslim/app
flutter pub get

# Run
flutter run

# Build APK
flutter build apk --release

# Clean
flutter clean
```

---

## 🌟 Fitur Mendatang (Post-MVP)

- � **Tasbih Digital** - Counter digital untuk dzikir
- 🗺️ **Masjid Terdekat** - Pencarian masjid di sekitar menggunakan Google Maps API
- 🤲 **Doa Harian** - Kumpulan doa-doa sehari-hari lengkap
- 💰 **Kalkulator Zakat** - Hitung zakat fitrah dan mal
- � **Artikel Islami** - Konten edukatif ringan
- ⚙️ **Pengaturan Lanjutan** - Tema, bahasa, dll
- 🔊 **Pilihan Qari** - Multiple qari untuk audio Al-Qur'an
- 📱 **Widget** - Home screen widget untuk jadwal sholat
- 🌙 **Ramadan Features** - Jadwal imsakiyah, niat puasa, dll

---

## � Database Schema

Aplikasi menggunakan **SQLite** dengan 5 tabel utama:

### 1. location_cache
Menyimpan cache lokasi user terakhir
- `id`, `city_id`, `city_name`, `latitude`, `longitude`, `last_updated`

### 2. prayer_schedule_cache
Cache jadwal sholat per tanggal dan kota
- `id`, `city_id`, `date`, `prayer_data` (JSON), `last_updated`

### 3. surah_cache
Cache daftar 114 surah
- `nomor`, `nama`, `namaLatin`, `arti`, `jumlahAyat`, `tempatTurun`, `audioFull`, `last_updated`

### 4. surah_detail_cache
Cache detail surah dengan ayat-ayat
- `nomor`, `detail_data` (JSON), `last_updated`

### 5. notification_settings
Pengaturan notifikasi per sholat
- `id`, `prayer_name`, `is_enabled`, `sound_enabled`, `vibrate_enabled`

### Cache Strategy
- **Location**: 10 menit validity, auto-refresh jika lokasi berubah > 5km
- **Prayer Schedule**: 10 menit validity per tanggal
- **Surah Data**: 30 hari validity
- **Auto Cleanup**: Hapus schedule lama otomatis

---

<div align="center">

**Dibuat dengan ❤️ untuk umat Muslim Indonesia**

[⬆ Kembali ke atas](#saku-muslim-)

</div>
