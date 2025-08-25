FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata libexif-dev ffmpeg && \
    pip install --no-cache-dir icloudpd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
