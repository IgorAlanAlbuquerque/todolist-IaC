# Aplicação Python Todo List

Fonte original: [Tutorial](https://www.python-engineer.com/posts/flask-todo-app/)

## Comandos Para Configuração em Ambiente de Desenvolvimento

Estas etapas correspondem a utilizar a instância na AWS como ambiente de desenvolvimento, acessando-a pelo _Visual Studio Code_. Na pasta do usuário comum:

Primeiro, atualizar os pacotes e instalar o pacote _venv_ do _Python_.
```bash
sudo apt-get update
sudo apt-get -y install python3-venv
```

Vamos criar um diretório e criar um ambiente _Python_ para instalar as dependências.
```bash
mkdir todolist
cd todolist
python3 -m venv venv
```

Em seguida, ativamos o ambiente e instalamos as dependências:
```bash
. venv/bin/activate
pip install Flask
pip install Flask-SQLAlchemy
```
Por fim, clonamos o repositório e executamos a aplicação em modo de desenvolvimento:

```bash
git clone https://github.com/joaomarceloalencar/devops
cd devops/Laboratorios/01_Flask
python3 main.py
```

## Comandos Para Configuração em Ambiente de Produção

Fonte original: [Tutorial](https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-20-04-pt)

Aqui vamos configurar a aplicação para execução constante. Mesmo que a máquina seja reiniciada, o serviço da aplicação irá iniciar.
Como envolve a configuração de serviços no sistema operacional, vamos considerar os comandos abaixo executados como _root_. Você pode assumir o papel de _root_ com o comando _sudo su - root_:

Primeiro, atualizar os pacotes e instalar o pacote _venv_ do _Python_. Também vamos instalar o servidor _web_ _nginx_. Através dele, faremos a conexão com o _gnunicorn_, que é o servidor de aplicação _Python_:
```bash
apt-get update
apt-get -y install python3-venv python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools nginx
```

Vamos criar um diretório e criar um ambiente _Python_ para instalar as dependências.
```bash
mkdir /todolist
cd /todolist
python3 -m venv venv
```
Em seguida, ativamos o ambiente e instalamos as dependências:
```bash
. venv/bin/activate
pip install wheel
pip install gunicorn Flask Flask-SQLAlchemy
```

Até aqui, tudo igual. Os serviços no Ubuntu são controlados pelo sistema _SystemD_. Através dele é que iniciamos, paramos, reiniciamos, verificados o _status_ e configuramos a execução automática do serviço. Também precisamos configurar o diretório do repositório clonado para ser de propriedade do usuário _ubuntu_ e do grupo _www-data_. O usuário _ubuntu_ tem menos privilégios e o grupo _www-data_ é o grupo do processo _nginx_. Essa alteração traz mais segurança.
```bash
git clone https://github.com/joaomarceloalencar/devops
chown ubuntu:www-data /todolist/devops/Laboratorios/01_Flask
```

Copiamos o arquivo do serviço para a pasta do _SystemD_ e habilitamos o serviço.
```bash
cp /todolist/devops/Laboratorios/01_Flask/conf/todolist.service /etc/systemd/system/
systemctl start todolist
systemctl enable todolist 
```

Configuramos o servidor _nginx_ para encaminhar as requisições para o serviço:
```bash
cp /todolist/devops/Laboratorios/01_Flask/conf/todolist /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/todolist /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
```
Pronto! Mesmo que a máquina reinicie, a aplicação está disponível.
