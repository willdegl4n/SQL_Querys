-- VERIFICAR INFORMAÇÕES DAS BASES
SELECT
    @@SERVERNAME as Servidor
	,@@SERVICENAME as Instancia
	,db.name as NomeDoBanco
    ,(select CONVERT(NUMERIC(10,2), SUM(size) * 8.0 / 1024.0) from sys.master_files where type = 0 and sys.master_files.database_id = db.database_id) TamanhoArquivoDataMB
    ,(select CONVERT(NUMERIC(10,2), SUM(size) * 8.0 / 1024.0) from sys.master_files where type = 1 and sys.master_files.database_id = db.database_id) TamanhoArquivoLogMB
	,CONVERT (smalldatetime, GETDATE()) DataHoraDaColeta
FROM sys.databases db
WHERE db.name NOT IN ('master', 'tempdb', 'model', 'msdb')
GO

/*
Servidor	instancia		NomeDoBanco		TamanhoArquivoDataMB	TamanhoArquivoLogMB		DataHoraDaColeta
SERVsql01	MSSQLSERVER		Vendas			3317.88					3634.00					2024-05-13 16:28:00
*/
