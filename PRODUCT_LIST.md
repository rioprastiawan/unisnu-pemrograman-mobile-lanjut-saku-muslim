# Daftar Produk In-App Purchase (IAP)

## 📦 Ringkasan Produk

Aplikasi Saku Muslim memiliki **3 produk premium** yang harus dikonfigurasi di Google Play Console.

---

## 1. 💎 Premium Lifetime (Seumur Hidup)

### Informasi Produk
- **Product ID**: `premium_lifetime`
- **Tipe**: In-app product (One-time purchase / Non-consumable)
- **Nama**: Premium Lifetime
- **Deskripsi**: Akses premium seumur hidup tanpa batas waktu

### Harga Rekomendasi
- **Indonesia**: Rp 199.000
- **USD**: $14.99
- **Pricing Strategy**: One-time payment, lifetime access

### Fitur yang Didapat
✅ Audio Offline - Download & dengarkan Al-Qur'an tanpa internet  
✅ Dark Mode - Mode gelap untuk kenyamanan mata  
✅ Unlimited Bookmarks - Tandai ayat favorit tanpa batas  
✅ Masjid Terdekat - Temukan masjid di sekitar Anda  
✅ Kalkulator Zakat - Hitung zakat fitrah dan mal  
✅ Export/Import Data - Backup & restore data Anda  
✅ Custom Themes - Personalisasi tampilan aplikasi  
✅ Widgets - Widget Al-Qur'an di home screen  

### Setup di Google Play Console
```
Product ID: premium_lifetime
Product Type: In-app product
Status: Active
Price: IDR 199,000 (or equivalent in other currencies)
Title: Premium Lifetime
Description: Dapatkan akses premium seumur hidup untuk semua fitur Saku Muslim. Sekali bayar, selamanya premium!
```

---

## 2. 📅 Premium Monthly (Bulanan)

### Informasi Produk
- **Product ID**: `premium_monthly`
- **Tipe**: Subscription (Auto-renewable)
- **Nama**: Premium Monthly
- **Deskripsi**: Langganan premium bulanan dengan pembaruan otomatis

### Harga Rekomendasi
- **Indonesia**: Rp 19.000 / bulan
- **USD**: $1.99 / month
- **Pricing Strategy**: Recurring monthly subscription

### Fitur yang Didapat
Sama dengan Premium Lifetime (selama berlangganan aktif)

### Setup di Google Play Console
```
Product ID: premium_monthly
Product Type: Subscription
Billing Period: 1 month
Status: Active
Base Plan Price: IDR 19,000/month
Free Trial: 7 days (optional)
Grace Period: 3 days (recommended)
Title: Premium Bulanan
Description: Langganan premium bulanan. Akses semua fitur premium Saku Muslim dengan pembayaran otomatis setiap bulan.
```

### Subscription Settings
- **Auto-renewal**: Yes
- **Free Trial**: 7 hari (opsional untuk meningkatkan conversion)
- **Grace Period**: 3 hari (untuk gagal pembayaran)
- **Cancellation**: Anytime before next billing

---

## 3. 📆 Premium Yearly (Tahunan)

### Informasi Produk
- **Product ID**: `premium_yearly`
- **Tipe**: Subscription (Auto-renewable)
- **Nama**: Premium Yearly
- **Deskripsi**: Langganan premium tahunan, hemat hingga 50%

### Harga Rekomendasi
- **Indonesia**: Rp 99.000 / tahun (hemat Rp 129.000)
- **USD**: $9.99 / year (save $13.89)
- **Pricing Strategy**: Best value - 56% discount compared to monthly

### Fitur yang Didapat
Sama dengan Premium Lifetime (selama berlangganan aktif)

### Setup di Google Play Console
```
Product ID: premium_yearly
Product Type: Subscription
Billing Period: 1 year
Status: Active
Base Plan Price: IDR 99,000/year
Free Trial: 7 days (optional)
Grace Period: 3 days (recommended)
Title: Premium Tahunan
Description: Langganan premium tahunan dengan HEMAT 56%! Akses semua fitur premium Saku Muslim sepanjang tahun.
```

### Subscription Settings
- **Auto-renewal**: Yes
- **Free Trial**: 7 hari (opsional)
- **Grace Period**: 3 hari
- **Discount**: Hemat 56% dibanding bulanan
- **Cancellation**: Anytime before next billing

---

## 💰 Perbandingan Harga

| Produk | Harga | Per Bulan | Hemat |
|--------|-------|-----------|-------|
| **Lifetime** | Rp 199.000 | - | Paling hemat untuk jangka panjang |
| **Monthly** | Rp 19.000/bulan | Rp 19.000 | - |
| **Yearly** | Rp 99.000/tahun | Rp 8.250 | **56%** (Rp 129.000) |

### Rekomendasi
- 🎯 **Best for Most Users**: Premium Yearly (best value)
- 🚀 **For Power Users**: Premium Lifetime (one-time payment)
- 🔄 **For Testing**: Premium Monthly (flexible)

---

## 🔧 Kode Implementasi

### Product IDs di `iap_service.dart`
```dart
static const String premiumLifetime = 'premium_lifetime';
static const String premiumMonthly = 'premium_monthly';
static const String premiumYearly = 'premium_yearly';

static const Set<String> _productIds = {
  premiumLifetime,
  premiumMonthly,
  premiumYearly,
};
```

