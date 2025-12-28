# Setup In-App Purchase (IAP) untuk Android

## Panduan Lengkap Implementasi Premium Features dengan Google Play Billing

### 📋 Prerequisites
1. Akun Google Play Console Developer (biaya $25 satu kali)
2. Aplikasi sudah di-upload ke Play Console (minimal internal testing)
3. Package name yang sama dengan aplikasi di Play Console

---

## 1️⃣ Setup Google Play Console

### A. Buat Produk In-App Purchase

1. **Login ke Google Play Console**
   - Buka https://play.google.com/console
   - Pilih aplikasi "Saku Muslim"

2. **Buat In-App Products**
   - Navigate ke: **Monetization** → **In-app products**
   - Klik **Create product** untuk setiap produk

### B. Konfigurasi 3 Produk IAP

#### Produk 1: Premium Lifetime (One-time Purchase)
```
Product ID: premium_lifetime
Product type: Managed product (one-time purchase)
Name: Saku Muslim Premium Selamanya
Description: Akses selamanya ke semua fitur premium tanpa batas waktu
Status: Active
Price: Rp 99,000 (atau sesuai strategi pricing Anda)
```

#### Produk 2: Premium Monthly (Subscription)
```
Product ID: premium_monthly
Product type: Subscription
Name: Saku Muslim Premium Bulanan
Description: Langganan bulanan dengan perpanjangan otomatis
Billing period: 1 month
Free trial: 7 days (optional)
Grace period: 3 days (recommended)
Price: Rp 19,000 per bulan
Status: Active
```

#### Produk 3: Premium Yearly (Subscription)
```
Product ID: premium_yearly
Product type: Subscription
Name: Saku Muslim Premium Tahunan
Description: Langganan tahunan - hemat 40% dibanding bulanan!
Billing period: 1 year
Free trial: 7 days (optional)
Grace period: 3 days (recommended)
Price: Rp 149,000 per tahun
Status: Active
```

### C. Aktivasi Billing

1. Di Play Console, pastikan:
   - Billing telah di-setup (Monetize → Setup)
   - License Testing sudah dikonfigurasi

2. **Tambahkan License Testers**:
   - Navigate ke: **Setup** → **License testing**
   - Tambahkan email Gmail untuk testing
   - Email ini bisa melakukan pembelian tanpa ditagih

---

## 2️⃣ Update Konfigurasi Android

### A. Update `android/app/build.gradle.kts`

Pastikan aplikasi sudah memiliki konfigurasi yang benar:

```kotlin
android {
    namespace = "com.yourcompany.sakumuslim" // Sesuaikan dengan package name Anda
    compileSdk = 35
    
    defaultConfig {
        applicationId = "com.yourcompany.sakumuslim" // HARUS SAMA dengan Play Console
        minSdk = 21
        targetSdk = 35
        versionCode = 2
        versionName = "1.0.0"
    }
    
    buildTypes {
        release {
            // Konfigurasi signing untuk release
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### B. Permissions (Sudah otomatis ditambahkan oleh plugin)

Plugin `in_app_purchase` akan otomatis menambahkan permission yang diperlukan:
```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

---

## 3️⃣ Testing In-App Purchase

### A. Internal Testing Track

1. **Upload APK/AAB ke Internal Testing**:
   ```bash
   cd app
   flutter build appbundle --release
   ```

2. **Upload ke Play Console**:
   - Navigate ke: **Release** → **Testing** → **Internal testing**
   - Upload file: `app/build/app/outputs/bundle/release/app-release.aab`

3. **Tambahkan Internal Testers**:
   - Buat email list atau tambahkan individual testers
   - Share link opt-in ke testers

### B. Testing dengan License Testers

Gunakan akun yang sudah didaftarkan sebagai License Testers:

1. **Install aplikasi dari Play Store** (via internal testing link)
2. **Login dengan akun tester**
3. **Test purchase flow**:
   - Klik "Upgrade ke Premium"
   - Pilih salah satu paket
   - Proses pembelian akan muncul dialog "Test Purchase" (tidak akan ditagih)

### C. Testing Restore Purchases

1. Uninstall aplikasi
2. Install ulang
3. Di halaman Premium, klik "Pulihkan Pembelian"
4. Premium status harus ter-restore

---

## 4️⃣ Production Release

### A. Sebelum Publish ke Production

