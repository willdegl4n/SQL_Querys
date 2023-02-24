---- Verificar as conexões ativas ----
SELECT 
	DB_NAME(dbid) as BancoDeDados, 
	COUNT(dbid) as QtdeConexoes,
	loginame as Login
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame