SELECT
CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server,
msdb.dbo.backupset.database_name,
msdb.dbo.backupset.backup_start_date,
msdb.dbo.backupset.backup_finish_date,
msdb.dbo.backupset.expiration_date,
CASE msdb..backupset.type
WHEN 'D' THEN 'Database'
WHEN 'L' THEN 'Log'
END AS backup_type,
msdb.dbo.backupset.backup_size,
msdb.dbo.backupmediafamily.logical_device_name,
msdb.dbo.backupmediafamily.physical_device_name,
msdb.dbo.backupset.name AS backupset_name,
msdb.dbo.backupset.description
FROM msdb.dbo.backupmediafamily
INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7)
--and msdb.dbo.backupset.database_name='IngramDW'
ORDER BY
msdb.dbo.backupset.database_name,
msdb.dbo.backupset.backup_finish_date


----------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
-- Query para conferir o histórico de Backups que foram executados
--------------------------------------------------------------------------------------------------------------------------------
SELECT
database_name, name, backup_start_date, backup_finish_date, datediff(mi, backup_start_date, backup_finish_date) [tempo (min)],
position, first_lsn, last_lsn, server_name, recovery_model, isnull(logical_device_name, ' ') logical_device_name, device_type,
type, cast(backup_size/1024/1024 as numeric(15,2)) [Tamanho (MB)], B.is_copy_only
FROM msdb.dbo.backupset B
INNER JOIN msdb.dbo.backupmediafamily BF ON B.media_set_id = BF.media_set_id
where backup_start_date >= dateadd(hh, -24 ,getdate())
and type in ('D','I','L')
-- and database_name = 'NomeDatabase'
order by backup_start_date desc