✅ **Checklist Pre-Launch:**
- [ ] Semua produk IAP status = Active
- [ ] Testing sudah selesai di internal/closed testing
- [ ] Restore purchase berfungsi dengan baik
- [ ] Subscription renewal berfungsi
- [ ] Handle error cases (network error, payment failed, etc.)

### B. Publish ke Production

1. **Promote Release**:
   - Dari Internal Testing → Production
   - Atau upload build baru ke Production track

2. **Review Process**:
   - Google akan review aplikasi dan IAP products
   - Proses review bisa 1-7 hari
   - Pastikan tidak melanggar kebijakan Google Play

---

## 5️⃣ Best Practices & Tips

### Security

1. **JANGAN hardcode product IDs di banyak tempat**
   - Sudah centralized di `IAPService` class

2. **Verifikasi Purchase di Backend** (Recommended untuk production):
   ```dart
   // Di production, kirim purchase token ke backend untuk verifikasi
   final token = purchaseDetails.verificationData.serverVerificationData;
   // Backend verify dengan Google Play Developer API
   ```

3. **Simpan purchase token** untuk tracking dan debugging

### User Experience

1. **Loading States**: Selalu tampilkan loading saat proses purchase
2. **Error Handling**: Berikan feedback yang jelas jika purchase gagal
3. **Restore Button**: Mudah diakses untuk user yang reinstall app

### Monitoring

1. **Track conversions** di Play Console Analytics
2. **Monitor subscription churn rate**
3. **A/B testing** untuk pricing strategy

---

## 6️⃣ Troubleshooting

### ❌ Problem: "Product not found"
**Solution:**
- Pastikan product ID exact match dengan Play Console
- Produk harus status "Active"
- Aplikasi harus sudah di-upload ke track (minimal internal testing)
- Package name harus sama

### ❌ Problem: "Item unavailable in your country"
**Solution:**
- Set pricing untuk semua negara di Play Console
- Atau spesifik countries yang Anda target

### ❌ Problem: Purchase tidak ter-restore
**Solution:**
- Cek `queryPastPurchases()` dipanggil dengan benar
- Pastikan menggunakan akun yang sama
- Check purchase status di Play Console

### ❌ Problem: Test purchase muncul di production
**Solution:**
- Pastikan build production tidak menggunakan akun tester
- Clear app data dan test dengan akun normal

---

## 7️⃣ Pricing Strategy Recommendation

### Untuk Market Indonesia:

**Option 1: Aggressive (Acquire Users Fast)**
- Monthly: Rp 9,900
- Yearly: Rp 99,000 (save 17%)
- Lifetime: Rp 199,000

**Option 2: Standard (Balanced)**
- Monthly: Rp 19,900
- Yearly: Rp 149,000 (save 37%)
- Lifetime: Rp 299,000

**Option 3: Premium (High Value)**
- Monthly: Rp 29,900
- Yearly: Rp 249,000 (save 30%)
- Lifetime: Rp 499,000

### Value Proposition
Pastikan fitur premium memberikan value yang jelas:
- ✅ Audio offline (sangat berguna)
- ✅ Dark mode (popular feature)
- ✅ Unlimited bookmarks (power users)
- ✅ No ads (comfort)
- ✅ Data backup (security)

---

## 8️⃣ Code yang Sudah Diimplementasi

### Files yang sudah dibuat:
1. ✅ `lib/services/premium_service.dart` - Manage premium status
2. ✅ `lib/services/iap_service.dart` - Handle Google Play Billing
3. ✅ `lib/pages/premium_page.dart` - UI untuk purchase
4. ✅ `lib/widgets/premium_widgets.dart` - Reusable premium UI components
5. ✅ Database updated dengan table `offline_audio`

### Next Steps:
1. Test di internal testing
2. Setup backend verification (optional tapi recommended)
3. Implement analytics tracking
4. Add A/B testing untuk pricing

---

## 📞 Support

Jika ada masalah, check:
1. Google Play Console Help Center
2. Flutter In-App Purchase documentation
3. Stack Overflow dengan tag `flutter` dan `in-app-purchase`

---

## 📝 Notes

- Subscription auto-renew by default
- Grace period gives user 3 days to fix payment issue
- Account hold gives user 30 days before cancellation
- Test dengan sandbox environment dulu sebelum production

**Good luck with your premium features! 🚀**
