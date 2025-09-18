# Checklist Timeline Sprint MVP: Saku Muslim

- **Versi:** 1.0 (MVP)
- **Tanggal:** 18 September 2025
- **Author**
  - Bimo Rio Prastiawan (221240001220)
  - Rizky Alhusani Ghifari (221240001300)
- **Status:** Draft

---

## Tujuan MVP

Pengguna dapat melihat jadwal sholat akurat berdasarkan lokasi, menentukan arah kiblat, melihat kalender Hijriah, serta mengakses daftar Asmaul Husna dan Doa Harian dalam sebuah aplikasi yang ringan, stabil, dan mudah digunakan.

---

## Sprint 1: Fondasi, Akses Data, & Fitur Inti (Durasi: 2 Minggu)

**Tujuan Sprint:** Membangun fondasi arsitektur, semua layanan akses data (API, lokal, lokasi), dan mengimplementasikan fitur paling inti yaitu Jadwal Sholat. Di akhir sprint, aplikasi harus bisa menampilkan jadwal sholat yang akurat berdasarkan lokasi pengguna secara fungsional.

| Hari | Task ID | Tugas | Keterangan & Dependencies | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Hari 1-2** | **S1-T01** | **Setup Proyek & Konfigurasi Awal** | Buat proyek Flutter baru, install dependensi (`provider`, `http`, `geolocator`, `flutter_qiblah`, `google_fonts`), setup struktur folder sesuai SDD, dan konfigurasi `assets` (JSON, gambar). | ☐ |
| | **S1-T02** | **Pembuatan Model Data** | Buat file model untuk `PrayerTime`, `HijriDate`, `AsmaulHusna`, dan `Doa`. Implementasikan `factory .fromJson()` pada setiap model untuk parsing data. | Tergantung S1-T01 | ☐ |
| **Hari 3-5** | **S1-T03** | **Implementasi Lapisan Layanan (Services)** | Buat kelas `ApiService` (untuk API Al-Adhan), `LocationService` (untuk GPS), dan `AssetService` (untuk JSON lokal). Lengkapi dengan metode dan penanganan error dasar. | Tergantung S1-T02 | ☐ |
| **Hari 6-8** | **S1-T04** | **Implementasi Fitur Jadwal Sholat (ViewModel & UI)** | Buat `HomeViewModel` yang menggunakan `LocationService` & `ApiService`. Buat UI `HomeScreen` dasar untuk menampilkan data jadwal sholat. | Tergantung S1-T03 | ☐ |
| | **S1-T05** | **UI: Komponen Jadwal Sholat** | Buat widget kustom `PrayerTimeCard` dan `PrayerTimeList`. Implementasikan logika untuk menyorot (highlight) waktu sholat berikutnya secara visual. | Tergantung S1-T04 | ☐ |
| | **S1-T06** | **State Management (Provider) untuk Jadwal Sholat** | Hubungkan `HomeScreen` ke `HomeViewModel` menggunakan `Provider`/`Consumer`. Pastikan UI bereaksi dengan benar terhadap state `loading`, `error`, dan `success`. | Tergantung S1-T04 | ☐ |
| **Hari 9** | **S1-T07** | **Implementasi Kalender Hijriah di UI** | Ambil data tanggal Hijriah yang sudah di-parsing dari respons API dan tampilkan di `HomeScreen` bersamaan dengan tanggal Masehi. | Tergantung S1-T04 | ☐ |
| **Hari 10** | **S1-T08** | **Sprint Review, Testing Inti & Refactoring** | Lakukan pengujian manual untuk alur utama (buka aplikasi -> dialog izin -> tampil jadwal sholat). Perbaiki bug minor dan refactor kode layanan jika diperlukan. | Semua task | ☐ |

---

## Sprint 2: Fitur Pendukung, Navigasi, & Penyempurnaan (Durasi: 2 Minggu)

