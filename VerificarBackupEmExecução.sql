/*  Monitorar as nossas inst�ncias em tempo real � um papel importante no 
	controle do nosso ambiente de trabalho e para manter a alta disponibilidade 
	das bases de dados sempre ativas e funcionais. Quando trabalhamos com grande 
	volume de dados e backups grandes, muitas vezes os backups levam tempo para 
	serem realizados. No script que preparei abaixo, voc� consegue verificar qual 
	backup est� sendo realizado no SQL Server e quanto tempo estimado para o 
	t�rmino desta execu��o. Ao executar este script, voc� ter� acesso em tempo 
	real a diversas informa��es relevantes de um backup em execu��o. 
*/

-- Script minificado (utilize o poor sql para organizar o script)
 SELECT r.session_id
		,r.command
		,CONVERT(NUMERIC(6,2),r.percent_complete) AS [Percent Complete]
		,CONVERT(VARCHAR(20),DATEADD(ms,r.estimated_completion_time,GetDate()),20) AS [Estimated Completion Time]
		,CONVERT(NUMERIC(6,2),r.total_elapsed_time/1000.0/60.0) AS [Elapsed Min]
		,CONVERT(NUMERIC(6,2),r.estimated_completion_time/1000.0/60.0) AS [Estimated Min Left]
		,CONVERT(VARCHAR(1000),(SELECT SUBSTRING(text,r.statement_start_offset/2,
			CASE WHEN r.statement_end_offset=-1
				 THEN 1000 
				 ELSE(r.statement_end_offset-r.statement_start_offset)/2 
				 END)
				 FROM sys.dm_exec_sql_text(sql_handle)))
FROM sys.dm_exec_requests r 
WHERE command IN('BACKUP DATABASE','BACKUP LOG')