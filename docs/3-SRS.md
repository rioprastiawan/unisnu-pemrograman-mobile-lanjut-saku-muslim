# Software Requirements Specification (SRS): Saku Muslim

- **Versi:** 1.0 (MVP)
- **Tanggal:** 18 September 2025
- **Author**
  - Bimo Rio Prastiawan (221240001220)
  - Rizky Alhusani Ghifari (221240001300)
- **Status:** Draft

---

## 1. Pendahuluan

### 1.1. Tujuan Dokumen

Dokumen ini menyediakan spesifikasi persyaratan perangkat lunak yang detail untuk pengembangan aplikasi Saku Muslim versi MVP (Minimum Viable Product). Tujuannya adalah untuk memberikan panduan yang jelas kepada developer mengenai fungsionalitas, kapabilitas, dan batasan sistem yang akan dibangun.

### 1.2. Lingkup Produk

Saku Muslim adalah aplikasi mobile (Android & iOS) yang dikembangkan menggunakan Flutter. Lingkup MVP mencakup fitur esensial untuk ibadah harian: jadwal sholat, arah kiblat, kalender Islam, daftar Asmaul Husna, dan kumpulan doa harian. Aplikasi ini dirancang untuk menjadi ringan, cepat, dan memiliki antarmuka yang minimalis.

### 1.3. Definisi & Akronim

- **API:** Application Programming Interface. Antarmuka yang menghubungkan aplikasi dengan layanan eksternal.
- **GPS:** Global Positioning System. Sistem untuk menentukan lokasi geografis.
- **JSON:** JavaScript Object Notation. Format pertukaran data yang ringan.
- **MVP:** Minimum Viable Product. Versi produk dengan fitur paling minimal yang sudah dapat memberikan nilai kepada pengguna.
- **UI/UX:** User Interface / User Experience.

---

## 2. Deskripsi Umum

### 2.1. Perspektif Produk

Aplikasi ini adalah produk mandiri (standalone) yang akan tersedia di Google Play Store dan Apple App Store. Aplikasi ini berinteraksi dengan satu layanan eksternal, yaitu API Al-Adhan untuk data waktu sholat, dan bergantung pada sensor perangkat keras (GPS, magnetometer) untuk fungsionalitas lokasi dan kiblat.

### 2.2. Fungsi Utama Produk (MVP)

1.  Menampilkan jadwal sholat berdasarkan lokasi.
2.  Menyediakan kompas penunjuk arah Kiblat.
3.  Menampilkan kalender Masehi dan Hijriah.
4.  Menyediakan daftar Asmaul Husna dan artinya.
5.  Menyediakan kumpulan doa-doa harian.

### 2.3. Karakteristik Pengguna

Pengguna adalah umat Muslim yang membutuhkan alat bantu ibadah yang praktis dan tidak membebani perangkat. Mereka menghargai kecepatan, kesederhanaan, dan akurasi data.

---

## 3. Persyaratan Spesifik

### 3.1. Persyaratan Antarmuka Eksternal

#### 3.1.1. Al-Adhan API

Sistem akan menggunakan API dari `aladhan.com` untuk mendapatkan data jadwal sholat dan tanggal Hijriah.

- **Endpoint:** `GET http://api.aladhan.com/v1/timings`
- **Parameter Request:**
  - `latitude` (wajib): Koordinat Lintang pengguna. Contoh: `-6.200000`.
  - `longitude` (wajib): Koordinat Bujur pengguna. Contoh: `106.816666`.
  - `method` (opsional): Metode kalkulasi. Akan digunakan nilai `11` untuk metode Kemenag RI (default untuk Indonesia).
- **Contoh Request URL:**
  ```
  http://api.aladhan.com/v1/timings/YYYY-MM-DD?latitude=-6.20&longitude=106.81&method=11
  ```