**Tujuan Sprint:** Mengimplementasikan sisa fitur MVP (Kiblat, Asmaul Husna, Doa), menyatukan semua fitur dengan navigasi yang solid, dan menyempurnakan UI/UX agar aplikasi terasa lengkap dan siap untuk rilis.

| Hari | Task ID | Tugas | Keterangan & Dependencies | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Hari 1-3** | **S2-T01** | **Implementasi Fitur Asmaul Husna & Doa Harian** | Buat ViewModel & UI untuk kedua fitur. Logikanya mirip: panggil `AssetService`, dapatkan list data dari JSON, tampilkan di `ListView.builder`. | Tergantung S1-T03 | ☐ |
| | **S2-T02** | **UI: Halaman Detail Doa Harian** | Buat halaman detail untuk menampilkan isi lengkap doa (Arab, Latin, Terjemahan) saat sebuah item dari daftar disentuh. | Tergantung S2-T01 | ☐ |
| **Hari 4-5** | **S2-T03** | **Implementasi Fitur Arah Kiblat** | Buat UI `QiblaScreen` dan integrasikan `flutter_qiblah`. Pastikan kompas berfungsi secara real-time dengan menggunakan data dari `LocationService`. | Tergantung S1-T03 | ☐ |
| **Hari 6-7** | **S2-T04** | **Implementasi Navigasi Utama (BottomNavBar)** | Buat `BottomNavigationBar` di `HomeScreen` untuk berpindah antar fitur: Jadwal Sholat, Kiblat, Asmaul Husna, Doa Harian. Kelola state navigasi agar halaman tidak di-reload. | Tergantung task UI dari Sprint 1 & 2 | ☐ |
| | **S2-T05** | **Penyempurnaan UI Dashboard (Countdown)** | Tambahkan widget `countdown timer` menuju waktu sholat berikutnya di `HomeScreen` untuk memberikan pengalaman pengguna yang lebih informatif dan dinamis. | Tergambut S1-T04 | ☐ |
| **Hari 8** | **S2-T06** | **Penyempurnaan UI/UX Global & Tema** | Terapkan `ThemeData` (warna, font) secara konsisten di seluruh aplikasi. Perbaiki padding, margin, dan alignment untuk tampilan yang rapi dan profesional. | Semua task UI | ☐ |
| | **S2-T07** | **Implementasi Penanganan Error di UI** | Tampilkan pesan error yang ramah pengguna (misal: `SnackBar` atau widget khusus) di `HomeScreen` saat API gagal. Implementasikan tombol "Coba Lagi". | Tergambut S1-T06 | ☐ |
| **Hari 9** | **S2-T08** | **Pengujian Fungsional End-to-End** | Lakukan pengujian menyeluruh untuk semua alur MVP pada emulator dan perangkat fisik. Cek kasus-kasus khusus (offline mode, izin ditolak, dll). | Semua task | ☐ |
| | **S2-T09** | **Persiapan Build & Rilis** | Siapkan ikon aplikasi, *splash screen*, dan update file `README.md` di repositori GitHub dengan deskripsi final, screenshot, dan cara menjalankan proyek. | - | ☐ |
| **Hari 10** | **S2-T10** | **Sprint Review, Retrospective & Demo Final** | Lakukan demo fungsionalitas MVP lengkap yang sudah selesai. Kumpulkan feedback dan anggap proyek MVP selesai sesuai rencana. | Semua task | ☐ |

---

### Catatan Tambahan:

*   **Fleksibilitas:** Timeline ini adalah sebuah panduan. Prioritaskan untuk menyelesaikan setiap tugas dengan kualitas yang baik daripada mengikuti jadwal secara kaku.
*   **Testing:** Pengujian manual adalah fokus utama. Jika ada waktu lebih, membuat *unit test* untuk `ApiService` dan `AssetService` akan sangat meningkatkan keandalan kode.
*   **Backlog:** Fitur-fitur lain dari PRD (Notifikasi Adzan, Tasbih Digital, dll.) akan masuk ke dalam *product backlog* dan dapat dijadwalkan untuk pengembangan di masa depan setelah MVP ini selesai.
