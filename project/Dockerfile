FROM python:3-alpine
#COPY project /app
COPY . /app
WORKDIR /app
RUN apk add gcc python3-dev musl-dev libffi-dev openssl-dev mariadb-dev
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 3000
ENTRYPOINT ["python"]
CMD ["app.py"]


