#ERD / SKEMA MODEL DATA: SAKU MUSLIM (DETAIL TEKNIS)

---

- **Versi:** 1.0 (MVP)
- **Tanggal:** 18 September 2025
- **Author**
  - Bimo Rio Prastiawan (221240001220)
  - Rizky Alhusani Ghifari (221240001300)
- **Status:** Draft

---

## 1. PENDAHULUAN

### 1.1. Tujuan Dokumen

Dokumen ini memberikan spesifikasi lengkap mengenai struktur, format, dan sumber semua data yang dikelola oleh aplikasi Saku Muslim. Karena aplikasi tidak menggunakan database relasional internal (seperti SQLite), dokumen ini akan merinci skema untuk tiga sumber data utama:

1.  **Data Eksternal (API):** Struktur data yang diterima dari API aladhan.com.
2.  **Data Statis (Aset Lokal):** Struktur file JSON yang dibundel dengan aplikasi.
3.  **Data Preferensi Pengguna:** Skema penyimpanan key-value lokal di perangkat.

### 1.2. Mekanisme Penyimpanan

- **Data Eksternal:** Data ini bersifat _transient_ (tidak disimpan permanen). Data terakhir yang berhasil diambil akan di-cache dalam format sederhana (misalnya, String JSON) di `shared_preferences` untuk fungsionalitas offline.
- **Data Statis:** Disimpan dalam format file `.json` di dalam direktori `assets/data/`.
- **Data Preferensi:** Disimpan menggunakan mekanisme `shared_preferences`.

---

## 2. SKEMA DATA EKSTERNAL (API RESPONSE MODEL)

Ini adalah representasi model data yang akan di-parsing oleh aplikasi dari respons API `aladhan.com`.

###2.1. Entitas: `ApiResponse`

- **Deskripsi:** Objek root dari respons API.
- **Atribut:**
  - `code` (Integer): Status code HTTP. Aplikasi akan memvalidasi nilai ini harus `200`.
  - `status` (String): Status tekstual. Aplikasi akan memvalidasi nilai ini harus `"OK"`.
  - `data` (Object): Objek utama yang berisi semua data yang relevan.

### 2.2. Entitas: `PrayerData` (Objek `data`)

- **Deskripsi:** Berisi informasi waktu dan tanggal.
- **Atribut:**
  - `timings` (Object): Objek yang berisi semua waktu sholat.
  - `date` (Object): Objek yang berisi informasi tanggal.

### 2.3. Entitas: `Timings` (Objek `timings`)

- **Deskripsi:** Kumpulan waktu sholat untuk satu hari.
- **Atribut yang Digunakan:**
  - `Fajr` (String, format "HH:mm"): Waktu Subuh.
  - `Sunrise` (String, format "HH:mm"): Waktu Terbit.
  - `Dhuhr` (String, format "HH:mm"): Waktu Dzuhur.
  - `Asr` (String, format "HH:mm"): Waktu Ashar.
  - `Maghrib` (String, format "HH:mm"): Waktu Maghrib.
  - `Isha` (String, format "HH:mm"): Waktu Isya.

### 2.4. Entitas: `DateInfo` (Objek `date`)

- **Deskripsi:** Berisi informasi kalender Masehi dan Hijriah.
- **Atribut yang Digunakan:**
  - `hijri` (Object): Objek yang berisi detail tanggal Hijriah.

### 2.5. Entitas: `HijriDate` (Objek `hijri`)

- **Deskripsi:** Detail lengkap tanggal Hijriah.
- **Atribut yang Digunakan:**
  - `date` (String, format "DD-MM-YYYY"): Tanggal Hijriah lengkap.
  - `day` (String): Angka hari (misal: "10").
  - `month.en` (String): Nama bulan Hijriah dalam bahasa Inggris (misal: "Rabīʿ al-thānī").
  - `year` (String): Tahun Hijriah (misal: "1445").

---

## 3. SKEMA DATA STATIS (ASET LOKAL)

### 3.1. Entitas: `AsmaulHusna`

