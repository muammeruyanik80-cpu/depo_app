#!/bin/bash

# Buildozer otomatik APK scripti
echo "Sıfırdan buildozer.spec oluşturuluyor..."
rm -f buildozer.spec

cat <<EOL > buildozer.spec
[app]

title = DepoApp
package.name = depoapp
package.domain = org.example
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1
requirements = python3,kivy,openpyxl
android.permissions = WRITE_EXTERNAL_STORAGE,READ_EXTERNAL_STORAGE
orientation = portrait
fullscreen = 0

android.api = 33
android.minapi = 21
android.ndk = 23b
android.ndk_api = 21
android.gradle_version = 7.4
android.build_tools_version = 33.0.2
android.archs = arm64-v8a, armeabi-v7a
android.enable_androidx = True

[buildozer]

log_level = 2
warn_on_root = 0
buildozer_python = /home/mummer/depo_app/venv/bin/python
EOL

echo "Sanal ortam aktif ediliyor..."
source ~/depo_app/venv/bin/activate

echo "Buildozer temizleniyor..."
buildozer android clean

echo "APK derleniyor... (Bu biraz zaman alabilir)"
buildozer -v android debug

echo "İşlem tamamlandı. APK bin/ klasöründe."
