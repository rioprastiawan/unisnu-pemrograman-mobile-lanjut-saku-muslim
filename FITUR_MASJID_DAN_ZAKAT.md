# Fitur Premium: Masjid Terdekat & Kalkulator Zakat

## 📍 Masjid Terdekat

Fitur untuk menemukan masjid-masjid terdekat dari lokasi pengguna saat ini.

### Fitur Utama
- ✅ Deteksi lokasi otomatis menggunakan GPS
- ✅ Menampilkan daftar masjid terdekat dengan jarak
- ✅ Informasi lengkap: nama, alamat, rating, status jamaah
- ✅ Navigasi langsung ke Google Maps
- ✅ Refresh untuk update data terbaru
- ✅ Premium lock untuk pengguna non-premium

### Cara Kerja
1. **Premium Check**: Saat halaman dibuka, sistem mengecek status premium user
2. **Location Access**: Jika premium, sistem meminta izin akses lokasi
3. **Data Loading**: Mengambil data masjid terdekat (saat ini masih dummy data)
4. **Display**: Menampilkan list masjid dengan card UI yang informatif
5. **Navigation**: Tap pada card untuk buka navigasi Google Maps

### Data Masjid yang Ditampilkan
- Nama masjid
- Alamat lengkap
- Jarak dari lokasi user (km)
- Rating (bintang)
- Status jamaah (badge hijau)
- Koordinat (lat, lng)

### UI Components
```dart
// Premium Lock untuk non-premium users
PremiumLockWidget(
  featureName: 'Masjid Terdekat',
  description: 'Temukan masjid di sekitar lokasi Anda...',
)

// Mosque Card dengan info lengkap
_buildMosqueCard(Map<String, dynamic> mosque)
```

### Dependencies yang Digunakan
- `geolocator`: Mendapatkan lokasi user
- `url_launcher`: Membuka Google Maps
- `location_service`: Service untuk akses GPS

### TODO: Implementasi API Real
Saat ini menggunakan dummy data. Untuk produksi, perlu:
1. Integrasi dengan Google Places API / Overpass API
2. Database masjid lokal (optional)
3. Caching untuk performa lebih baik
4. Filter berdasarkan radius

---

## 🧮 Kalkulator Zakat

Fitur kalkulator untuk menghitung zakat fitrah dan zakat mal (harta).

### Fitur Utama

#### Tab 1: Zakat Fitrah
- ✅ Input harga beras per kg
- ✅ Pilih jumlah jiwa (+ / -)
- ✅ Otomatis hitung total: `harga_beras × 2.5 kg × jumlah_jiwa`
- ✅ Dialog hasil perhitungan dengan breakdown

#### Tab 2: Zakat Mal
- ✅ Input total harta (tabungan, investasi, dll)
- ✅ Input hutang/cicilan yang harus dibayar
- ✅ Hitung harta bersih: `total_harta - hutang`
- ✅ Cek nishab: `85 gram emas × harga_emas`
- ✅ Status wajib zakat atau belum
- ✅ Hitung zakat: `harta_bersih × 2.5%` (jika wajib)
- ✅ Dialog hasil dengan status lengkap

### Konstanta Perhitungan
```dart
nishabEmas = 85 gram
hargaEmasPerGram = Rp 1.000.000 (estimasi)
tarifZakat = 2.5%
berasPerOrang = 2.5 kg
```

### Cara Kerja

#### Zakat Fitrah
1. User input harga beras per kg
2. User pilih jumlah jiwa
3. Tap "Hitung Zakat Fitrah"
4. Rumus: `harga_beras × 2.5 kg × jumlah_jiwa`
5. Tampilkan hasil di dialog

#### Zakat Mal
1. User input total harta
2. User input hutang (optional)
3. Sistem hitung harta bersih
4. Bandingkan dengan nishab
5. Jika ≥ nishab → Wajib zakat (2.5%)
6. Jika < nishab → Belum wajib
7. Tampilkan hasil di dialog

### UI Components
- **TabBar**: 2 tabs untuk Fitrah dan Mal
- **Info Cards**: Penjelasan tentang zakat
- **Text Fields**: Input numerik dengan format Rupiah
- **Counter Widget**: +/- untuk jumlah jiwa
- **Result Dialog**: Menampilkan breakdown perhitungan
- **Number Formatter**: Format angka dengan separator ribuan

### Premium Lock
Sama seperti Masjid Terdekat, non-premium users akan melihat `PremiumLockWidget`:
```dart
PremiumLockWidget(
  featureName: 'Kalkulator Zakat',
  description: 'Hitung zakat fitrah dan zakat mal...',
)
```

