import os
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__, template_folder='templates')

# Ler a variável de ambiente para o endpoint do RDS
rds_endpoint = os.getenv("END_POINT")

# Configurar o banco de dados PostgreSQL
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://admin:password123@{rds_endpoint}:5432/todolist_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Inicializar a conexão com o banco de dados
db = SQLAlchemy(app)

# Definir o modelo Todo
class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    complete = db.Column(db.Boolean)

# Criar as tabelas no banco de dados
with app.app_context():
    db.create_all()

# Rotas da aplicação
@app.route('/')
def home():
    todo_list = Todo.query.all()
    return render_template("base.html", todo_list=todo_list)

@app.route("/add", methods=["POST"])
def add():
    title = request.form.get("title")
    new_todo = Todo(title=title, complete=False)
    db.session.add(new_todo)
    db.session.commit()
    return redirect(url_for("home"))

@app.route("/update/<int:todo_id>")
def update(todo_id):
    todo = Todo.query.filter_by(id=todo_id).first()
    todo.complete = not todo.complete
    db.session.commit()
    return redirect(url_for("home"))

@app.route("/delete/<int:todo_id>")
def delete(todo_id):
    todo = Todo.query.filter_by(id=todo_id).first()
    db.session.delete(todo)
    db.session.commit()
    return redirect(url_for("home"))

# Função para inicializar o app
def create_app():
    with app.app_context():
        db.create_all()
    return app