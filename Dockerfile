FROM python:3.8-alpine
RUN mkdir /exercise
WORKDIR /exercise

COPY requirements.txt ./requirements.txt
COPY results.csv ./results.csv
COPY code/app.py ./webapp.py

RUN pip install -r requirements.txt

CMD ["python", "-u", "webapp.py"]

