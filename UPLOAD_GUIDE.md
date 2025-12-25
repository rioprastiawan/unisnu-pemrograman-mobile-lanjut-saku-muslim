# 📖 Panduan Upload ke Play Store

## ✅ Yang Sudah Siap

Aplikasi Saku Muslim sudah dilengkapi dengan:

1. **About Page** - Info aplikasi & credits ✅
2. **Privacy Policy** - Kebijakan privasi lengkap ✅  
3. **Onboarding** - Welcome screen untuk user baru ✅
4. **Semua fitur core** - Sholat, Quran, Kiblat, Kalender ✅

## 📋 Yang Perlu Kamu Lakukan

### 1. Buat Assets untuk Play Store (WAJIB)

#### Screenshots (butuh 2-8 gambar)
1. Jalankan app di emulator/device
2. Ambil screenshot dari:
   - Home page (jadwal sholat)
   - Al-Qur'an page  
   - Surah detail
   - Kiblat finder
   - Kalender
   - Menu lainnya

**Tips:** Gunakan device dengan layar besar untuk screenshot yang bagus

#### Feature Graphic (1024 x 500 px)
- Buat di Canva (gratis)
- Template: "Google Play Feature Graphic"
- Pakai warna hijau & icon masjid
- Tulis: "Saku Muslim - Al-Qur'an & Jadwal Sholat"

#### App Icon  
Check folder `assets/icon/` - pastikan ada icon untuk semua ukuran

### 2. Build Release APK

```bash
cd app
flutter build appbundle --release
```

File akan ada di: `app/build/app/outputs/bundle/release/app-release.aab`

### 3. Daftar Google Play Developer

1. Buka: https://play.google.com/console
2. Bayar $25 (one-time, selamanya)
3. Isi data developer

### 4. Upload App

1. **Create new app** di Play Console
2. **App details:**
   - App name: `Saku Muslim`
   - Default language: Indonesian
   - App/Game: App
   - Free/Paid: Free

3. **Store listing:**
   - Short description: "Aplikasi islami lengkap: Al-Qur'an, Jadwal Sholat, Kiblat & Kalender Hijriyah"
   - Full description: Lihat `PLAY_STORE_CHECKLIST.md`
   - Upload screenshots
   - Upload feature graphic
   - App icon: Auto dari AAB
   - Category: Lifestyle
   - Email: your@email.com

4. **Content rating:**
   - Fill questionnaire
   - Choose "No" untuk violence, sexual content, dll
   - Result: "Everyone"

5. **Privacy Policy:**
   **PENTING:** Upload privacy_policy_page.dart content ke website/GitHub
   
   **Cara cepat:**
   - Buat file `privacy.html` dengan isi dari privacy_policy_page
   - Upload ke GitHub Pages (gratis)
   - Atau pakai GitHub Gist
   - Copy URL-nya

6. **App content:**
   - Target audience: All ages
   - COVID-19 contact: No
   - Ads: No (kalo memang tidak ada iklan)

7. **Upload AAB:**
   - Production > Create new release
   - Upload `app-release.aab`
   - Release name: "1.0.0"
   - Release notes: "Initial release"

8. **Review & Publish:**
   - Review all info
   - Click "Send for review"

## ⏱️ Timeline

- **Setup (2-3 jam):** Buat assets, build AAB, isi form
- **Google Review:** 1-7 hari (biasanya 1-2 hari)
- **Live:** Setelah approved!

## 🆘 Troubleshooting

### Build Error?
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### Missing Icon?
- Cek `android/app/src/main/res/mipmap-*` 
- Atau generate ulang dengan Android Studio

### Privacy Policy URL Required?
1. Copy isi `lib/pages/privacy_policy_page.dart`
2. Paste ke Google Docs → Share → Anyone with link
3. Copy link tersebut
4. Atau pakai GitHub Pages (lebih proper)

## 📝 Quick Copy-Paste

### Short Description
```
Aplikasi islami lengkap: Al-Qur'an, Jadwal Sholat, Kiblat & Kalender Hijriyah
```

### Keywords
```
al-quran, alquran, jadwal sholat, adzan, kiblat, kalender islam, muslim, prayer times
```

## ✅ Before Submit Checklist

- [ ] AAB file berhasil di-build
- [ ] Screenshots siap (minimal 2)
- [ ] Feature graphic siap
- [ ] Privacy policy URL siap
- [ ] Email contact siap
- [ ] Test app di real device (no crash)
- [ ] Semua form di Play Console terisi

## 🎉 Setelah Publish

1. Share link Play Store ke teman-teman
2. Minta rating & review
3. Monitor feedback user
4. Update kalau ada bug

---

**Need help?** Check `PLAY_STORE_CHECKLIST.md` untuk panduan lengkap!

Good luck! 🚀 Semoga berkah! 🤲
