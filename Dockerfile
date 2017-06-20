# Build with docker build -t flask .
FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    libxrender1 \
    fontconfig \
    xvfb \
    wget
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -P /tmp/
RUN tar xf /tmp/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /tmp
RUN mv /tmp/wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
RUN echo '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" \
    /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh
RUN chmod a+x /usr/bin/wkhtmltopdf.sh
RUN ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

RUN mkdir /code
COPY pdf.py /code/pdf.py
COPY requirements.txt /code/requirements.txt
RUN pip3 install -r /code/requirements.txt

ENV PYTHONUNBUFFERED 1
EXPOSE 5000

CMD ["python3", "/code/pdf.py"]

