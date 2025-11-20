FROM kivy/buildozer:latest

# Sistem güncellemesi ve gerekli araçlar
RUN apt-get update && apt-get install -y openjdk-17-jdk unzip wget

# Android cmdline-tools indir ve sdkmanager erişimi sağla
RUN mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    cd /opt/android-sdk/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    rm commandlinetools-linux-9477386_latest.zip

# PATH ayarı
ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:${PATH}"

# Android lisanslarını kabul et ve gerekli araçları indir
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0"

# Çalışma dizini ve kaynak kod
WORKDIR /app
COPY . /app

# APK üretimi
RUN buildozer android debug
