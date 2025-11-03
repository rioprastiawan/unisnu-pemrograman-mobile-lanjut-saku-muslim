# Product Requirements Document (PRD): Saku Muslim

- **Versi:** 2.0 (Active Development)
- **Tanggal Dibuat:** 18 September 2024
- **Tanggal Update:** 3 November 2024
- **Author**
  - Bimo Rio Prastiawan (221240001220)
  - Rizky Alhusani Ghifari (221240001300)
- **Status:** Active Development - In Progress

---

## Revision History

| Versi | Tanggal       | Perubahan                                                                                                    | Author       |
| ----- | ------------- | ------------------------------------------------------------------------------------------------------------ | ------------ |
| 1.0   | 18 Sep 2024   | Initial draft - MVP requirements                                                                             | Tim          |
| 2.0   | 3 Nov 2024    | Update: MVP completed, Al-Qur'an feature added, monetization strategy, feedback dosen tentang premium features | Tim          |

---

## 1. Latar Belakang & Visi Produk

### 1.1. Masalah yang Diselesaikan

Banyak aplikasi Islami yang tersedia saat ini cenderung berat, dipenuhi iklan yang mengganggu, dan memiliki fitur yang terlalu kompleks (berita, konten video, media sosial) yang tidak dibutuhkan oleh pengguna untuk kebutuhan ibadah inti. Hal ini menyebabkan pengalaman pengguna menjadi lambat dan tidak fokus. Pengguna membutuhkan sebuah alat bantu ibadah yang **simpel, ringan, cepat, dan kembali ke esensi**.

### 1.2. Visi Produk

Menjadi aplikasi pendamping ibadah harian yang paling **andal, ringan, dan mudah digunakan** di platform mobile, memungkinkan setiap Muslim untuk memenuhi kewajiban spiritualnya dengan mudah dan tanpa gangguan.

### 1.3. Proposisi Nilai Utama (Unique Value Proposition)

> "Ibadah harianmu, di ujung jari. Simpel, ringan, dan fokus pada yang terpenting."

---

## 2. Target Pengguna

Aplikasi ini ditujukan untuk Muslim di Indonesia, terutama yang menginginkan pengalaman digital yang minimalis dan efisien.

- **Persona 1: Budi, Mahasiswa Rantau**

  - **Kebutuhan:** Mengetahui jadwal sholat yang akurat di kota barunya, mencari arah kiblat di kamar kost, dan mengakses doa-doa harian dengan cepat.
  - **Frustrasi:** Aplikasi lain terlalu besar ukurannya, memakan banyak RAM, dan sering menampilkan notifikasi yang tidak relevan.
  - **Tujuan:** Memiliki satu aplikasi andalan yang "just works" untuk kebutuhan ibadah dasarnya tanpa membuat ponselnya lambat.

- **Persona 2: Citra, Karyawan Muda**
  - **Kebutuhan:** Alat yang cepat untuk mengecek waktu sholat sebelum mengatur jadwal meeting.
  - **Frustrasi:** Antarmuka aplikasi lain terlalu ramai dan butuh beberapa kali klik hanya untuk melihat jadwal sholat.
  - **Tujuan:** Mengintegrasikan kewajiban ibadahnya ke dalam gaya hidupnya yang sibuk dengan cara yang seamless dan efisien.

---

## 3. Tujuan & Metrik Kesuksesan (Untuk Proyek)

### 3.1. Tujuan Produk

