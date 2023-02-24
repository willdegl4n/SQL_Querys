--verificar feature memory-optimized tables

DECLARE    
@nome_banco       VARCHAR(256),    
@texto_script     NVARCHAR(MAX),    
@nome_objeto      VARCHAR(256),    
@tipo_objeto      VARCHAR(256)
DECLARE cur_databases CURSOR FOR SELECT distinct db.name
                                 FROM sys.databases db
                                 INNER JOIN sys.master_files mf ON db.database_id = mf.database_id
                                 WHERE db.state <> 6 -- OFFLINE
                                   AND mf.database_id > 6 AND mf.type = 0
BEGIN
    OPEN cur_databases
    FETCH cur_databases INTO @nome_banco
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @texto_script = 'USE ' + @nome_banco + ';
             SELECT ''' + @nome_banco + ''' as banco, SCHEMA_NAME(Schema_id) SchemaName,
             name TableName, durability_desc, create_date, modify_date
             FROM sys.tables
             where is_memory_optimized = 1'
        EXEC sp_executesql @texto_script
		FETCH cur_databases INTO @nome_banco
    END
    CLOSE cur_databases
    DEALLOCATE cur_databases
END