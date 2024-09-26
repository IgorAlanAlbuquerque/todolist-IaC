FROM python:3.10-alpine

WORKDIR /app

# Instalar dependências necessárias para compilar o psycopg2
RUN apk add --no-cache gcc musl-dev postgresql-dev

COPY todolist/requirements.txt requirements.txt

# Define o argumento chamado endpoint
ARG endpoint

# Define a variável de ambiente com o valor do argumento
ENV END_POINT=$endpoint

RUN pip install -r requirements.txt

RUN mkdir todolist

RUN mkdir todolist/templates

COPY todolist/__init__.py todolist/

COPY todolist/base.html todolist/templates

COPY todolist/wsgi.py wsgi.py

CMD [ "gunicorn", "--workers", "3",  "--bind", "0.0.0.0", "wsgi:app" ]
