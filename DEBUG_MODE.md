# 🧪 DEBUG MODE - Testing Premium Tanpa IAP

## ⚙️ Cara Mengaktifkan

Sudah **AKTIF** secara default! Cukup jalankan app:

```bash
cd app
flutter run
```

Semua fitur premium akan otomatis terbuka tanpa perlu pembelian.

---

## 🎯 Yang Bisa Ditest

Dengan debug mode aktif, Anda bisa test:

✅ **Masjid Terdekat** - Tanpa perlu beli premium  
✅ **Kalkulator Zakat** - Langsung akses  
✅ **Audio Offline** - Download & play  
✅ **Semua Fitur Premium** - Tidak ada lock screen  

---

## 🔧 Konfigurasi

File: `lib/services/premium_service.dart`

```dart
/// 🧪 DEBUG MODE: Set true untuk testing premium features tanpa IAP
/// Set false untuk production!
static const bool debugPremiumMode = true;  // ← Ubah di sini
```

### Untuk Testing Local (Development):
```dart
static const bool debugPremiumMode = true;  // ✅ AKTIF
```

### Untuk Production (Release):
```dart
static const bool debugPremiumMode = false; // ❌ MATIKAN
```

---

## 🎨 Debug Banner

Saat debug mode aktif, akan muncul banner oranye di halaman Premium:

```
🧪 DEBUG MODE: Premium aktif otomatis untuk testing
```

Banner ini **hanya muncul di debug mode** dan akan hilang otomatis di production.

---

## ⚠️ PENTING: Sebelum Release

**WAJIB matikan debug mode sebelum build production!**

### Checklist Pre-Release:
```dart
// ❌ BAHAYA - Jangan release dengan ini:
static const bool debugPremiumMode = true;

// ✅ CORRECT - Production setting:
static const bool debugPremiumMode = false;
```

### Build Production:
```bash
# 1. Matikan debug mode di premium_service.dart
# 2. Build release
flutter build appbundle --release

# 3. Upload ke Play Console
```

---

## 🧪 Testing Flow

### 1. Test Fitur Premium (Debug Mode ON)
```bash
flutter run
# Semua fitur premium langsung terbuka
# Test Masjid Terdekat
# Test Kalkulator Zakat
# Test Audio Offline
```

### 2. Test IAP Flow (Debug Mode OFF + Play Console)
```bash
# Matikan debug mode
# Upload ke Internal Testing
# Install dari Play Store
# Test actual purchase flow
```

---

## 📱 Screenshot Testing

Dengan debug mode, Anda bisa ambil screenshot fitur premium untuk:
- Play Store listing
- Marketing materials
- Documentation
- Presentasi

Tanpa perlu setup IAP dulu!

---

## 🐛 Troubleshooting

### Fitur Premium Masih Terkunci?
```dart
// Cek di premium_service.dart:
static const bool debugPremiumMode = true;  // Harus true

// Hot reload:
// Press 'r' di terminal
// Atau restart app
```

### Banner Debug Tidak Muncul?
```dart
// Cek di premium_page.dart:
if (PremiumService.debugPremiumMode)  // Harus ada kondisi ini
```

### Error Saat Build Release?
Pastikan debug mode sudah dimatikan:
```dart
static const bool debugPremiumMode = false;
```

---

## ✅ Status Saat Ini

- ✅ Debug mode: **AKTIF**
- ✅ Premium features: **Terbuka untuk testing**
- ✅ Banner debug: **Muncul di Premium Page**
- ✅ Semua fitur bisa ditest tanpa IAP

**Ready untuk testing local!** 🚀
