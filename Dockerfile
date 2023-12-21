FROM python:3.8-slim
WORKDIR /app
COPY src/ /app/
RUN pip install Flask
EXPOSE 8080
ENV FLASK_APP=helloWorld.py
ENV FLASK_RUN_HOST=0.0.0.0
CMD ["flask", "run"]