- **Contoh Response Sukses (JSON - Snippet):**
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
        "gregorian": { ... },
        "hijri": {
          "date": "10-04-1445",
          "day": "10",
          "weekday": { "en": "Al-Jumu'ah", "ar": "الجمعة" },
          "month": { "number": 4, "en": "Rabīʿ al-thānī", "ar": "ربيع الثاني" },
          "year": "1445"
        }
      }
    }
  }
  ```
- **Penanganan Error:**
  - Jika response code bukan `200` atau terjadi error jaringan, aplikasi harus menampilkan pesan error yang informatif kepada pengguna (misal: "Gagal memuat data, periksa koneksi internet Anda").
  - Aplikasi harus menampilkan data terakhir yang berhasil dimuat jika tersedia.

### 3.2. Persyaratan Fungsional

#### FR-01: Fitur Jadwal Sholat

- **FR-1.1:** Saat pertama kali dibuka, sistem **harus** meminta izin akses lokasi (`ACCESS_FINE_LOCATION`).
- **FR-1.2:** Jika izin diberikan, sistem **harus** secara otomatis mendapatkan koordinat GPS pengguna.
- **FR-1.3:** Sistem **harus** melakukan panggilan API ke endpoint `v1/timings` Al-Adhan menggunakan koordinat yang didapat.
- **FR-1.4:** Sistem **harus** mem-parsing response JSON dan menampilkan 6 waktu utama (Imsak, Subuh, Dzuhur, Ashar, Maghrib, Isya) di halaman utama. Waktu terbit juga bisa ditampilkan sebagai informasi tambahan.
- **FR-1.5:** Sistem **harus** menyediakan input teks untuk pencarian lokasi manual. Ketika lokasi manual dipilih, panggilan API akan menggunakan koordinat dari lokasi tersebut.
- **FR-1.6:** Sistem **harus** secara visual menandai waktu sholat yang akan datang.

#### FR-02: Fitur Arah Kiblat

- **FR-2.1:** Sistem **harus** mengakses sensor perangkat (magnetometer dan akselerometer) untuk fungsionalitas kompas.
- **FR-2.2:** Sistem **harus** menggunakan koordinat GPS pengguna saat ini dan koordinat Ka'bah (21.4225° N, 39.8262° E) untuk menghitung sudut arah Kiblat.
- **FR-2.3:** Sistem **harus** menampilkan antarmuka kompas visual dengan panah yang secara dinamis menunjuk ke arah Kiblat.
- **FR-2.4:** Sistem **harus** menampilkan nilai derajat arah Kiblat.

#### FR-03: Fitur Asmaul Husna

- **FR-3.1:** Sistem **harus** memuat daftar Asmaul Husna dari file JSON lokal (`assets/data/asmaul_husna.json`).
- **FR-3.2:** Sistem **harus** menampilkan daftar tersebut dalam format _scrollable list_.
- **FR-3.3:** Setiap item dalam daftar **harus** menampilkan nomor, tulisan Arab, transliterasi Latin, dan terjemahan Bahasa Indonesia.

#### FR-04: Fitur Doa Harian

- **FR-4.1:** Sistem **harus** memuat daftar doa-doa harian dari file JSON lokal (`assets/data/doa_harian.json`).
- **FR-4.2:** Sistem **harus** menampilkan daftar doa yang dikelompokkan berdasarkan kategori.
- **FR-4.3:** Saat sebuah doa dipilih, sistem **harus** menampilkan halaman detail yang berisi tulisan Arab, transliterasi Latin, dan terjemahan Bahasa Indonesia.

#### FR-05: Fitur Kalender Islam

- **FR-5.1:** Sistem **harus** mengambil data tanggal Hijriah dari response API Al-Adhan dan menampilkannya di halaman utama.
- **FR-5.2:** Sistem **harus** menyediakan halaman kalender yang menampilkan satu bulan penuh, dengan setiap tanggal menampilkan angka Masehi dan Hijriah secara bersamaan.

### 3.3. Persyaratan Non-Fungsional

#### NFR-01: Kinerja (Performance)

- **NFR-1.1:** Waktu startup aplikasi dari kondisi dingin (_cold start_) **harus** kurang dari 2 detik pada perangkat kelas menengah.
- **NFR-1.2:** Transisi antar halaman **harus** terasa instan (< 300ms) dan animasi harus berjalan mulus (60 FPS).
- **NFR-1.3:** Panggilan API **harus** memiliki _timeout_ 15 detik untuk mencegah aplikasi _freeze_.

#### NFR-02: Usability

- **NFR-2.1:** Informasi jadwal sholat berikutnya **harus** menjadi informasi yang paling menonjol di halaman utama.
- **NFR-2.2:** Semua fungsionalitas utama **harus** dapat diakses tidak lebih dari 2 kali tap dari halaman utama.

#### NFR-03: Keandalan (Reliability)

- **NFR-3.1:** Jika aplikasi dibuka tanpa koneksi internet, aplikasi **harus** menampilkan jadwal sholat terakhir yang berhasil disimpan di perangkat.
- **NFR-3.2:** Fitur yang tidak memerlukan internet (Asmaul Husna, Doa Harian) **harus** berfungsi sepenuhnya secara offline.

#### NFR-04: Portabilitas (Portability)

- **NFR-4.1:** Aplikasi **harus** kompatibel dengan sistem operasi Android versi 6.0 (Marshmallow, API level 23) ke atas.
- **NFR-4.2:** Aplikasi **harus** kompatibel dengan sistem operasi iOS versi 12.0 ke atas.
