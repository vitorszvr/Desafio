sudo apt-get update

# Instalar dependências necessárias
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Adicionar chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório do Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualizar os pacotes novamente
sudo apt-get update

# Instalar Docker
sudo apt-get install -y docker.io

# Habilitar e iniciar serviço Docker
sudo systemctl enable docker
sudo systemctl start docker

# Instalar docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Criar diretório para o docker-compose.yml
mkdir -p /home/adminuser/wordpress

# Adicionar conteúdo do docker-compose.yml
cat <<EOF > /home/adminuser/wordpress/docker-compose.yml
version: '3.8'

services:
  db:
    image: mysql:5.7
    container_name: wordpress-db
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    image: wordpress:latest
    container_name: wordpress
    depends_on:
      - db
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress

volumes:
  db_data:
EOF

# Subir os containers com docker-compose
cd /home/adminuser/wordpress
sudo docker-compose up -d