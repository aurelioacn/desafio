Dockerfile
FROM python:3.7.3-slim
COPY . /opt/
RUN pip3 install -r /opto/app/requirements.txt
WORKDIR /opt/
ENTRYPOINT ["./gunicorn_start.sh"]
