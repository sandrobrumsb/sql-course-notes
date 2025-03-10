    -- CRIANDO TABELAS:
CREATE TABLE marcas (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,  -- AUTO_INCREMENT: o próprio banco vai adicionar uma chave primária sequencialmente.
    nome VARCHAR(100) NOT NULL UNIQUE,      -- UNIQUE: Significa que esse nome será único.
    site VARCHAR(100) NOT NULL,             -- NOT NULL:  Significa que o campo não pode ficar vazio.
    telefone VARCHAR(15)
);

CREATE TABLE produtos(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco REAL,
    estoque INTEGER DEFAULT 0               --DEFAULT 0: Terá o valor 0 por padrão caso um novo produto seja inserido sem especificar um valor.
);


    -- ALTERANDO TABELAS:
ALTER TABLE produtos ADD COLUMN id_marca INT NOT NULL; --Adicionando a coluna id_marca.
ALTER TABLE produtos MODIFY COLUMN nome VARCHAR(150);  --Modificando a quantidade de Varchar na coluna nome.
ALTER TABLE produtos ADD FOREIGN KEY (id_marca) REFERENCES marcas(id);


    -- EXCLUINDO TABELA:
CREATE TABLE controle(
    id INTEGER PRIMARY KEY,
    data_entrada DATE
);
DROP TABLE controle;              --Excluindo a tabela controle.
DROP TABLE IF EXISTS controle;    --IF EXISTS: significa que so vai excluir se a tabela existir.


    -- CRIANDO ÍNDICES:
CREATE INDEX idx_produtos_nome ON produtos (nome);  --Cria um índice chamado idx_produtos_nome na coluna nome da tabela produtos.
--Crie índices apenas em colunas que são frequentemente pesquisadas em WHERE, ORDER BY ou JOIN
/*Esse índice acelera as buscas para localizar os registros de forma mais eficiente sem precisar percorrer toda a tabela. Embora os índices melhorem a velocidade das consultas,
eles ocupam espaço no banco de dados e podem diminuir o desempenho de inserções e atualizações*/


    -- INSERINDO REGISTROS NAS TABELAS:
INSERT INTO marcas
    (nome, site, telefone)                      -- Declarando as colunas na tabela marcas.
VALUES                                          -- VALUES: declarndo os valores das colunas.
    ('Apple', 'apple.com', '0800-761-0867'), 
    ('Dell', 'dell.com.br', '0800-970-3355'), 
    ('Herman Miller', 'hermanmiller.com.br', '(11) 3474-8043'),
    ('Shure', 'shure.com.br', '0800-970-3355');

INSERT INTO produtos
    (nome, preco, estoque, id_marca)
VALUES
    ('iPhone 16 Pro Apple (256GB) - Titânio Preto', 9299.99, 100, 1),
    ('iPhone 15 Apple (128GB) - Preto', 4599.00, 50, 1),
    ('MacBook Air 15" M2 (8GB RAM , 512GB SSD) - Prateado', 8899.99, 23, 1),
    ('Notebook Inspiron 16 Plus', 10398.00, 300, 2),
    ('Cadeira Aeron - Grafite', 15540.00, 8, 3),
    ('Microfone MV7 USB', 2999.99, 70, 4),
    ('Microfone SM7B', 5579.99, 30, 4);


    -- CONSULTANDO REGISTROS:
SELECT * FROM marcas;           --Pesquisa todos os registros da tabela marcas.
SELECT id, nome from marcas;    --Pesquisa somente as colunas id e nome da tabela marcas.
SELECT id, nome from marcas WHERE id = 2;   -- WHERE id: criando um Filtro onde so retorna o id igual a 2.
SELECT id, nome from marcas WHERE id > 2;   -- Retorna os id MAIOR que 2.

    --  USANDO INSERT + SELECT:
CREATE TABLE produtos_apple(        --criando uma tabela temporaria
    nome VARCHAR(150) NOT NULL,
    estoque INTEGER DEFAULT 0
);
INSERT INTO produtos_apple          --inserindo na tabela produtos_apple todos os dados com id_marca = 1
SELECT nome, estoque FROM produtos WHERE id_marca = 1;
SELECT * FROM produtos_apple;

    -- APAGANDO TODOS OS REGISTROS DA TABELA:
TRUNCATE TABLE produtos_apple;      -- TRUNCATE TABLE nomeDaTabela:  apaga todos os dados da tabela.
DROP Table produtos_apple;          -- excluir a tabela temporaria.


    -- ATUALIZANDO OS REGISTROS DA TABELA:
UPDATE produtos     -- Alterando a tabela produtos na coluna nome no id = 7.
SET nome = 'Microfone SM7B preto'
WHERE id = 7;

