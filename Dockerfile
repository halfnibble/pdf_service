# LTS Ubuntu
FROM ubuntu:jammy

ARG TARGETPLATFORM

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg && \
    echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/debian-bullseye.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 0E98404D386FA1D9 605C66F00D6C9793 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    libxrender1 \
    fontconfig \
    xvfb \
    libjpeg62-turbo \
    libssl1.1 \
    && \
    case "${TARGETPLATFORM}" in \
    "linux/amd64") \
    WKH_BUILD="wkhtmltox_0.12.6.1-2.bullseye_amd64.deb" \
    ;; \
    "linux/arm64") \
    WKH_BUILD="wkhtmltox_0.12.6.1-2.bullseye_arm64.deb" \
    ;; \
    *) \
    echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 \
    ;; \
    esac && \
    curl -L -o /tmp/${WKH_BUILD} https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/${WKH_BUILD} && \
    apt-get install -y --no-install-recommends /tmp/${WKH_BUILD} && \
    rm -rf /var/lib/apt/lists/* /tmp/${WKH_BUILD} && \
    apt-get clean

RUN echo '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" \
    /usr/bin/wkhtmltopdf -q "$@"' > /usr/bin/wkhtmltopdf.sh
RUN chmod a+x /usr/bin/wkhtmltopdf.sh

RUN mkdir /code
COPY pdf.py /code/pdf.py
COPY requirements.txt /code/requirements.txt
RUN pip3 install -r /code/requirements.txt

ENV PYTHONUNBUFFERED 1
EXPOSE 5000

WORKDIR /code
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "--access-logfile", "-", "--error-logfile", "-", "pdf:app"]
