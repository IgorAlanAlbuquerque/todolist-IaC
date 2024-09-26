import os
from flask import Flask, render_template, request, redirect, url_for
#from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__, template_folder='templates')

# Ler a variável de ambiente para o endpoint do RDS
rds_endpoint = os.getenv("END_POINT")

# Configurar o banco de dados PostgreSQL (comentado para teste)
#app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://db_admin:password123@{rds_endpoint}:5432/todolist_db'
#app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Inicializar a conexão com o banco de dados (comentado para teste)
#db = SQLAlchemy(app)
db = None  # Definir db como None para não interagir com o banco de dados

# Modelo Todo (comentado para não gerar erro)
# class Todo(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     title = db.Column(db.String(100))
#     complete = db.Column(db.Boolean)

# Criar as tabelas no banco de dados (comentado para não tentar criar tabelas)
# with app.app_context():
#     db.create_all()

# Rotas da aplicação (sem interação com o banco de dados)
@app.route('/')
def home():
    todo_list = []  # Criar uma lista vazia para renderizar a interface sem dados
    return render_template("base.html", todo_list=todo_list)

@app.route("/add", methods=["POST"])
def add():
    # Tente adicionar um item à lista sem interagir com o banco de dados
    title = request.form.get("title")
    # Simule a adição de um item
    return redirect(url_for("home"))

@app.route("/update/<int:todo_id>")
def update(todo_id):
    # Simular a atualização do item sem interagir com o banco de dados
    return redirect(url_for("home"))

@app.route("/delete/<int:todo_id>")
def delete(todo_id):
    # Simular a exclusão do item sem interagir com o banco de dados
    return redirect(url_for("home"))

# Função para inicializar o app
def create_app():
    # Comentar a criação das tabelas para o teste
    # with app.app_context():
    #     db.create_all()
    return app
