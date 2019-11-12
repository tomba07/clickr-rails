# TODO Use balena image
FROM python:3-alpine

WORKDIR /app

RUN pip install --no-cache-dir evdev

COPY . .

CMD ["python", "./main.py"]
