FROM python:3.10-alpine

WORKDIR /app

COPY todolist/requirements.txt requirements.txt

# Define o argumento chamado endpoint
ARG END_POINT

# Define a variável de ambiente com o valor do argumento
ENV END_POINT=$END_POINT

RUN pip install -r requirements.txt

RUN mkdir todolist

RUN mkdir todolist/templates

COPY todolist/__init__.py todolist/

COPY todolist/base.html todolist/templates

COPY todolist/wsgi.py wsgi.py

CMD [ "gunicorn", "--workers", "3",  "--bind", "0.0.0.0", "wsgi:app" ]
