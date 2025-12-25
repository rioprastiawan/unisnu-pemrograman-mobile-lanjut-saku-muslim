# 🔐 Setup Release Signing untuk Play Store

## Langkah 1: Generate Keystore

Jalankan command ini di terminal (pastikan di folder root project):

```bash
keytool -genkey -v -keystore ~/saku-muslim-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias saku-muslim-key
```

**Keterangan:**
- File keystore akan dibuat di: `~/saku-muslim-release-key.jks` (home directory)
- Validity: 10000 hari (~27 tahun)
- Alias: `saku-muslim-key`

### Saat diminta input:
1. **Keystore password**: Buat password kuat (min 6 karakter) - **CATAT INI!**
2. **Re-enter password**: Ketik ulang password yang sama
3. **First and last name**: Rio Prastiawan (atau nama Anda)
4. **Organizational unit**: (bisa Enter untuk skip)
5. **Organization**: (bisa Enter untuk skip)
6. **City**: (kota Anda, atau Enter untuk skip)
7. **State**: (provinsi Anda, atau Enter untuk skip)
8. **Country code**: ID
9. **Is this correct?**: yes
10. **Key password**: Enter (sama dengan keystore password)

## Langkah 2: Buat File key.properties

Buat file baru: `android/key.properties` dengan isi:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=saku-muslim-key
storeFile=../../saku-muslim-release-key.jks
```

**PENTING:**
- Ganti `YOUR_KEYSTORE_PASSWORD` dengan password yang Anda buat tadi
- Ganti `YOUR_KEY_PASSWORD` dengan password yang sama
- File `key.properties` jangan di-commit ke git (sudah ada di .gitignore)

## Langkah 3: Simpan Keystore dengan Aman

⚠️ **SANGAT PENTING:**
1. **Backup keystore** (`saku-muslim-release-key.jks`) ke tempat aman:
   - Google Drive
   - USB Drive
   - Password manager
2. **Catat password** di tempat aman
3. **Jangan hilang!** Tanpa keystore ini, Anda tidak bisa update app di Play Store

## Langkah 4: Test Build

```bash
cd app
flutter build appbundle --release
```

Jika berhasil, file `.aab` akan ada di:
`app/build/app/outputs/bundle/release/app-release.aab`

## ⚠️ JANGAN LAKUKAN INI:
- ❌ Commit file `key.properties` ke git
- ❌ Share keystore atau password ke siapapun
- ❌ Upload keystore ke repository public
- ❌ Hapus keystore setelah upload pertama

## 🔒 Security Checklist:
- [ ] Keystore file di-backup ke 2+ tempat aman
- [ ] Password dicatat di password manager
- [ ] File `key.properties` tidak di-commit ke git
- [ ] Build release berhasil tanpa error