UPDATE produtos     -- Alterando todos os produtos. OBS: CUIDADO AO USAR UPDATE SEM WHERE!!!
SET estoque = estoque + 10;

UPDATE produtos     -- Alterando apenas 1 quantidade em um id especifico.
SET estoque = estoque + 1
WHERE id_marca =1;


    -- DELETANDO UM REGISTRO:
DELETE FROM  produtos   -- Exclui o registro que esta no id = 7.
WHERE id = 7;

    -- OUTROS TIPOS DE BUSCA COM O OPERADORES:
SELECT * FROM produtos      -- Realiza a busca na coluna estoque menor que 50
WHERE estoque < 50;

SELECT * FROM produtos      -- Realiza a busca na coluna estoque menor que 50 e maior que 20
WHERE estoque < 50
AND estoque > 20;

SELECT * FROM produtos      -- Realiza a busca na coluna estoque menor que 80 e coluna preco maior que 3000
WHERE estoque < 80
AND preco > 3000;

SELECT * FROM produtos      -- Busca na tabela produto e coluna nome qualquer palavra que COMEÇA com Iphone.   
WHERE nome LIKE 'iphone%';

SELECT * FROM produtos  -- Busca na tabela produto e coluna nome qualquer palavra que TENHA a palavra apple em qualquer lugar.   
WHERE nome LIKE '%apple%';

    -- ORDENADO REGISTROS:
SELECT * FROM produtos  -- Ordena a tabela produtos na coluna estoque em ordem CRESCENTE.
ORDER BY estoque;

SELECT * FROM produtos  -- Ordena a tabela produtos na coluna estoque em ordem DECRESCENTE.
ORDER BY estoque DESC;

SELECT * FROM produtos  -- Ordena a tabela na coluna estoque em ordem CRESCENTE LIMITANDO a 5 RESULTADOS.
ORDER BY estoque
LIMIT 5;

SELECT * FROM produtos  -- Ordena a tabela na coluna estoque em ordem DECRESCENTE LIMITANDO a 5 RESULTADOS.
ORDER BY estoque DESC
LIMIT 5;


    -- JUNÇÃO DE TABELAS (JOIN):

-- 1º CRIANDO AS TABELAS QUE USAREI NO JOIN:
-- CLIENTES
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY AUTO_INCREMENT, 
  nome VARCHAR(100) NOT NULL, 
  email VARCHAR(100) UNIQUE NOT NULL, 
  cidade VARCHAR(200), 
  data_nascimento DATE 
);
-- PEDIDOS
CREATE TABLE pedidos (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  data_pedido DATE DEFAULT (NOW()),
  id_cliente INTEGER,
  valor_total REAL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);
-- ITENS DO PEDIDO
CREATE TABLE itens_pedido (
  id_pedido INTEGER,
  id_produto INTEGER,
  quantidade INTEGER,
  preco_unitario REAL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id), 
  FOREIGN KEY (id_produto) REFERENCES produtos(id), 
  PRIMARY KEY (id_pedido, id_produto)
);
INSERT INTO clientes (nome, email, cidade) VALUES
('João Pereira', 'joao@exemplo.com.br', 'Rio de Janeiro'),
('Ana Costa', 'ana@costa.com', 'São Paulo'),
('Carlos Souza', 'carlos@gmail.com', 'Belo Horizonte'),
('Vanessa Weber', 'vanessa@codigofonte.tv', 'São José dos Campos'),
('Gabriel Fróes', 'gabriel@codigofonte.tv', 'São José dos Campos');
INSERT INTO pedidos (id_cliente, valor_total) VALUES
(1, 5500.00),
(2, 2000.00);
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),
(1, 2, 1, 2000.00),
(2, 2, 1, 2000.00);

  -- INNER JOIN E OPERADOR IN: 

SELECT              -- Listando apenas clientes que tem pedidos:
    clientes.nome,  -- Tabela_clientes.Campo_nome
    pedidos.valor_total -- Tabela_pedidos.Campo_valor_Total
    FROM clientes       -- INNER JOIN:  mostra o id da tabela clientes igual o id_cliente da tabela pedidos
    INNER JOIN pedidos on clientes.id = pedidos.id_cliente;

  -- SUBQUERY
 SELECT             -- Seleciona as colunas nome e preco da tabela produtos,
    nome, preco     -- FROM: indica que a consulta sera na tabela produtos,    
 FROM               -- WHERE id_marca IN : esta filtrando os produtos da id_marca que estao dentro da SUBQUERY,
    produtos        -- (SUBQUERY 'Apple' or 'Dell'): Seleciona o id na tabela marca onde o nome é 'Apple' ou 'Dell'.
