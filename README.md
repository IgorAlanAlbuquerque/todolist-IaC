# todolist-IaaC

Isso cria a estrutura na nuvem aws com uma maquina virtual e banco rds via terraform

Com ansible se configura a maquina virtual criando dois docker

Um docker vai conter a aplicao que vai se comunicar com o rds

O outro docker vai conter nginx para fazer o proxy reverso

É necessário as credenciais no arquivo aws e a chave ssh privada adicionada ao agent ssh para que o ansible possa se conectar
