# Build with docker build -t flask .
FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    python \
    python-pip \
    wkhtmltopdf

RUN mkdir /code
COPY pdf.py /code/pdf.py
COPY requirements.txt /code/requirements.txt
RUN pip install -r /code/requirements.txt

ENV PYTHONUNBUFFERED 1
EXPOSE 5000

CMD ["python", "/code/pdf.py"]

