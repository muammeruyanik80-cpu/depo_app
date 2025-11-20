FROM kivy/buildozer:latest

RUN apt-get update && apt-get install -y openjdk-17-jdk unzip wget git

RUN git config --global --add safe.directory /app

RUN mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    cd /opt/android-sdk/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    rm commandlinetools-linux-9477386_latest.zip

ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="/opt/android-sdk/cmdline-tools/latest/cmdline-tools/bin:${PATH}"

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0"

WORKDIR /app
COPY . /app

RUN buildozer android debug

RUN chmod +x /opt/android-sdk/cmdline-tools/latest/cmdline-tools/bin/sdkmanager
