-- Verificar onde estão armazenadas as bases do servidor 

SELECT a.name AS 'Database'
	, b.name AS 'Nome Logico'
	, b.filename as 'Arquivo' 
FROM sys.sysdatabases a 
	INNER JOIN sys.sysaltfiles b
		ON a.dbid = b.dbid
ORDER BY a.name
