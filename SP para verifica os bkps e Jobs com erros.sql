-- Script para rodar em SQL Server, para verificar se houveram backups com sucesso ou com falha nos jobs. 
-- Retornar todos os backups que tiveram sucesso ou falha durante os últimos 7 dias.

-------------------------------------------------------------------------------
-- Inicio do Script para criação da SP que verifica os bkps e Jobs
-------------------------------------------------------------------------------

CREATE PROCEDURE sp_backupsf AS
BEGIN
 -- Parte 1: Seleciona execuções bem-sucedidas nos últimos 7 dias
	 SELECT 
		 j.name AS 'Nome do Job',
		 'SUCESSO' AS 'Status de Execução',
		 h.run_date AS 'Data da Execução',
		 h.run_duration AS 'Duração da Execução (segundos)'
	 FROM 
		dbo.sysjobs j
			INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
	 WHERE 
		 j.name LIKE '%Backup%' 
			 AND h.run_status = 1
			 AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - 7, 112));

 -- Parte 2: Seleciona execuções com falha nos últimos 7 dias
	 SELECT 
		 j.name AS 'Nome do Job',
		 'FALHOU' AS 'Status de Execução',
		 h.run_date AS 'Data da Execução',
		 h.run_duration AS 'Duração da Execução (segundos)'
	 FROM 
		dbo.sysjobs j
			 INNER JOIN dbo.sysjobhistory h ON j.job_id = h.job_id
	 WHERE 
		j.name LIKE '%Backup%' 
			AND h.run_status <> 1
			AND h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE() - 7, 112));
END;
-- fim do script de criação da SP 
--------------------------------------------------------------------------------

-- Para executar a sp_backupsf, inserir a consulta abaixo:
USE msdb
GO

EXEC sp_backupsf
GO

---------------------------------------------------------------------------------
-- Para deletar a procedure:
DROP PROCEDURE sp_backupsf
GO
