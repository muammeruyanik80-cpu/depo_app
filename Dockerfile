FROM kivy/buildozer

RUN apt-get update && apt-get install -y openjdk-17-jdk

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0" "ndk;25.2.9519653" "cmdline-tools;latest"

FROM kivy/buildozer:latest

RUN apt-get update && apt-get install -y openjdk-17-jdk unzip wget

# Android cmdline-tools indir ve sdkmanager erişimi sağla
RUN mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    cd /opt/android-sdk/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    rm commandlinetools-linux-9477386_latest.zip

ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:${PATH}"

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0" "ndk;25.2.9519653" "cmdline-tools;latest"
