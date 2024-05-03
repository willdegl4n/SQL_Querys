/*
	Uma excelente maneira de copiar todas as configura��es da sua 
	inst�ncia SQL Server de uma vez s�, j� em formato de execu��o.
*/

DECLARE @configuracoes VARCHAR(MAX) = '';

-- Habilitar as op��es avan�adas no in�cio
SET @configuracoes = 'EXEC sp_configure ''show advanced options'', 1;' + CHAR(13) + CHAR(10) +
 'RECONFIGURE;' + CHAR(13) + CHAR(10);

-- Todas as configura��es dispon�veis
SELECT @configuracoes = @configuracoes +
 'EXEC sp_configure ''' + [name] + ''', ' + CAST([value] AS VARCHAR(MAX)) + ';' + CHAR(13) + CHAR(10)
FROM sys.configurations;

-- Habilitar as op��es avan�adas ao final
SET @configuracoes = @configuracoes +
 'EXEC sp_configure ''show advanced options'', 0;' + CHAR(13) + CHAR(10) +
 'RECONFIGURE;' + CHAR(13) + CHAR(10);

-- Imprime as configura��es
PRINT @configuracoes;