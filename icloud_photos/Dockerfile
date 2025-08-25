FROM python:3.11-alpine

RUN apk add --no-cache bash git curl ttyd jq

WORKDIR /app
RUN git clone https://github.com/icloud-photos-downloader/icloud_photos_downloader.git
WORKDIR /app/icloud_photos_downloader
RUN pip install .

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 7681
CMD ["/run.sh"]