WHERE 
    id_marca IN (SELECT id FROM marcas WHERE nome = 'Apple' or nome = 'Dell');


  -- LEFT JOIN E RIGHT JOIN:
SELECT                  -- LEFT JOIN  lista clientes que tem pedidos e os que nao tiverem estarao como NULL:
    clientes.nome,      -- Tabela_clientes.Campo_nome
    pedidos.valor_total -- Tabela_pedidos.Campo_valor_Total
    FROM 
        clientes
    LEFT JOIN pedidos ON 
    clientes.id = pedidos.id_cliente;

    SELECT               -- RIGHT JOIN lista somente os que tem valor associado na outra tabela:
    clientes.nome,      -- Tabela_clientes.Campo_nome
    pedidos.valor_total -- Tabela_pedidos.Campo_valor_Total
    FROM 
        clientes
    RIGHT JOIN pedidos ON 
    clientes.id = pedidos.id_cliente;


    -- FULL JOIN:
SELECT      -- FULL JOIN nao funciona no mysql.
    c.nome,
    p.valor_total
FROM
    clientes c
    FULL JOIN pedidos p ON c.id = p.id_cliente;

   -- Alternativa é usar o   LEFT JOIN + RIGHT JOIN:
SELECT clientes.nome, pedidos.valor_total 
FROM   clientes
LEFT JOIN pedidos ON clientes.id = pedidos.id_cliente

    UNION   -- UNION: uni as consultas

SELECT clientes.nome, pedidos.valor_total 
FROM   clientes
RIGHT JOIN pedidos ON clientes.id = pedidos.id_cliente;

   -- FUNÇOES AGREGADAS E AGRUPAMENTO DE DADOS:

        -- 1º Inserindo registros na tabela pedidos e itens_pedido:
 INSERT INTO pedidos (id_cliente, valor_total) VALUES
(4, 5500.00),
(5, 2000.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(3, 1, 1, 3500.00),
(3, 2, 1, 2000.00),
(4, 2, 1, 2000.00);

SELECT              -- Buscando as cidades da tabela clientes.
    cidade
FROM
    clientes
GROUP BY cidade;     -- GROUP BY: agrupa o conjuto de registros da coluna cidade da tabela clientes.

SELECT          -- Buscando as cidades da tabela clientes.
    cidade,
    COUNT(*) as naruto -- COUNT (*) as: Conta quantos registros existem para cada cidade,
FROM                           -- e renomeia essa contagem como naruto.
    clientes
GROUP BY cidade;

-- Criando um relatorio de media de vendas:
SELECT 
    DATE_FORMAT(data_pedido,'%Y-%M') as mes, -- Transfomei o formato de data tardicional da culuna data_pedido para somente ano/mes e o chame de mes.
    AVG(valor_total) as media_vendas         -- AVG: Retorna a média dos valores da coluna valor_total que se chamará media_vendas.
FROM                                         -- FROM: Tabela pedidos. 
    pedidos
GROUP BY mes;                                 --GROUP BY: agrupado pelo DATE_FORMAT(Ano-Mês) as mes.

-- Usando outra função equivalente:
SELECT SUM(valor_total) FROM pedidos; --SUM(valor_total): Soma todos os valores da coluna FROM tabela pedidos.
SELECT SUM(valor_total)/COUNT(valor_total) FROM pedidos; --SUM(valor_total)/COUNT(valor_total): soma e divide resutando na media.


--SELECIONANDO O MIN/MAX:
SELECT MIN(valor_total) as maior_pedido FROM pedidos;
SELECT MAX(valor_total) as maior_pedido FROM pedidos;


-- Criando um estoque com pedidos abaixo da media:
SELECT 
    nome,
    estoque
FROM
    produtos
WHERE 
    estoque <(SELECT AVG(estoque) FROM produtos);

-- Mostrando o valor total de venda de acordo com as cidades com o nome das cidades:
SELECT
    c.cidade,                       -- coluna cidade apelidada de c,
    SUM(p.valor_total) as total_vendas  -- somando(SUM) a tabela de pedidos chamada de p e chamando isso de Total_Vendas,
FROM
    clientes AS c                   -- tabela clientes apelidade de c
    INNER JOIN pedidos AS p ON c.id = p.id_cliente  -- juntando a tabela pedidos chamada de p, onde cliente.id = pedidos.id_cliente.
WHERE
    c.cidade IN ('São José dos Campos', 'Rio de Janeiro')   -- Onde cliente.cidade total de vendas nas cidades mencionadas.
GROUP BY
    c.cidade                          -- agrupados por cliente.cidade.
HAVING
    total_vendas < 7000;               -- HAVING: mostra somente os que estao abaixo de 7000.