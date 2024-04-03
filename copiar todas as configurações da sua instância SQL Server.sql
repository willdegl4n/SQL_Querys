-- Uma excelente maneira de copiar todas as configurações da sua instância SQL Server de uma vez só, já em formato de execução.

DECLARE @Configurations VARCHAR(MAX) = '';
-- Habilitar as opções avançadas no início
SET @Configurations = 'EXEC sp_configure ''show advanced options'', 1;' + CHAR(13) + CHAR(10) +
                     'RECONFIGURE;' + CHAR(13) + CHAR(10);
-- Todas as configurações disponíveis
SELECT @Configurations = @Configurations +
   'EXEC sp_configure ''' + [name] + ''', ' + CAST([value] AS VARCHAR(MAX)) + ';' + CHAR(13) + CHAR(10)
FROM sys.configurations;
-- Habilitar as opções avançadas ao final
SET @Configurations = @Configurations +
                     'EXEC sp_configure ''show advanced options'', 0;' + CHAR(13) + CHAR(10) +
                     'RECONFIGURE;' + CHAR(13) + CHAR(10);
-- Imprime as configurações
PRINT @Configurations;
