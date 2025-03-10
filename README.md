# Criando um Container com o MySQL

### 1. Baixar a imagem do MySQL
### 2. Criar um volume para não perder os dados no containe:
### 3. Executar o container:
```sh
docker pull mysql:latest
docker volume create mini-curso-sql-dados
docker run -d --name mini-curso-sql \
  -e MYSQL_ROOT_PASSWORD=sql \
  -p 3306:3306 \
  -v mini-curso-sql-dados:/var/lib/mysql \
  mysql:latest
```

---

## 📌 VS Code - Extensões Necessárias:
- **Docker**
- **MySQL**
- **Database Client JDBC**