### Purchase Duration Mapping
```dart
Map<String, Duration?> _purchaseDurations = {
  IAPService.premiumLifetime: null, // null = lifetime
  IAPService.premiumMonthly: const Duration(days: 30),
  IAPService.premiumYearly: const Duration(days: 365),
};
```

---

## 📝 Langkah Setup di Google Play Console

### Step 1: Buat Produk In-App (Lifetime)
1. Login ke [Google Play Console](https://play.google.com/console)
2. Pilih aplikasi Anda
3. Pergi ke **Monetize** → **In-app products**
4. Klik **Create product**
5. Masukkan:
   - Product ID: `premium_lifetime`
   - Name: Premium Lifetime
   - Description: Dapatkan akses premium seumur hidup...
   - Status: Active
6. Set price: Rp 199.000
7. **Save** dan **Activate**

### Step 2: Buat Subscription (Monthly)
1. Pergi ke **Monetize** → **Subscriptions**
2. Klik **Create subscription**
3. Subscription ID: `premium_monthly`
4. Name: Premium Bulanan
5. Klik **Add base plan**
6. Billing period: Monthly
7. Price: Rp 19.000/month
8. (Optional) Add 7-day free trial
9. **Save** dan **Activate**

### Step 3: Buat Subscription (Yearly)
1. Ulangi step 2 dengan data:
   - Subscription ID: `premium_yearly`
   - Name: Premium Tahunan
   - Billing period: Yearly
   - Price: Rp 99.000/year
   - Highlight: "Hemat 56%"
2. **Save** dan **Activate**

---

## 🧪 Testing Products

### License Testing
Tambahkan email tester di Google Play Console:
1. **Settings** → **License Testing**
2. Add email: `your.email@gmail.com`
3. Set response: **License_LICENSED** & **Auto-renew**

### Test Purchase Flow
```dart
// Test dengan email yang sudah didaftarkan
// Pembayaran tidak akan dikenakan biaya
await IAPService.purchaseProduct('premium_monthly');
```

### Verify Purchase
```dart
bool isPremium = await PremiumService().isPremium();
print('Premium status: $isPremium');
```

---

## 📊 Analytics & Metrics

### Metrics to Track
- **Conversion Rate**: Free → Premium
- **Popular Product**: Lifetime vs Monthly vs Yearly
- **Churn Rate**: Monthly subscription cancellations
- **Revenue Per User**: Average spending
- **Trial Conversion**: Free trial → Paid subscriber

### Recommended Tools
- Google Play Console Analytics
- Firebase Analytics
- RevenueCat (optional - advanced subscription management)

---

## 🎨 Marketing Copy

### App Store Description
```
🌟 UPGRADE KE PREMIUM 🌟

Nikmati pengalaman spiritual yang lebih dalam dengan fitur premium:

✅ Audio Offline - Dengarkan Al-Qur'an tanpa internet
✅ Masjid Terdekat - Temukan masjid di sekitar Anda
✅ Kalkulator Zakat - Hitung zakat dengan mudah
✅ Dark Mode - Nyaman untuk mata
✅ Unlimited Bookmarks - Tandai ayat favorit
✅ Dan banyak lagi!

Pilih paket yang sesuai:
💎 Lifetime - Rp 199.000 (sekali bayar, selamanya premium)
📆 Tahunan - Rp 99.000/tahun (hemat 56%!)
📅 Bulanan - Rp 19.000/bulan (fleksibel)
```

### In-App Promotion
```
🎁 PROMO SPESIAL 🎁

Dapatkan 7 hari gratis saat berlangganan Premium!
Batalkan kapan saja tanpa biaya.

[Mulai Trial Gratis]
```

---

## ⚠️ Important Notes

### Compliance
- ✅ Produk harus comply dengan Google Play policies
- ✅ Deskripsi harus jelas dan tidak menyesatkan
- ✅ Cancellation policy harus transparan
- ✅ Tidak ada konten terlarang

### Refund Policy
- Google Play: 2 jam pertama atau < $2 → automatic refund eligible
- Developer harus handle refund request dengan baik
- Monitor refund rate (high rate = red flag)

### Subscription Management
- User dapat cancel melalui Google Play
- Grace period 3 hari untuk pembayaran gagal
- Email notifikasi untuk renewal/cancellation

---

## 🔗 Resources

- [Google Play Console](https://play.google.com/console)
- [In-app Purchase Documentation](https://developer.android.com/google/play/billing)
- [pub.dev: in_app_purchase](https://pub.dev/packages/in_app_purchase)
- IAP Setup Guide: `IAP_SETUP_GUIDE.md`
- Premium Features: `PREMIUM_FEATURES.md`

---

## ✅ Checklist Pre-Launch

- [ ] Semua 3 produk sudah dibuat di Google Play Console
- [ ] Product IDs match dengan kode (`premium_lifetime`, `premium_monthly`, `premium_yearly`)
- [ ] Harga sudah di-set untuk market Indonesia
- [ ] Deskripsi produk sudah jelas dan menarik
- [ ] License testing sudah dikonfigurasi
- [ ] Test purchase berhasil di test device
- [ ] Subscription auto-renewal berfungsi
- [ ] Restore purchase berfungsi
- [ ] Premium features unlock setelah purchase
- [ ] Analytics tracking sudah aktif

---

**Last Updated**: 28 Desember 2025  
**App Version**: 1.0.0+3  
**Status**: ✅ Ready for Production
