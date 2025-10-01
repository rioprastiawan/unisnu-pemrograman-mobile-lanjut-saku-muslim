# 🕌 Saku Muslim - Islamic Mobile App

Aplikasi mobile Saku Muslim dibuat menggunakan Nuxt.js dengan design mobile-first yang responsive. Aplikasi ini menyediakan berbagai fitur islami untuk membantu kehidupan spiritual sehari-hari.

## ✨ Fitur Utama

### 🏠 Halaman Utama (Home)

- **Waktu Sholat Berikutnya**: Menampilkan waktu sholat yang akan datang dengan countdown timer
- **Jadwal Sholat Harian**: Daftar lengkap waktu sholat hari ini (Subuh, Dzuhur, Ashar, Maghrib, Isya)
- **Lokasi**: Menampilkan lokasi pengguna (Jakarta, Indonesia)
- **Akses Cepat Kiblat**: Tombol untuk langsung menuju halaman arah kiblat

### 📖 Al-Qur'an

- **Daftar Surah**: Semua 114 surah Al-Qur'an dengan nama Arab dan terjemahan
- **Pencarian**: Fitur pencarian surah berdasarkan nama
- **Informasi Surah**: Jumlah ayat dan tempat turunnya (Makkah/Madinah)

### 🧭 Arah Kiblat

- **Kompas Digital**: Kompas visual untuk menunjukkan arah kiblat
- **Arah Telepon**: Indikator arah telepon saat ini
- **Jarak ke Kabah**: Menampilkan jarak dari lokasi ke Kabah
- **Panduan Penggunaan**: Instruksi cara menggunakan kompas kiblat

### 🤲 Doa Harian

- **Koleksi Doa**: Doa-doa harian dalam bahasa Arab, transliterasi, dan terjemahan
- **Kategori Doa**: Doa pagi, malam, makan, perjalanan, dll.
- **Pencarian Doa**: Fitur pencarian berdasarkan nama atau isi doa
- **Audio (Coming Soon)**: Rencana fitur audio untuk doa
- **Share**: Bagikan doa ke media sosial

### 💰 Kalkulator Zakat

- **Zakat Mal**: Kalkulator untuk zakat harta (uang, emas, perak, investasi)
- **Zakat Fitrah**: Kalkulator zakat fitrah per orang
- **Nisab Calculator**: Otomatis menghitung nisab berdasarkan harga emas terkini
- **Multiple Assets**: Support untuk berbagai jenis harta

### 📅 Kalender Hijriah

- **Tanggal Hijriah**: Menampilkan tanggal Hijriah dan Masehi
- **Event Islami**: Daftar hari-hari penting dalam Islam
- **Navigasi Bulan**: Navigasi mudah antar bulan Hijriah
- **Highlight Hari Ini**: Menandai tanggal hari ini

### ⚙️ Menu Lainnya

- **Grid Menu**: Akses mudah ke semua fitur aplikasi
- **Pengaturan Lokasi**: Ubah lokasi untuk waktu sholat
- **Notifikasi**: Setting notifikasi waktu sholat
- **About**: Informasi tentang aplikasi

## 🚀 Teknologi

- **Framework**: Nuxt.js 4.x
- **Styling**: Tailwind CSS
- **State Management**: Pinia (planned)
- **API**: Aladhan.com untuk waktu sholat
- **Fonts**: Inter (UI), Amiri (Arabic text)
- **PWA Ready**: Dapat diinstall sebagai aplikasi mobile

## 📱 Design

Aplikasi ini menggunakan design mobile-first dengan:

- **Color Scheme**: Gradient hijau yang menenangkan
- **Typography**: Font yang mudah dibaca
- **Navigation**: Bottom navigation yang mudah dijangkau
- **Responsive**: Optimal untuk semua ukuran layar
- **Accessibility**: Design yang accessible

## 🛠 Instalasi & Development

### Prerequisites

- Node.js 18+
- npm atau yarn

### Setup

```bash
# Clone repository
git clone [repository-url]
cd web

# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Environment Variables

Buat file `.env` dengan konfigurasi berikut:

```env
# API Configuration
NUXT_PUBLIC_ALADHAN_API_URL=https://api.aladhan.com/v1

# Location defaults
NUXT_PUBLIC_DEFAULT_LATITUDE=-6.2088
NUXT_PUBLIC_DEFAULT_LONGITUDE=106.8456
NUXT_PUBLIC_DEFAULT_CITY=Jakarta
NUXT_PUBLIC_DEFAULT_COUNTRY=Indonesia
```

## 🗂 Struktur Project

```
web/
├── app/
│   └── app.vue              # Layout utama dengan bottom navigation
├── pages/
│   ├── index.vue            # Halaman utama (waktu sholat)
│   ├── quran/
│   │   └── index.vue        # Daftar surah Al-Qur'an
│   ├── dua.vue              # Doa harian
│   ├── qibla.vue            # Arah kiblat
│   ├── zakat.vue            # Kalkulator zakat
│   ├── calendar.vue         # Kalender Hijriah
│   └── settings.vue         # Menu lainnya & pengaturan
├── stores/
│   └── prayer.ts            # State management untuk waktu sholat
├── assets/
│   └── css/
│       └── main.css         # Custom CSS dengan Tailwind
├── public/                  # Static assets
└── nuxt.config.ts          # Konfigurasi Nuxt
```

## 🔮 Roadmap & Fitur Mendatang

### Phase 1 (Current)

- ✅ Halaman utama dengan waktu sholat
- ✅ Daftar surah Al-Qur'an
- ✅ Arah kiblat dengan kompas
- ✅ Doa harian
- ✅ Kalkulator zakat
- ✅ Kalender Hijriah

### Phase 2 (Next)

- 🔄 Integrasi API real-time untuk waktu sholat
- 🔄 Geolocation untuk deteksi lokasi otomatis
- 🔄 Audio untuk doa-doa
- 🔄 Detail surah dengan ayat lengkap
- 🔄 Kalkulator warisan Islam
- 🔄 Notifikasi push untuk waktu sholat

### Phase 3 (Future)

- 📋 Offline support dengan cache
- 📋 Tema gelap/terang
- 📋 Multiple bahasa (Indonesia, English, Arabic)
- 📋 Bookmark surah & doa favorit
- 📋 History bacaan Al-Qur'an
- 📋 Dzikir counter
- 📋 Asmaul Husna

## 🎯 API Integration

### Aladhan API

Aplikasi ini menggunakan [Aladhan.com API](https://aladhan.com/prayer-times-api) untuk:

- Waktu sholat berdasarkan lokasi
- Arah kiblat
- Tanggal Hijriah
- Data masjid terdekat (planned)

### Example API Calls

```javascript
// Waktu sholat
GET https://api.aladhan.com/v1/timings/[date]?latitude=[lat]&longitude=[lng]&method=2

// Arah kiblat
GET https://api.aladhan.com/v1/qibla/[lat]/[lng]

// Kalender Hijriah
GET https://api.aladhan.com/v1/gToH/[dd-mm-yyyy]
```

## 🤝 Contributing

Kontribusi sangat diterima! Silakan:

1. Fork repository
2. Buat branch fitur baru
3. Commit perubahan
4. Push ke branch
5. Buat Pull Request

## 📄 License

Project ini dibuat untuk tugas kuliah Pemrograman Mobile Lanjut.

## 👨‍💻 Developer

Dibuat dengan ❤️ untuk memudahkan ibadah umat Muslim.

---

**Catatan**: Aplikasi ini masih dalam tahap development. Beberapa fitur mungkin belum sepenuhnya fungsional dan masih menggunakan data mock untuk demo.
