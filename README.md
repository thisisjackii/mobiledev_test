# Aplikasi Manajemen Karyawan - Swamedia Mobile Dev Test

Aplikasi Flutter ini dibuat sebagai solusi untuk tes teknis posisi Mobile Developer di Swamedia. Aplikasi ini memungkinkan pengguna untuk melakukan autentikasi, melihat daftar karyawan, serta menambah, mengubah, dan menghapus data karyawan melalui integrasi dengan API eksternal.

Proyek ini dibangun di atas fondasi arsitektur yang solid dari proyek sebelumnya, yang kemudian diadaptasi dan disederhanakan untuk memenuhi semua requirement tes dalam waktu yang efisien.

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3-blue?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Fitur Utama

- **Autentikasi Pengguna:** Login dengan kredensial yang ditentukan dan manajemen sesi yang persisten.
- **Auto-Login:** Aplikasi akan mengingat sesi login pengguna, sehingga tidak perlu login ulang saat aplikasi dibuka kembali.
- **Manajemen Karyawan (CRUD):**
  - **Read (GET):** Menampilkan daftar karyawan dari API.
  - **Create (POST):** Mendaftarkan karyawan baru.
  - **Update (PUT):** Mengubah data karyawan yang sudah ada.
  - **Delete (DELETE):** Menghapus data karyawan.
- **UI Responsif & Bersih:** Tampilan yang intuitif dan mudah digunakan.
- **Refresh Otomatis:** Daftar karyawan di halaman utama akan otomatis diperbarui setelah ada operasi tambah, ubah, atau hapus data.
- **Caching Offline:** Daftar karyawan disimpan di local storage (Hive), memungkinkan aplikasi untuk menampilkan data bahkan saat tidak ada koneksi internet.

## Arsitektur & Teknologi yang Digunakan

Proyek ini dibangun dengan fokus pada skalabilitas, keterbacaan, dan kemudahan testing, menggunakan pendekatan modern dalam pengembangan Flutter.

- **State Management: BLoC (Business Logic Component)**
  - Digunakan untuk memisahkan logika bisnis dari UI secara ketat.
  - Memastikan alur data yang terprediksi dan state yang mudah dikelola, terutama untuk fitur manajemen karyawan yang memiliki banyak operasi.

- **Arsitektur: Feature-First**
  - Kode diorganisir berdasarkan fitur (`/features/login`, `/features/employee`) untuk modularitas dan kemudahan navigasi.
  - Direktori `/core` berisi semua komponen yang dapat digunakan kembali (shared components) seperti service, state global, dan utilitas.

- **Dependency Injection: GetIt**
  - Menggunakan pola *Service Locator* untuk mengelola dependensi di seluruh aplikasi, membuat kode lebih *decoupled* dan mudah untuk di-unit test dengan *mocking*.

- **Networking: Dio**
  - HTTP client yang kuat dengan dukungan untuk **Interceptors**, yang digunakan untuk logging request/response secara otomatis dan penanganan error terpusat.

- **Local Storage: Hive**
  - Database NoSQL berbasis Dart yang sangat cepat, digunakan untuk caching daftar karyawan. Ini adalah implementasi dari **nilai plus** yang diminta dalam soal tes, memberikan kemampuan *offline-first*.

- **Navigasi: onGenerateRoute**
  - Menggunakan router terpusat untuk mengelola semua rute navigasi aplikasi.

## Prasyarat

Sebelum menjalankan proyek ini, pastikan Anda telah menginstal:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.19 atau lebih baru direkomendasikan)
- [Dart SDK](https://dart.dev/get-dart)
- Editor kode seperti [Visual Studio Code](https://code.visualstudio.com/) atau [Android Studio](https://developer.android.com/studio).

## Cara Menjalankan Proyek

1.  **Clone repository ini:**
    ```bash
    git clone [URL_REPOSITORY_ANDA]
    cd [NAMA_FOLDER_PROYEK]
    ```

2.  **Install dependensi:**
    ```bash
    flutter pub get
    ```

3.  **Jalankan aplikasi:**
    Hubungkan perangkat atau jalankan emulator, lalu jalankan perintah berikut di terminal.
    ```bash
    flutter run
    ```

## Kredensial untuk Login

Gunakan kredensial berikut untuk masuk ke dalam aplikasi:
- **Email:** `fluttertest@swamedia.com`
- **Password:** `fluttertest`

## Build APK

Untuk membuat file APK rilis, jalankan perintah berikut:
```bash
flutter build apk --release
