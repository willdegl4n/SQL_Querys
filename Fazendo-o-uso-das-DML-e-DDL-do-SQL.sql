CREATE DATABASE ENGINEER;
GO

USE ENGINEER;
GO

-- CRIAÇÃO DAS TABELAS EM SQL SERVER
-------------------------------------
	------- CRIANDO A TABELA PESSOA
		IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='pessoa' AND xtype='U')
		BEGIN
			CREATE TABLE pessoa (
				pessoaid INT,
				nome VARCHAR(255),
				sobrenome VARCHAR(255)
			);
		END;
		GO

	------- CRIANDO A TABELA ENDEREÇO
		IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='endereco' AND xtype='U')
		BEGIN
			CREATE TABLE endereco (
				enderecoid INT, 
				pessoaid INT, 
				cidade VARCHAR(255), 
				estado VARCHAR(255)
			);
		END;
		GO


-- CRIAÇÃO DAS TABELAS EM POSTGRESQL
-------------------------------------
	------- CRIANDO A TABELA PESSOA
		CREATE TABLE IF EXISTS pessoa (
			pessoaid INT,
			nome VARCHAR(255),
			sobrenome VARCHAR(255)
		);

	------- CRIANDO A TABELA ENDEREÇO
		CREATE TABLE endereco (
			enderecoid INT, 
			pessoaid INT, 
			cidade VARCHAR(255), 
			estado VARCHAR(255)
		);

TRUNCATE TABLE pessoa;
GO

INSERT INTO pessoa (pessoaid, nome, sobrenome) VALUES (1, 'SQL', 'Dicas');
INSERT INTO pessoa (pessoaid, nome, sobrenome) VALUES (2, 'Data', 'Engineer');
GO

SELECT * FROM pessoa;
GO

TRUNCATE TABLE endereco;
GO

INSERT INTO endereco (enderecoid, pessoaid, cidade, estado) VALUES (1, 1, 'Brasilia','DF');
INSERT INTO endereco (enderecoid, pessoaid, cidade, estado) VALUES (2, 2, 'Valparaiso','GO');
GO

SELECT * FROM endereco;

-- INNER JOIN - juntando os dados
SELECT p.pessoaid, p.nome, p.sobrenome, e.enderecoid, e.cidade, e.estado 
FROM pessoa p INNER JOIN endereco e ON p.pessoaid = e.pessoaid;


-----------------------------------------------------------------
-- ALTERAÇÃO QUE ANALISTAS, ENGENHEIROS E CIENTISTAS DE DADOS  --
-- DEVEM CONHECER COMO A "PALMA DA MÃO"						   --
-----------------------------------------------------------------


-- RENAME - RENOMEAR A TABELA 
ALTER TABLE endereco RENAME TO 'end';  -- usando Postgre
EXEC sp_rename 'end', 'endereco';      -- usando SQL Server


-- TRUNCATE - Limpa todos os dados e metadados da tabela
TRUNCATE TABLE tabela;

-- ALTER - Adicionar uma nova coluna
ALTER TABLE pessoa ADD COLUMN email varchar(255); -- usando Postgre
ALTER TABLE pessoa ADD email varchar(255);		  -- usando SQL Server
ALTER TABLE pessoa ADD teste varchar(255);		  -- usando SQL Server


-- DROP - exclui a coluna 
ALTER TABLE pessoa DROP COLUMN teste;

--INSERT - inserir um novo registro
INSERT INTO pessoa(pessoaid, nome, sobrenome, email) 
	   VALUES (3, 'Willdeglan', 'DataBase Administrator', 'contato@gmail.com');

--DELETE - Remover registro da tabela
DELETE FROM pessoa WHERE pessoaid = '1';

-- UPDADE - atualiza os dados de um registro na tabela
UPDATE pessoa SET email = 'contato@gmail.com.br' WHERE nome='data';
UPDATE pessoa SET pessoaid = 1 WHERE nome='willdeglan';

-- Verificando nossa tabela
SELECT p.pessoaid, p.nome, p.sobrenome, p.email, e.enderecoid, e.cidade, e.estado 
FROM pessoa as p inner JOIN endereco as e ON p.pessoaid = e.pessoaid;


SELECT * FROM endereco;


SELECT * FROM pessoa;
