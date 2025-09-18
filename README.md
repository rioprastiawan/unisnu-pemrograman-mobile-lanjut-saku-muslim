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

- Jadwal sholat harian (Imsak, Subuh, Dzuhur, Ashar, Maghrib, Isya) berdasarkan lokasi
- Deteksi lokasi otomatis dengan GPS
- Input lokasi manual untuk fleksibilitas
- Penanda visual untuk waktu sholat berikutnya
- **Data akurat** menggunakan metode kalkulasi Kemenag RI

### 🧭 Arah Kiblat

- Kompas interaktif yang menunjukkan arah Kiblat secara real-time
- Informasi derajat arah Kiblat yang presisi
- Menggunakan sensor magnetometer dan akselerometer perangkat
- Kalkulasi berdasarkan koordinat Ka'bah yang akurat

### 📅 Kalender Islam

- Tampilan tanggal Masehi dan Hijriah secara bersamaan
- Kalender bulanan dengan navigasi yang mudah
- Sinkronisasi otomatis dengan data API

### 🌟 Asmaul Husna

- Daftar lengkap 99 nama Allah SWT
- Tulisan Arab, transliterasi Latin, dan terjemahan Indonesia
- Antarmuka yang mudah di-scroll dan dibaca
- Data tersimpan lokal untuk akses offline

### 🤲 Doa Harian

- Kumpulan doa-doa harian esensial
- Kategorisasi doa untuk kemudahan navigasi
- Format lengkap: Arab, Latin, dan terjemahan
- Akses offline penuh

## 🛠️ Teknologi

### Framework & Tools

- **Flutter** - Framework UI cross-platform
- **Dart** - Bahasa pemrograman

### Dependencies Utama

- `provider` - State management
- `http` / `dio` - HTTP client untuk API calls
- `geolocator` - Akses lokasi GPS
- `flutter_qiblah` - Fungsionalitas kompas kiblat
- `shared_preferences` - Penyimpanan data lokal

### Platform Target

- **Android** 6.0+ (API level 23)
- **iOS** 12.0+

### API External

- **Al-Adhan API** (`aladhan.com`) - Data jadwal sholat dan kalender Hijriah

## 🏗️ Arsitektur

Aplikasi menggunakan **Feature-Driven MVVM** architecture pattern:

```
┌─────────────────┐
│      View       │ ← UI Layer (Flutter Widgets)
│   (Widgets)     │
└─────────────────┘
         ↕
┌─────────────────┐
│   ViewModel     │ ← Business Logic Layer
│ (ChangeNotifier)│
└─────────────────┘
         ↕
┌─────────────────┐
│     Service     │ ← Data Access Layer
│  (API, Local)   │
└─────────────────┘
         ↕
┌─────────────────┐
│     Model       │ ← Data Layer (PODOs)
│    (PODOs)      │
└─────────────────┘
```

### State Management

- **Provider** untuk dependency injection dan state management
- **ChangeNotifier** untuk reactive UI updates

## 🚀 Instalasi & Setup

### Prerequisites

- Flutter SDK (versi stabil terbaru)
- Android Studio / VS Code
- Git

### Langkah-langkah

1. **Clone repository**

   ```bash
   git clone https://github.com/rioprastiawan/unisnu-pemrograman-mobile-lanjut-saku-muslim.git
   cd unisnu-pemrograman-mobile-lanjut-saku-muslim
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
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (memerlukan Xcode)
flutter build ios --release
```

## 📁 Struktur Project

```
saku_muslim/
├── lib/
│   ├── app/                    # Konfigurasi aplikasi
│   │   ├── config/            # Theme, routing
│   │   └── constants/         # Konstanta aplikasi
│   │
│   ├── core/                  # Core functionality
│   │   ├── services/          # API, Location, Asset services
│   │   ├── models/            # Data models
│   │   └── utils/             # Utility functions
│   │
│   ├── features/              # Feature modules
│   │   ├── home/              # Jadwal sholat
│   │   ├── qibla/             # Arah kiblat
│   │   ├── asmaul_husna/      # Asmaul Husna
│   │   ├── daily_doa/         # Doa harian
│   │   └── calendar/          # Kalender Islam
│   │
│   ├── shared_widgets/        # Reusable widgets
│   └── main.dart              # Entry point
│
├── assets/
│   └── data/                  # Static JSON data
│       ├── asmaul_husna.json
│       └── doa_harian.json
│
├── docs/                      # Project documentation
│   ├── 1-PRD.md              # Product Requirements
│   ├── 2-ERD.md              # Entity Relationship Diagram
│   ├── 3-SRS.md              # Software Requirements Specification
│   ├── 4-SDD.md              # Software Design Document
│   └── 5-Timeline.md         # Project timeline
│
└── README.md                  # This file
```

## 🔌 API Reference

### Al-Adhan API

**Base URL:** `http://api.aladhan.com/v1/`

#### Get Prayer Times

```http
GET /timings/{date}
```

**Parameters:**

- `latitude` (required): Koordinat lintang
- `longitude` (required): Koordinat bujur
- `method`: Metode kalkulasi (default: 11 untuk Kemenag RI)

**Response Example:**

```json
{
  "code": 200,
  "status": "OK",
  "data": {
    "timings": {
      "Fajr": "04:32",
      "Sunrise": "05:46",
      "Dhuhr": "11:57",
      "Asr": "15:18",
      "Maghrib": "17:59",
      "Isha": "19:11"
    },
    "date": {
      "hijri": {
        "date": "10-04-1445",
        "day": "10",
        "month": { "en": "Rabīʿ al-thānī" },
        "year": "1445"
      }
    }
  }
}
```

## 🤝 Kontribusi

Kami menyambut kontribusi dari komunitas! Berikut cara berkontribusi:

1. **Fork** repository ini
2. **Create** branch fitur (`git checkout -b feature/AmazingFeature`)
3. **Commit** perubahan (`git commit -m 'Add some AmazingFeature'`)
4. **Push** ke branch (`git push origin feature/AmazingFeature`)
5. **Open** Pull Request

### Guidelines

- Ikuti struktur arsitektur yang sudah ada
- Pastikan kode sudah ditest
- Tulis commit message yang jelas
- Update dokumentasi jika diperlukan

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

## 🌟 Fitur Mendatang (Post-MVP)

- 🔔 Notifikasi Adzan
- 📿 Tasbih Digital
- 🗺️ Masjid Terdekat
- 📰 Artikel Islami Ringkas
- ⚙️ Pengaturan Lanjutan

---

<div align="center">

**Dibuat dengan ❤️ untuk umat Muslim Indonesia**

[⬆ Kembali ke atas](#saku-muslim-)

</div>
