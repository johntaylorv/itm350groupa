FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY src/ ./src

EXPOSE 80

CMD ["python", "src/app.py"]
