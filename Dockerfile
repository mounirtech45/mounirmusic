# استخدام صورة بايثون الرسمية كقاعدة
FROM python:3.10-slim-bookworm

# تحديث النظام وتثبيت التبعيات الأساسية (تجنب مشاكل المستودعات الخارجية)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    ffmpeg \
    build-essential \
    python3-dev \
    libffi-dev \
    libssl-dev \
    opus-tools \
    && rm -rf /var/lib/apt/lists/*

# تثبيت Node.js (الإصدار 18 المستقر)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# تحديد مجلد العمل
WORKDIR /app

# نسخ ملف المتطلبات أولاً للاستفادة من الـ Cache
COPY requirements.txt .

# تثبيت مكتبات بايثون وتحديث pip
RUN pip3 install --no-cache-dir -U pip && \
    pip3 install --no-cache-dir -U -r requirements.txt

# نسخ باقي ملفات المشروع
COPY . .

# أمر التشغيل النهائي
CMD ["python3", "main.py"]
