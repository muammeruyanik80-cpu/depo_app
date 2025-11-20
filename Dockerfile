FROM kivy/buildozer:latest

RUN apt-get update && apt-get install -y openjdk-17-jdk unzip wget git

# Git güvenli dizin ayarı
RUN git config --global --add safe.directory $(pwd)

# Android SDK kurulumu
RUN mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    cd /opt/android-sdk/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    rm commandlinetools-linux-9477386_latest.zip

# Ortam değişkenleri
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# sdkmanager çalıştırılabilir olsun
RUN chmod +x /opt/android-sdk/cmdline-tools/latest/cmdline-tools/bin/sdkmanager

# Android bileşenlerini indir
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0"

WORKDIR /app
COPY . /app

# Eğer buildozer.spec yoksa oluştur
RUN test -f buildozer.spec || buildozer init

# APK üretimi
RUN buildozer android debug