- **Bagi Pengguna (Free Tier):** Memberikan akses cepat dan akurat ke informasi ibadah esensial (waktu sholat, arah kiblat, Al-Qur'an digital) tanpa gangguan berlebihan.
- **Bagi Pengguna (Premium Tier):** Memberikan fitur tambahan yang membantu pengelolaan kehidupan Muslim modern (pencatatan keuangan Islami, backup cloud, pengalaman bebas iklan).
- **Bagi Developer:** Membangun aplikasi portofolio yang solid, fungsional, user-centric, dan sustainable melalui model bisnis freemium.

### 3.2. Metrik Kesuksesan Proyek

**Technical Metrics:**
- **Fungsionalitas:** Semua fitur dalam lingkup MVP + Al-Qur'an berhasil diimplementasikan dan berfungsi tanpa bug mayor. ✅ **ACHIEVED**
- **Performa:** Aplikasi terasa responsif dan ringan (cold start < 2 detik, 60 FPS navigation). ✅ **ACHIEVED**
- **Kualitas Kode:** Kode ditulis dengan rapi, terstruktur, mengikuti best practices Flutter. ✅ **ACHIEVED**

**Business Metrics (Post-Launch):**
- **User Acquisition:** Target 100+ downloads dalam 3 bulan pertama
- **Conversion Rate:** Target 5-10% pengguna upgrade ke Premium
- **Retention:** Target 60% pengguna aktif setelah 1 bulan
- **Revenue:** Target Rp 500.000 - Rp 1.000.000 dalam 6 bulan pertama

**User Satisfaction:**
- Rating minimal 4.5/5.0 di Google Play Store
- Feedback positif dari dosen dan peer review
- NPS (Net Promoter Score) > 50

---

## 4. Fitur & Ruang Lingkup (Scope)

### 4.1. Rilis MVP (Minimum Viable Product) - ✅ STATUS: COMPLETED

Fokus pada fungsionalitas inti agar aplikasi dapat memberikan nilai esensial sejak awal.

| ID       | Fitur              | Deskripsi                                                                                                                                                           | Status        | Prioritas |
| :------- | :----------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------ | :-------- |
| **F1.1** | **Jadwal Sholat**  | Menampilkan jadwal 8 waktu sholat (Imsak, Subuh, Terbit, Dhuha, Dzuhur, Ashar, Maghrib, Isya) dengan deteksi lokasi otomatis, countdown, dan smart caching system. | ✅ **DONE**    | **Wajib** |
| **F2.1** | **Arah Kiblat**    | Kompas interaktif custom dengan sensor magnetometer, menampilkan derajat dan jarak ke Ka'bah. Accessible via FAB di Home.                                           | ✅ **DONE**    | **Wajib** |
| **F3.1** | **Kalender Islam** | Dual calendar system (Masehi & Hijriyah), toggle mode, calendar view dengan jadwal sholat per tanggal via bottom sheet.                                            | ✅ **DONE**    | **Wajib** |
| **F4.1** | **Asmaul Husna**   | Daftar 99 Asmaul Husna dengan tulisan Arab, Latin, terjemahan, dan makna lengkap dalam dialog detail. Data lokal.                                                   | ✅ **DONE**    | **Wajib** |
| **F5.1** | **Doa Harian**     | Kumpulan doa-doa harian esensial (sebelum makan, tidur, dll) dalam format daftar. Data lokal.                                                                       | ⏳ **PENDING** | **Wajib** |

### 4.2. Fitur Tambahan (Sudah Diimplementasikan) - ✅ BONUS FEATURES

| ID       | Fitur                      | Deskripsi                                                                                                                                          | Status      | Prioritas  |
| :------- | :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- | :---------- | :--------- |
| **F5.2** | **Al-Qur'an Digital**      | 114 surah lengkap dengan teks Arab, Latin, terjemahan Indonesia, audio per ayat & surah lengkap (Qari: Mishari Rashid), smart cache 30 hari.      | ✅ **DONE**  | **Tinggi** |
| **F6.1** | **Notifikasi Adzan**       | Pengingat waktu sholat dengan custom settings per sholat (enable/disable, suara, getar), timezone-aware, auto-schedule harian.                    | ✅ **DONE**  | **Tinggi** |
| **F6.2** | **Smart Caching System**   | SQLite database dengan 5 tabel, auto-refresh strategy, background updates, offline-first approach.                                                 | ✅ **DONE**  | **Tinggi** |
| **F6.3** | **Real-time Clock**        | Jam digital di Home dengan animasi colon berkedip dan countdown ke sholat berikutnya.                                                              | ✅ **DONE**  | **Medium** |

### 4.3. Rilis Selanjutnya - Phase 2 (Planned Features)

| ID        | Fitur                      | Deskripsi                                                                  | Prioritas  | Target  |
| :-------- | :------------------------- | :------------------------------------------------------------------------- | :--------- | :------ |
| **F7.1**  | **Tasbih Digital**         | Alat hitung digital sederhana untuk membantu pengguna berdzikir.           | **Tinggi** | Q1 2025 |
| **F8.1**  | **Masjid Terdekat**        | Integrasi dengan peta untuk menampilkan lokasi masjid-masjid terdekat.     | **Medium** | Q2 2025 |
| **F9.1**  | **Artikel Islami Ringkas** | Konten singkat seperti hadits pilihan atau kutipan inspiratif.             | **Medium** | Q2 2025 |
| **F10.1** | **Pengaturan Lanjutan**    | Opsi untuk mengubah metode kalkulasi jadwal sholat, tema, dll.            | **Rendah** | Q3 2025 |

### 4.4. Monetization Features - Phase 3 (NEW - Feedback Dosen)

#### 4.4.1. Free Tier (Dengan Iklan)

Semua fitur core tetap GRATIS dengan iklan non-intrusive:

| Fitur                      | Status Free Tier | Catatan                                   |
| :------------------------- | :--------------- | :---------------------------------------- |
| Jadwal Sholat              | ✅ Full Access   | **NO ADS** - Key Feature Protected         |
| Arah Kiblat                | ✅ Full Access   | **NO ADS** - Key Feature Protected         |
| Kalender Islam             | ✅ Full Access   | Banner ads OK                              |
| Al-Qur'an Digital          | ✅ Full Access   | Interstitial ads (1x per session) OK       |
| Asmaul Husna               | ✅ Full Access   | Banner ads OK                              |
| Doa Harian                 | ✅ Full Access   | Banner ads OK                              |
| Notifikasi Adzan           | ✅ Full Access   | -                                          |

#### 4.4.2. Premium Features (Subscription-based)

| ID        | Fitur Premium                  | Deskripsi                                                                                                               | Prioritas  | Target  |
| :-------- | :----------------------------- | :---------------------------------------------------------------------------------------------------------------------- | :--------- | :------ |
| **F11.1** | **Ad-Free Experience**         | Hapus semua iklan dari aplikasi untuk pengalaman yang lebih fokus dan nyaman.                                          | **Wajib**  | Phase 3 |
| **F12.1** | **Pencatatan Kas Islami**      | Fitur pencatatan keuangan pribadi dengan kategori Islami (Zakat, Infaq, Sedekah, Income Halal, dll). Export to Excel.  | **Wajib**  | Phase 3 |
| **F12.2** | **Statistik Keuangan**         | Dashboard visual untuk melihat pola pengeluaran, persentase zakat, grafik bulanan/tahunan.                             | **Tinggi** | Phase 3 |
| **F12.3** | **Reminder Zakat**             | Pengingat otomatis saat harta mencapai nisab zakat, kalkulasi zakat otomatis.                                          | **Tinggi** | Phase 3 |
| **F13.1** | **Cloud Backup & Sync**        | Backup otomatis data pencatatan kas ke cloud, sync antar device.                                                        | **Medium** | Phase 4 |
| **F13.2** | **Custom Themes**              | Pilihan tema warna premium (Dark Mode+, Gradient Themes, dll).                                                          | **Rendah** | Phase 4 |
| **F13.3** | **Widget Premium**             | Home screen widget untuk jadwal sholat dan kas harian.                                                                  | **Medium** | Phase 4 |
| **F13.4** | **Multiple Qari**              | Pilihan beberapa qari untuk audio Al-Qur'an (saat ini: Mishari Rashid only).                                           | **Medium** | Phase 4 |

#### 4.4.3. Ads Implementation Strategy

**Placement Zones (Non-Intrusive):**

| Lokasi                     | Jenis Ads          | Frekuensi              | Status               |
| :------------------------- | :----------------- | :--------------------- | :------------------- |
| Halaman Home               | ❌ **FORBIDDEN**    | -                      | Protected - Key Feature |
| Kompas Kiblat              | ❌ **FORBIDDEN**    | -                      | Protected - Key Feature |
| Halaman Menu Lainnya       | ✅ Banner Bottom    | Always visible         | Allowed              |
| Halaman Settings           | ✅ Banner Bottom    | Always visible         | Allowed              |
| Halaman Asmaul Husna       | ✅ Banner Bottom    | Always visible         | Allowed              |
| Halaman Al-Qur'an (List)   | ✅ Banner Bottom    | Always visible         | Allowed              |
| Halaman Detail Surah       | ✅ Interstitial     | 1x per session         | Allowed              |
| Halaman Kalender           | ✅ Banner Bottom    | Always visible         | Allowed              |
| Setelah Baca Doa           | ✅ Interstitial     | Max 1x per 10 minutes  | Allowed              |

**Ads Network:**
- **Primary:** Google AdMob (Flutter plugin: `google_mobile_ads`)
- **Format:** Banner (320x50), Interstitial (Full-screen)
- **Targeting:** Halal products, Islamic content, education, fintech Syariah

### 4.5. Tidak Termasuk dalam Ruang Lingkup (Out of Scope)

Fitur-fitur berikut secara eksplisit **TIDAK** akan dibuat untuk menjaga kesederhanaan aplikasi:

- Fitur media sosial atau komunitas.
- Konten video atau streaming kajian.
- Fitur pembayaran Zakat, Infaq, Sedekah (transfer uang).
- Portal berita Islami.
- Game atau gamifikasi berlebihan.

---

## 5. Alur Pengguna (User Flow)

### 5.1. Alur Utama: Mengecek Jadwal Sholat (Free User)

1.  Pengguna membuka aplikasi untuk pertama kali.
2.  Aplikasi menampilkan **Splash Screen** dengan logo.
3.  Aplikasi menampilkan dialog permintaan izin akses lokasi. Pengguna menyetujui.
4.  Aplikasi mendarat di **Halaman Utama (Home)**.
5.  Jadwal sholat untuk hari itu langsung ditampilkan berdasarkan lokasi yang terdeteksi.
6.  **Waktu sholat berikutnya** ditandai dengan countdown waktu tersisa.
7.  **NO ADS** di halaman ini - key feature protected.

### 5.2. Alur Sekunder: Mencari Arah Kiblat (Free User)

1.  Dari **Halaman Utama**, pengguna menekan **FAB "Arah Kiblat"**.
2.  Aplikasi membuka **Bottom Sheet Kompas Kiblat**.
3.  Pengguna melihat kompas yang menunjuk ke arah Kiblat dengan ikon Ka'bah berputar.
4.  **NO ADS** di kompas - key feature protected.
5.  Setelah selesai, pengguna menutup bottom sheet.

### 5.3. Alur Tertier: Membaca Al-Qur'an (Free User)

1.  Pengguna tap tab **"Al Quran"** di bottom navigation.
2.  Melihat list 114 surah dengan **banner ads di bottom** (non-intrusive).
3.  Tap salah satu surah untuk buka detail.
4.  Membaca ayat-ayat dengan audio player.
5.  **Interstitial ads muncul 1x per session** saat keluar dari detail surah (tidak mengganggu baca).
6.  Pengguna dapat skip ads setelah 5 detik.

### 5.4. Alur Premium: Upgrade ke Premium (NEW)

1.  Pengguna melihat **badge "Premium"** di menu atau banner "Upgrade".
2.  Tap untuk membuka **Halaman Premium Features**.
3.  Melihat benefit premium:
     - ✅ Bebas iklan
     - ✅ Pencatatan Kas Islami
     - ✅ Statistik keuangan
     - ✅ Cloud backup (future)
4.  Tap **"Langganan Sekarang"**.
5.  Pilih paket:
     - Monthly: Rp 5.000/bulan
     - Yearly: Rp 50.000/tahun (save 17%)
6.  Checkout via Google Play Billing.
7.  Setelah payment sukses, ads hilang dan fitur premium unlock.

### 5.5. Alur Premium: Pencatatan Kas (Premium User)

1.  Premium user membuka **Menu Lainnya**.
2.  Tap **"Pencatatan Kas"** (icon dengan badge premium).
3.  Melihat dashboard kas:
     - Total income
     - Total pengeluaran
     - Saldo tersisa
     - Grafik bulanan
4.  Tap **"+ Tambah Transaksi"**.
5.  Input:
     - Jenis: Income / Pengeluaran
     - Kategori: Zakat, Infaq, Sedekah, Gaji Halal, Belanja, dll
     - Nominal
     - Tanggal
     - Catatan (optional)
6.  Save transaksi.
7.  Otomatis masuk ke statistik dan reminder zakat (jika mencapai nisab).

---

## 6. Persyaratan Non-Fungsional

### 6.1. Kinerja (Performance)
- **Cold Start Time:** < 2 detik (✅ Achieved)
- **Navigation:** 60 FPS, instant page transitions (✅ Achieved)
- **Battery Usage:** Efisien - tidak drain battery di background
- **Data Usage:** Minimal - smart caching reduce API calls
- **App Size:** < 50 MB untuk download, < 100 MB setelah install dengan cache

### 6.2. Usability
- **UI/UX:** Bersih, modern, intuitif mengikuti Material Design 3
- **Information Architecture:** Jadwal sholat berikutnya langsung terlihat saat buka app
- **Accessibility:** Font readable, contrast ratio WCAG AA compliant
- **Ads (Free Tier):** Non-intrusive, tidak mengganggu core features
- **Premium Upgrade:** Clear value proposition, seamless upgrade flow

### 6.3. Keandalan (Reliability)
- **Offline Mode:** App tetap functional dengan cached data saat tidak ada internet
- **Error Handling:** User-friendly error messages dengan retry options
- **Crash Rate:** < 1% crash-free rate
- **Data Integrity:** Backup lokal otomatis untuk data pencatatan kas (premium)

### 6.4. Keamanan & Privacy
- **Location Data:** Hanya digunakan untuk jadwal sholat, tidak di-share ke third party
- **User Data (Premium):** Enkripsi end-to-end untuk data pencatatan kas
- **Cloud Backup (Premium):** Secure cloud storage dengan authentication
- **Ads:** Halal ads only, no gambling/alcohol/haram content
- **GDPR Compliance:** User dapat delete account dan data sepenuhnya

### 6.5. Monetization Requirements
- **Ads Display:**
  - Must NOT interfere with prayer times checking (Home & Qibla protected)
  - Banner ads max 50px height
  - Interstitial ads max 1x per session
  - User can skip interstitial after 5 seconds
- **Subscription:**
  - Monthly & Yearly options
  - Grace period 3 hari setelah expired
  - Easy cancel/refund process via Google Play
- **Premium Features:**
  - Instant unlock setelah payment
  - Sync across devices dengan same Google account

### 6.6. Teknologi

**Framework & Language:**
- **Flutter** 3.9.2+ dengan Dart
- **Material Design 3** untuk UI components

**APIs:**
- **MyQuran API** (`https://api.myquran.com/v2`) - Jadwal sholat untuk Indonesia
- **Equran API** (`https://equran.id/api/v2`) - Al-Qur'an digital dengan audio

**Plugins & Libraries:**
- `geolocator` ^14.0.2 - GPS location
- `geocoding` ^4.0.0 - Reverse geocoding
- `http` ^1.5.0 - API calls
- `sqflite` ^2.4.1 - Local database caching
- `flutter_compass` ^0.8.1 - Compass sensor (bukan `flutter_qiblah`)
- `hijri` ^3.0.0 - Kalender Hijriyah
- `audioplayers` ^6.5.1 - Audio player untuk tilawah
- `flutter_local_notifications` ^17.2.3 - Adzan notifications
- `timezone` ^0.9.4 - Timezone handling
- `shared_preferences` ^2.2.2 - User settings
- `table_calendar` ^3.2.0 - Calendar widget

**Monetization Plugins (Phase 3):**
- `google_mobile_ads` - AdMob integration
- `in_app_purchase` - Google Play Billing untuk subscription

**Platform:**
- **Android** 6.0+ (API level 23+)
- **iOS** 12.0+ (future consideration)

---

## 7. Monetization Strategy (NEW)

### 7.1. Business Model: Freemium + Subscription

**Free Tier:**
- Akses penuh ke semua fitur core (Jadwal Sholat, Kiblat, Al-Qur'an, Kalender, Asmaul Husna, Doa, Notifikasi)
- Dengan iklan non-intrusive di area non-critical
- Target: User acquisition & viral growth

**Premium Tier (Subscription):**
- Ad-free experience
- Fitur tambahan: Pencatatan Kas Islami, Statistik, Cloud Backup (future)
- Target: Konversi 5-10% dari free users

### 7.2. Pricing Strategy

| Paket          | Harga         | Diskon  | Best For                          |
| :------------- | :------------ | :------ | :-------------------------------- |
| **Monthly**    | Rp 10.000/bln | -       | Trial premium, casual users       |
| **Yearly**     | Rp 100.000/th | 17% OFF | Power users, best value           |
| **Lifetime**   | Rp 200.000    | -       | Future consideration, early birds |

**Promo Launch (3 bulan pertama):**
- Monthly: Rp 5.000/bln (50% OFF)
- Yearly: Rp 50.000/th (50% OFF)

### 7.3. Revenue Projections (Optimistic)

**Asumsi:**
- 500 downloads dalam 6 bulan
- 5% conversion to premium (25 users)
- Average paket: Yearly (Rp 100.000)

**Estimated Revenue Year 1:**
- Premium Subscriptions: 25 users × Rp 100.000 = Rp 2.500.000
- Ads Revenue: 475 free users × Rp 500/month × 6 months = Rp 1.425.000
- **Total: ~Rp 3.925.000** dalam 6 bulan pertama

### 7.4. Ads Revenue Model

**AdMob Settings:**
- **eCPM Target:** Rp 5.000 - Rp 10.000 per 1000 impressions
- **Daily Active Users (DAU):** Target 100 users setelah 3 bulan
- **Ad Impressions per User:** ~5 impressions/day
- **Monthly Impressions:** 100 users × 5 × 30 days = 15.000 impressions
- **Monthly Ads Revenue:** 15 × Rp 7.500 (avg eCPM) = **Rp 112.500/month**

### 7.5. Value Proposition - Premium Features

**Pencatatan Kas Islami:**
- **Problem:** Susah track pengeluaran zakat, infaq, sedekah
- **Solution:** Digital ledger dengan kategori Islami
- **Benefit:** 
  - Tahu persis berapa total sedekah dalam setahun
  - Reminder otomatis saat harta mencapai nisab zakat
  - Export laporan untuk self-audit

**Ad-Free Experience:**
- **Problem:** Iklan mengganggu fokus ibadah
- **Solution:** Premium user tidak lihat iklan sama sekali
- **Benefit:** Pengalaman lebih khusyuk dan fokus

**Cloud Backup (Future):**
- **Problem:** Takut data kas hilang saat ganti HP
- **Solution:** Auto backup ke cloud
- **Benefit:** Data aman dan bisa diakses dari device manapun

### 7.6. Conversion Funnel

```
1000 App Opens
    ↓ (50% activation)
500 Active Users
    ↓ (80% retention after 1 week)
400 Weekly Active Users
    ↓ (10% exposed to premium feature)
40 Premium Page Visits
    ↓ (15% conversion rate)
6 Premium Subscribers
```

**Optimization Strategy:**
- A/B testing premium CTA placement
- Free trial 7 hari (future consideration)
- Referral program: Ajak teman dapat diskon (future)

---

## 8. Technical Architecture (Updated)

### 8.1. System Architecture

```
┌─────────────────────────────────┐
│      Presentation Layer         │
│   - UI Pages (Home, Qibla,      │
│     Quran, Calendar, etc)       │
│   - Premium Paywall UI          │
│   - Ads Integration UI          │
└─────────────────────────────────┘
              ↕
┌─────────────────────────────────┐
│      Business Logic Layer       │
│   - Services (Location, Prayer, │
│     Quran, Audio, Notification) │
│   - Subscription Manager (NEW)  │
│   - Ads Manager (NEW)           │
│   - Financial Tracker (NEW)     │
└─────────────────────────────────┘
              ↕
┌─────────────────────────────────┐
│         Data Layer              │
│   - SQLite (Cache + Kas Data)   │
│   - Shared Preferences          │
│   - External APIs               │
│   - Google Play Billing (NEW)   │
│   - AdMob (NEW)                 │
└─────────────────────────────────┘
```

### 8.2. Database Schema Extension (Phase 3)

**New Tables for Premium Features:**

**6. user_subscription**
- `id`, `subscription_type` (monthly/yearly), `start_date`, `end_date`, `is_active`, `google_purchase_token`

**7. financial_transactions**
- `id`, `transaction_type` (income/expense), `category`, `amount`, `date`, `notes`, `created_at`, `updated_at`

**8. financial_categories**
- `id`, `name`, `type` (income/expense), `icon`, `is_default`, `is_zakat_related`

**9. zakat_tracking**
- `id`, `total_wealth`, `nisab_threshold`, `zakat_due`, `last_calculated`, `reminder_sent`

### 8.3. State Management Strategy

- **Current:** StatefulWidget dengan setState()
- **Phase 3 Addition:** 
  - `Provider` atau `Riverpod` untuk subscription state
  - `Stream` untuk real-time premium status
  - `ChangeNotifier` untuk financial data

---

## 9. Development Roadmap

### Phase 1: MVP (✅ COMPLETED - Sep - Oct 2024)
- ✅ Jadwal Sholat dengan GPS
- ✅ Kompas Kiblat
- ✅ Kalender Islam
- ✅ Asmaul Husna
- ✅ **BONUS:** Al-Qur'an Digital lengkap
- ✅ **BONUS:** Notifikasi Adzan
- ✅ **BONUS:** Smart Caching System

### Phase 2: Polish & Optimization (Current - Nov 2024)
- ⏳ Bug fixes & performance optimization
- ⏳ UI/UX refinements
- ⏳ Doa Harian (completion of MVP)
- ⏳ Documentation & testing

### Phase 3: Monetization (Target: Dec 2024 - Jan 2025)
- 📋 AdMob integration
- 📋 Google Play Billing setup
- 📋 Premium paywall UI
- 📋 Pencatatan Kas Islami (MVP version)
- 📋 Subscription management
- 📋 Analytics & tracking

### Phase 4: Premium Features Expansion (Target: Feb - Mar 2025)
- 📋 Cloud Backup & Sync
- 📋 Statistik Keuangan advanced
- 📋 Custom Themes
- 📋 Widget Premium
- 📋 Multiple Qari options

### Phase 5: Growth & Scaling (Target: Apr - Jun 2025)
- 📋 Marketing campaign
- 📋 User feedback iteration
- 📋 A/B testing optimization
- 📋 Community building
- 📋 iOS version consideration

---

## 10. Success Metrics & KPIs

### Development Phase Metrics (Current)
- ✅ Code Quality: Clean, documented, maintainable
- ✅ Feature Completion: 80% MVP + 100% bonus features
- ✅ Performance: < 2s cold start, 60 FPS navigation
- ✅ Crash-free Rate: Target > 99%

### Launch Phase Metrics (Phase 3)
- 📊 Downloads: 100+ in first month
- 📊 Daily Active Users (DAU): 50+ after 1 month
- 📊 User Retention: 60% D7 retention
- 📊 Rating: 4.5+ stars on Play Store

### Business Phase Metrics (Phase 4-5)
- 💰 Conversion Rate: 5-10% free to premium
- 💰 Monthly Recurring Revenue (MRR): Rp 500.000+ after 3 months
- 💰 Churn Rate: < 5% monthly
- 💰 Lifetime Value (LTV): Rp 100.000+ per premium user

### User Satisfaction Metrics
- 😊 Net Promoter Score (NPS): > 50
- 😊 Support Tickets: < 5% users
- 😊 Feature Requests: Active community feedback
- 😊 Halal Certification: Positive feedback on ad quality

---

## 11. Risk Management

### Technical Risks

| Risk                           | Impact | Probability | Mitigation                                        |
| :----------------------------- | :----- | :---------- | :------------------------------------------------ |
| API downtime (MyQuran/Equran)  | High   | Low         | Local cache, fallback API, offline mode          |
| GPS inaccurate di indoor       | Medium | Medium      | Manual location input, city selection             |
| Compass sensor tidak tersedia  | Medium | Low         | Fallback to map-based qibla direction             |
| Ads SDK conflict               | Low    | Low         | Proper version management, testing                |
| Payment gateway issue          | High   | Low         | Google Play Billing (reliable), clear error msg   |

### Business Risks

| Risk                              | Impact | Probability | Mitigation                                     |
| :-------------------------------- | :----- | :---------- | :--------------------------------------------- |
| Low conversion to premium         | High   | Medium      | Free trial, clear value prop, A/B testing      |
| Haram ads displayed               | High   | Low         | AdMob content filtering, manual review         |
| User privacy concerns             | High   | Low         | Clear privacy policy, GDPR compliance          |
| Kompetitor dengan fitur serupa    | Medium | High        | Focus on UX, performance, Halal guarantee      |
| Refund requests tinggi            | Medium | Low         | Grace period, excellent support, fair policy   |

### Compliance Risks

| Risk                       | Impact | Probability | Mitigation                                        |
| :------------------------- | :----- | :---------- | :------------------------------------------------ |
| Google Play policy violation | High   | Low         | Follow guidelines, clear app description          |
| Islamic content accuracy   | High   | Medium      | Use verified APIs, disclaimer, user feedback      |
| Data protection violation  | High   | Low         | Encryption, secure cloud, user consent            |

---

## 12. Appendix

### A. Glossary

- **DAU:** Daily Active Users
- **MAU:** Monthly Active Users
- **MRR:** Monthly Recurring Revenue
- **eCPM:** Effective Cost Per Mille (per 1000 ad impressions)
- **Nisab:** Batas minimum harta untuk wajib zakat
- **Freemium:** Business model dengan basic free + premium paid

### B. References

- **MyQuran API Documentation:** https://api.myquran.com/v2
- **Equran API Documentation:** https://equran.id/api/v2/docs
- **Google Play Billing Guide:** https://developer.android.com/google/play/billing
- **AdMob Best Practices:** https://support.google.com/admob/answer/6128543
- **Flutter Monetization:** https://flutter.dev/monetization

### C. Feedback Log (Dosen & Stakeholders)

| Tanggal     | Feedback From | Feedback                                                      | Action Taken                                        |
| :---------- | :------------ | :------------------------------------------------------------ | :-------------------------------------------------- |
| 3 Nov 2024  | Dosen         | Tambahkan monetisasi: ads (non-intrusive) + premium features | ✅ Added monetization strategy to PRD                |
| 3 Nov 2024  | Dosen         | Premium feature suggestion: Pencatatan Kas Islami            | ✅ Added financial tracker as premium feature        |
| 3 Nov 2024  | Dosen         | Key features (jadwal sholat & kiblat) harus protected        | ✅ Defined protected zones: NO ADS on Home & Qibla   |
| 3 Nov 2024  | Dosen         | Model bisnis: subscription-based                             | ✅ Designed freemium + subscription model            |

### D. Contact & Support

**Development Team:**
- Bimo Rio Prastiawan: [NIM 221240001220]
- Rizky Alhusani Ghifari: [NIM 221240001300]

**Institution:**
- Universitas Islam Nahdlatul Ulama Jepara
- Program Studi: Teknik Informatika
- Mata Kuliah: Pemrograman Mobile Lanjut
- Semester: 7 (Ganjil 2024/2025)

**Project Repository:**
- GitHub: https://github.com/rioprastiawan/unisnu-pemrograman-mobile-lanjut-saku-muslim

---

## 13. Conclusion & Next Steps

### Summary
Saku Muslim telah berhasil mencapai dan **melampaui target MVP** dengan implementasi fitur Al-Qur'an digital, notifikasi adzan, dan smart caching system yang tidak ada di PRD awal. Aplikasi kini siap untuk fase monetisasi dengan strategi freemium yang balance antara:
- ✅ **Free tier** yang tetap powerful (semua core features accessible)
- ✅ **Premium tier** yang memberikan value jelas (ad-free + pencatatan kas)
- ✅ **Ads placement** yang ethical dan tidak mengganggu ibadah

### Immediate Next Steps (Phase 3 - Dec 2024)

1. **Week 1-2: Ads Integration**
   - Setup AdMob account
   - Implement banner ads di halaman non-critical
   - Test interstitial ads flow
   - Content filtering untuk halal ads only

2. **Week 3-4: Premium UI**
   - Design premium paywall screens
   - Implement subscription selection UI
   - Create feature comparison table

3. **Week 5-6: Google Play Billing**
   - Setup Google Play Console billing
   - Implement in-app purchase flow
   - Test subscription lifecycle (purchase, renew, cancel)

4. **Week 7-8: Pencatatan Kas (MVP)**
   - Database schema for transactions
   - CRUD operations UI
   - Basic statistics & export

5. **Week 9-10: Testing & Launch**
   - End-to-end testing
   - Beta testing dengan user grup kecil
   - Prepare Play Store listing
   - Soft launch

### Long-term Vision (2025)
Menjadikan **Saku Muslim** sebagai aplikasi pendamping ibadah #1 di Indonesia dengan:
- 10.000+ downloads
- 4.8+ rating
- 500+ premium subscribers
- **Self-sustainable** melalui model bisnis freemium
- **Community-driven** development dengan feedback loop
- **Halal-certified** content dan ads

---

**Document End - PRD Version 2.0**

*Last Updated: 3 November 2024*