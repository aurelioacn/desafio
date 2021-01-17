FROM python:3.7.3-slim
COPY . /opt/globo/
RUN pip3 install -r /opt/globo/app/requirements.txt
WORKDIR /opt/globo/
ENTRYPOINT ["./gunicorn_start.sh"]
