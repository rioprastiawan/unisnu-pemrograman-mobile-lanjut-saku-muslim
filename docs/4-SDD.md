# SOFTWARE DESIGN DOCUMENT (SDD): SAKU MUSLIM (DETAIL TEKNIS)

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

Dokumen ini berfungsi sebagai panduan teknis implementasi untuk aplikasi Saku Muslim. Ini merinci arsitektur, desain komponen, alur data, dan strategi teknis yang akan digunakan untuk membangun aplikasi sesuai dengan SRS. Tujuannya adalah untuk memastikan kode yang dihasilkan terstruktur, dapat diuji (testable), dan mudah dipelihara (maintainable).

---

## 2. ARSITEKTUR & POLA DESAIN

### 2.1. Arsitektur Inti: Feature-Driven MVVM

Arsitektur ini memisahkan tanggung jawab secara jelas:

- **View (UI Layer):** Bertanggung jawab murni untuk rendering UI. Widget di lapisan ini bersifat "reaktif"—hanya menampilkan state yang diberikan oleh ViewModel. Tidak ada logika bisnis di sini. View akan dibangun menggunakan widget Flutter standar (`StatelessWidget`, `StatefulWidget`).

- **ViewModel (Business Logic Layer):** Bertanggung jawab atas semua logika bisnis untuk sebuah fitur.

  - Mengelola state dari fitur (misal: `isLoading`, `data`, `error`).
  - Berkomunikasi dengan Service Layer untuk mengambil atau memanipulasi data.
  - Menyediakan data yang sudah diformat dan siap ditampilkan ke View.
  - Setiap ViewModel akan meng-extend `ChangeNotifier` dari Flutter SDK.

- **Model (Data Layer):** Kelas Dart sederhana (Plain Old Dart Objects - PODOs) yang merepresentasikan struktur data dari API atau aset lokal. Model ini akan bersifat _immutable_ (tidak dapat diubah setelah dibuat).

- **Service (Data Access Layer):** Bertanggung jawab sebagai satu-satunya titik kontak untuk sumber data eksternal (API, sensor, file lokal). Ini mengisolasi logika akses data dari sisa aplikasi.

### 2.2. Manajemen State: Provider

Provider akan digunakan untuk Dependency Injection (menyediakan instance Service ke ViewModel) dan untuk menghubungkan ViewModel ke View.

- **Alur State:**
  1.  ViewModel memanggil sebuah metode (misal: `fetchData()`).
  2.  ViewModel mengubah state `isLoading` menjadi `true` dan memanggil `notifyListeners()`.
  3.  View (yang "mendengarkan" via `Consumer` atau `context.watch`) akan membangun ulang UI untuk menampilkan `LoadingIndicator`.
  4.  Setelah data diterima dari Service, ViewModel memperbarui state `data` atau `error`, mengubah `isLoading` menjadi `false`, dan memanggil `notifyListeners()` lagi.
  5.  View membangun ulang UI untuk menampilkan data atau pesan error.

---

## 3. STRUKTUR DIREKTORI PROYEK (DETAIL)

Struktur ini dirancang untuk skalabilitas dan kejelasan.

```
saku_muslim/
├── lib/
│ ├── app/ // Konfigurasi aplikasi & konstanta.
│ │ ├── config/ // `theme.dart`, `router.dart`
│ │ └── constants/ // `api_endpoints.dart`, `app_strings.dart`
│ │
│ ├── core/
│ │ ├── services/ // Definisi & Implementasi Service.
│ │ │ ├── `api_service.dart`
│ │ │ ├── `location_service.dart`
│ │ │ └── `asset_service.dart`
│ │ ├── models/ // Definisi Model Data.
│ │ └── utils/ // Fungsi utilitas (misal: `date_formatter.dart`).
│ │
│ ├── features/
│ │ ├── home/ // Fitur utama (Jadwal Sholat).
│ │ │ ├── view/ // `home_screen.dart`
│ │ │ ├── viewmodel/ // `home_viewmodel.dart`
│ │ │ └── widgets/ // `prayer_time_card.dart`
│ │ │
│ │ └── ... (Folder untuk `qibla`, `asmaul_husna`, `daily_doa`)
│ │
│ ├── shared_widgets/ // Widget generik yang dipakai lintas fitur.
│ │
│ └── main.dart // Inisialisasi aplikasi, Provider, dan routing.
```

---

## 4. DESAIN LAPISAN DATA (DATA LAYER DETAIL)

### 4.1. Model Design

Semua model akan dibuat _immutable_ dengan constructor `const`. Mereka akan menyertakan factory method `fromJson()` untuk parsing data dari JSON.