### Format Output
```
Hasil Zakat Fitrah:
- Jumlah jiwa: 4 orang
- Beras per orang: 2.5 kg
- Harga beras: Rp 15.000/kg

Total Zakat Fitrah:
Rp 150.000
```

```
Hasil Zakat Mal:
- Total Harta: Rp 100.000.000
- Hutang/Cicilan: Rp 10.000.000
- Harta Bersih: Rp 90.000.000

Nishab (85 gram emas):
Rp 85.000.000

Status: WAJIB ZAKAT ✅

Total Zakat Mal (2.5%):
Rp 2.250.000
```

---

## 📝 Integrasi dengan Menu

Kedua fitur sudah terintegrasi di `MenuPage`:

```dart
// Masjid Terdekat Menu
_buildMenuCard(
  icon: Icons.mosque,
  title: 'Masjid Terdekat',
  isPremium: !_isPremium,  // Show badge if not premium
  onTap: () => Navigator.push(...MasjidTerdekatPage()),
)

// Kalkulator Zakat Menu
_buildMenuCard(
  icon: Icons.calculate,
  title: 'Kalkulator Zakat',
  isPremium: !_isPremium,  // Show badge if not premium
  onTap: () => Navigator.push(...KalkulatorZakatPage()),
)
```

### Premium Badge
Jika user belum premium, akan muncul badge "PREMIUM" di pojok kanan atas card menu.

---

## 🔒 Premium Service Integration

Kedua halaman menggunakan `PremiumService` untuk:

```dart
// Check premium status
_isPremium = await _premiumService.isPremium();

// Check specific feature access
final canAccess = await _premiumService.hasFeature(
  PremiumFeature.masjidTerdekat,
);
```

Enum di `premium_service.dart`:
```dart
enum PremiumFeature {
  offlineAudio,
  unlimitedBookmarks,
  darkMode,
  customThemes,
  masjidTerdekat,      // ← Fitur baru
  kalkulatorZakat,     // ← Fitur baru
  exportData,
  widgets,
}
```

---

## 🧪 Testing

### Test Scenario 1: Non-Premium User
1. Buka Menu → Masjid Terdekat
2. Harus muncul `PremiumLockWidget`
3. Tap "Unlock Premium" → Redirect ke `PremiumPage`

### Test Scenario 2: Premium User - Masjid
1. Buka Menu → Masjid Terdekat
2. Izinkan akses lokasi
3. Harus muncul list masjid (dummy data)
4. Tap card → Buka Google Maps

### Test Scenario 3: Premium User - Zakat Fitrah
1. Buka Menu → Kalkulator Zakat
2. Tab "Zakat Fitrah"
3. Input harga beras: 15000
4. Jumlah jiwa: 4
5. Tap "Hitung Zakat Fitrah"
6. Hasil: Rp 150.000

### Test Scenario 4: Premium User - Zakat Mal
1. Tab "Zakat Mal"
2. Input harta: 100000000
3. Input hutang: 10000000
4. Tap "Hitung Zakat Mal"
5. Hasil: Wajib zakat, Rp 2.250.000

---

## 🚀 Next Steps

### Masjid Terdekat
1. **API Integration**
   - Google Places API untuk data masjid real
   - Atau Overpass API (OpenStreetMap) - gratis
   
2. **Fitur Tambahan**
   - Filter berdasarkan radius
   - Search by name
   - Favorit masjid
   - Review & rating dari user
   - Waktu sholat per masjid
   
3. **Performance**
   - Caching data masjid
   - Background location update
   - Lazy loading untuk list panjang

### Kalkulator Zakat
1. **Harga Emas Real-time**
   - Integrasi API harga emas terkini
   - Update otomatis setiap hari
   
2. **Fitur Tambahan**
   - Zakat profesi
   - Zakat perdagangan
   - Zakat pertanian
   - History perhitungan
   - Export hasil ke PDF
   
3. **UX Enhancement**
   - Save draft perhitungan
   - Multiple profiles (keluarga)
   - Reminder untuk bayar zakat

---

## 📄 Files Created

1. `lib/pages/masjid_terdekat_page.dart` - Halaman Masjid Terdekat
2. `lib/pages/kalkulator_zakat_page.dart` - Halaman Kalkulator Zakat
3. Updated `lib/pages/menu_page.dart` - Added navigation to new pages
4. Updated `lib/services/premium_service.dart` - Added new premium features enum

---

## ✅ Checklist Implementasi

- [x] Buat halaman Masjid Terdekat
- [x] Buat halaman Kalkulator Zakat
- [x] Integrasi dengan Menu
- [x] Premium lock untuk non-premium users
- [x] UI/UX sesuai design system
- [x] Format kode dengan dart format
- [ ] Testing dengan real device
- [ ] Integrasi API masjid real
- [ ] Integrasi API harga emas real
- [ ] User acceptance testing