- **File:** `assets/data/asmaul_husna.json`
- **Deskripsi:** Menyimpan daftar 99 nama-nama Allah.
- **Struktur:** Sebuah array JSON yang berisi 99 objek.
- **Detail Atribut/Kolom:**
  | Nama Atribut | Tipe Data (JSON) | Tipe Data (Dart) | Deskripsi |
  | :--- | :--- | :--- | :--- |
  | `index` | Number | `int` | Nomor urut dari 1 hingga 99. |
  | `arabic` | String | `String` | Teks nama dalam tulisan Arab. |
  | `latin` | String | `String` | Transliterasi ke dalam huruf Latin. |
  | `translation`| String | `String` | Arti dalam Bahasa Indonesia. |
- **Contoh Objek JSON:**
  ```json
  {
    "index": 1,
    "arabic": "ٱلْرَّحْمَـٰنُ",
    "latin": "Ar-Rahman",
    "translation": "Yang Maha Pengasih"
  }
  ```

### 3.2. Entitas: `Doa`

- **File:** `assets/data/doa_harian.json`
- **Deskripsi:** Menyimpan kumpulan doa-doa harian.
- **Struktur:** Sebuah array JSON yang berisi objek-objek doa.
- **Detail Atribut/Kolom:**
  | Nama Atribut | Tipe Data (JSON) | Tipe Data (Dart) | Deskripsi |
  | :--- | :--- | :--- | :--- |
  | `id` | Number | `int` | ID unik untuk identifikasi internal. |
  | `title` | String | `String` | Judul doa, akan ditampilkan di daftar. |
  | `arabic` | String | `String` | Teks doa lengkap dalam tulisan Arab. |
  | `latin` | String | `String` | Transliterasi untuk membantu pembacaan. |
  | `translation`| String | `String` | Terjemahan doa dalam Bahasa Indonesia. |
  | `category` | String | `String` | Kategori untuk pengelompokan di UI. |
- **Contoh Objek JSON:**
  ```json
  {
    "id": 101,
    "title": "Doa Sebelum Makan",
    "arabic": "اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
    "latin": "Allahumma barik lana fima razaqtana waqina adhaban-nar.",
    "translation": "Ya Allah, berkahilah rezeki yang telah Engkau berikan kepada kami, dan peliharalah kami dari siksa api neraka.",
    "category": "Makan & Minum"
  }
  ```

---

## 4. SKEMA DATA PREFERENSI PENGGUNA (PENYIMPANAN LOKAL)

- **Mekanisme Penyimpanan:** `shared_preferences`
- **Deskripsi:** Menyimpan data konfigurasi dan cache sederhana dalam format key-value.

### 4.1. Detail Keys:

| Key (String)              | Tipe Data | Deskripsi                                                                                                                                            | Nilai Default |
| :------------------------ | :-------- | :--------------------------------------------------------------------------------------------------------------------------------------------------- | :------------ |
| `is_first_launch`         | Boolean   | Penanda `true` jika aplikasi baru pertama kali dibuka, kemudian diubah menjadi `false`. Digunakan untuk menampilkan dialog izin lokasi hanya sekali. | `true`        |
| `saved_latitude`          | Double    | Koordinat Lintang dari lokasi terakhir yang berhasil digunakan (baik otomatis maupun manual).                                                        | `null`        |
| `saved_longitude`         | Double    | Koordinat Bujur dari lokasi terakhir yang berhasil digunakan.                                                                                        | `null`        |
| `saved_location_name`     | String    | Nama kota/daerah dari lokasi terakhir (misal: "Jakarta, Indonesia").                                                                                 | `null`        |
| `last_prayer_times_cache` | String    | String JSON mentah dari respons API `data.timings` terakhir yang berhasil. Digunakan untuk mode offline.                                             | `null`        |
| `last_hijri_date_cache`   | String    | String JSON mentah dari respons API `data.date.hijri` terakhir.                                                                                      | `null`        |
| `cache_timestamp`         | Integer   | Timestamp (epoch milliseconds) kapan cache terakhir disimpan. Digunakan untuk validasi data offline.                                                 | `0`           |

---

## 5. RELASI & INTEGRITAS DATA

- **Relasi:** Tidak ada relasi antar-entitas dalam skema ini. Setiap entitas data bersifat independen.
- **Integritas Data:**
  - Integritas data statis (JSON) dijamin oleh developer saat proses pembuatan aplikasi.
  - Aplikasi **harus** mengimplementasikan blok `try-catch` saat mem-parsing semua data (baik dari API maupun aset) untuk menangani kemungkinan format yang tidak valid atau file yang rusak, dan menampilkan pesan error yang jelas kepada pengguna.