_Contoh: `prayer_time_model.dart`_

```dart
class PrayerTimeModel {
  final String fajr;
  final String dhuhr;
  // ... properti lainnya
  const PrayerTimeModel({required this.fajr, required this.dhuhr, ...});

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: json['timings']['Fajr'],
      dhuhr: json['timings']['Dhuhr'],
      // ... parsing lainnya
    );
  }
}
```

### 4.2. Service Layer Design

Setiap Service akan didefinisikan sebagai kelas dengan metode asinkron yang mengembalikan data atau melempar (throw) exception khusus.

- **`ApiService`**

  - **Dependencies:** `http.Client`
  - **Methods:**
    ```dart
    // Mengembalikan PrayerTimeModel jika sukses,
    // atau melempar exception jika gagal.
    Future<PrayerTimeModel> getPrayerTimes({
      required double latitude,
      required double longitude,
    });
    ```

- **`AssetService`**

  - **Dependencies:** Tidak ada.
  - **Methods:**
    ```dart
    Future<List<AsmaulHusnaModel>> loadAsmaulHusna();
    Future<List<DoaModel>> loadDailyDoas();
    ```

- **`LocationService`**
  - **Dependencies:** `geolocator` plugin.
  - **Methods:**
    ```dart
    // Mengembalikan Position jika sukses,
    // atau melempar exception jika izin ditolak/GPS mati.
    Future<Position> getCurrentPosition();
    ```

---

### 5. DESAIN LAPISAN LOGIKA BISNIS (VIEWMODEL)

ViewModel akan mengelola state dan berinteraksi dengan Services.

_Contoh: `home_viewmodel.dart`_

```dart
class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final LocationService _locationService;

  // Constructor
  HomeViewModel(this._apiService, this._locationService) {
    fetchInitialPrayerTimes();
  }

  // State Properties
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  PrayerTimeModel? _prayerTimes;
  PrayerTimeModel? get prayerTimes => _prayerTimes;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Business Logic Methods
  Future<void> fetchInitialPrayerTimes() async {
    _setLoading(true);
    try {
      final position = await _locationService.getCurrentPosition();
      _prayerTimes = await _apiService.getPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString(); // Disederhanakan, idealnya pesan yg lebih baik
      _prayerTimes = null;
    }
    _setLoading(false);
  }

  // Private helper to manage state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

---

## 6. DESAIN LAPISAN UI (VIEW)

View akan menjadi lapisan yang reaktif terhadap state dari ViewModel.

_Contoh: `home_screen.dart`_

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan pada HomeViewModel
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        }
        if (viewModel.prayerTimes != null) {
          return PrayerTimeList(prayerTimes: viewModel.prayerTimes!);
        }
        return Center(child: Text("Data tidak tersedia."));
      },
    );
  }
}
```

---

## 7. STRATEGI PENANGANAN ERROR (ERROR HANDLING)

Strategi penanganan error akan berlapis untuk memberikan pengalaman pengguna yang baik.

1.  **Service Layer:** Ketika terjadi error (misal: koneksi timeout, 404 Not Found, izin lokasi ditolak), Service akan melempar (throw) _custom exception_ yang spesifik.

    - Contoh: `NetworkException('Tidak ada koneksi internet.')`, `LocationPermissionException('Izin lokasi ditolak.')`.

2.  **ViewModel Layer:** ViewModel akan membungkus pemanggilan Service dalam blok `try-catch`.

    - Jika exception tertangkap, ViewModel akan mengisi state `_errorMessage` dengan pesan yang mudah dipahami oleh pengguna.

3.  **View Layer:** View akan secara kondisional merender widget yang berbeda berdasarkan state `errorMessage`.
    - Jika `errorMessage` tidak `null`, tampilkan widget pesan error dengan tombol "Coba Lagi" yang akan memanggil kembali metode di ViewModel.

---

## 8. DESAIN NAVIGASI

Navigasi akan dikelola secara terpusat untuk kemudahan maintenance.

- **`router.dart`**
  - Sebuah kelas `AppRouter` dengan metode statis `generateRoute`.
  - Metode ini akan digunakan dalam properti `onGenerateRoute` di `MaterialApp`.
  - Menggunakan `switch-case` pada `routeSettings.name` untuk mengembalikan `MaterialPageRoute` yang sesuai untuk setiap rute.
  - Ini memungkinkan penanganan rute yang tidak ditemukan (404 page) dan pengiriman argumen antar halaman secara aman.

---

Dokumen ini menyediakan spesifikasi teknis yang cukup rinci untuk memulai implementasi Saku Muslim dengan fondasi yang kuat, terstruktur, dan dapat diandalkan.
