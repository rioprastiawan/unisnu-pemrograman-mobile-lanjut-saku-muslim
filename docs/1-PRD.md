# Product Requirements Document (PRD): Saku Muslim

- **Versi:** 1.0 (MVP)
- **Tanggal:** 18 September 2025
- **Author**
  - Bimo Rio Prastiawan (221240001220)
  - Rizky Alhusani Ghifari (221240001300)
- **Status:** Draft

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

- **Bagi Pengguna:** Memberikan akses cepat dan akurat ke informasi ibadah esensial (waktu sholat, arah kiblat).
- **Bagi Developer:** Membangun sebuah aplikasi portofolio yang solid, fungsional, dan menunjukkan pemahaman tentang pengembangan aplikasi mobile yang berfokus pada pengguna (user-centric).

### 3.2. Metrik Kesuksesan Proyek

- **Fungsionalitas:** Semua fitur dalam lingkup MVP berhasil diimplementasikan dan berfungsi tanpa _bug_ mayor.
- **Performa:** Aplikasi terasa responsif dan ringan saat digunakan pada perangkat fisik.
- **Kualitas Kode:** Kode ditulis dengan rapi, terstruktur, dan mudah dipahami, mengikuti praktik terbaik Flutter.
- **Kepuasan:** Mendapatkan feedback positif dari dosen dan rekan-rekan mengenai kegunaan dan desain aplikasi.

---

## 4. Fitur & Ruang Lingkup (Scope)

### 4.1. Rilis MVP (Minimum Viable Product)

Fokus pada fungsionalitas inti agar aplikasi dapat memberikan nilai esensial sejak awal.

| ID       | Fitur              | Deskripsi                                                                                                                                       | Prioritas |
| :------- | :----------------- | :---------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| **F1.1** | **Jadwal Sholat**  | Menampilkan jadwal sholat harian (Imsak, Subuh, Dzuhur, Ashar, Maghrib, Isya) berdasarkan lokasi pengguna yang terdeteksi otomatis atau manual. | **Wajib** |
| **F2.1** | **Arah Kiblat**    | Kompas interaktif yang menunjukkan arah Kiblat secara akurat dari lokasi pengguna, lengkap dengan informasi derajat.                            | **Wajib** |
| **F3.1** | **Kalender Islam** | Menampilkan tanggal Masehi dan Hijriah secara bersamaan. Terdapat halaman kalender bulanan penuh.                                               | **Wajib** |
| **F4.1** | **Asmaul Husna**   | Daftar 99 Asmaul Husna yang dapat digulir, lengkap dengan tulisan Arab, transliterasi, dan terjemahan. Data disimpan lokal.                     | **Wajib** |
| **F5.1** | **Doa Harian**     | Kumpulan doa-doa harian esensial (sebelum makan, tidur, dll) yang disajikan dalam format daftar yang mudah diakses. Data disimpan lokal.        | **Wajib** |

### 4.2. Rilis Selanjutnya (Post-MVP)

Fitur-fitur ini akan dipertimbangkan untuk dikembangkan setelah MVP berhasil diselesaikan.

| ID        | Fitur                      | Deskripsi                                                                  | Prioritas  |
| :-------- | :------------------------- | :------------------------------------------------------------------------- | :--------- |
| **F6.1**  | **Notifikasi Adzan**       | Pengingat waktu sholat menggunakan notifikasi lokal di perangkat pengguna. | **Tinggi** |
| **F7.1**  | **Tasbih Digital**         | Alat hitung digital sederhana untuk membantu pengguna berdzikir.           | **Tinggi** |
| **F8.1**  | **Masjid Terdekat**        | Integrasi dengan peta untuk menampilkan lokasi masjid-masjid terdekat.     | **Medium** |
| **F9.1**  | **Artikel Islami Ringkas** | Konten singkat seperti hadits pilihan atau kutipan inspiratif.             | **Medium** |
| **F10.1** | **Pengaturan Lanjutan**    | Opsi untuk mengubah metode kalkulasi jadwal sholat.                        | **Rendah** |

### 4.3. Tidak Termasuk dalam Ruang Lingkup (Out of Scope)

Fitur-fitur berikut secara eksplisit **TIDAK** akan dibuat untuk menjaga kesederhanaan aplikasi:

- Fitur media sosial atau komunitas.
- Konten video atau streaming kajian.
- Fitur pembayaran Zakat, Infaq, Sedekah.
- Portal berita Islami.

---

## 5. Alur Pengguna (User Flow)

### 5.1. Alur Utama: Mengecek Jadwal Sholat

1.  Pengguna membuka aplikasi untuk pertama kali.
2.  Aplikasi menampilkan dialog permintaan izin akses lokasi. Pengguna menyetujui.
3.  Aplikasi mendarat di **Halaman Utama (Dashboard)**.
4.  Jadwal sholat untuk hari itu langsung ditampilkan berdasarkan lokasi yang terdeteksi. Waktu sholat berikutnya ditandai secara visual.

### 5.2. Alur Sekunder: Mencari Arah Kiblat

1.  Dari **Halaman Utama**, pengguna menekan ikon navigasi **"Kiblat"**.
2.  Aplikasi membuka **Halaman Kompas Kiblat**.
3.  Pengguna melihat panah yang menunjuk ke arah Kiblat dan mengikuti instruksi kalibrasi jika diperlukan.
4.  Setelah selesai, pengguna kembali ke Halaman Utama.

---

## 6. Persyaratan Non-Fungsional

- **Kinerja:**
  - Waktu buka aplikasi (cold start) harus di bawah 2 detik.
  - Navigasi antar halaman harus terasa instan dan mulus (60 FPS).
  - Penggunaan baterai dan data harus efisien.
- **Usability:**
  - Antarmuka harus bersih, modern, dan intuitif.
  - Informasi paling penting (jadwal sholat berikutnya) harus langsung terlihat saat aplikasi dibuka.
- **Keandalan:**
  - Aplikasi harus dapat menangani kondisi tanpa koneksi internet dengan baik (misalnya, menampilkan data terakhir yang berhasil dimuat atau memuat data lokal).
- **Teknologi:**
  - Aplikasi dibangun menggunakan **Flutter**.
  - Data jadwal sholat diambil dari API **aladhan.com**.
  - Menggunakan plugin seperti `geolocator` untuk lokasi, `flutter_qiblah` untuk kompas, dan `http`/`dio` untuk koneksi API.
