---------------------------------
---- VERIFICAR ULTIMO BACKUP ----
---------------------------------

SELECT 
      FORMAT (restore_date,'dd/MM/yyyy') AS Ultima_Restauração ,
       database_name as Banco,
       bs.user_name as Usuário,
       bs.machine_name
FROM msdb.dbo.restorehistory rh 
  INNER JOIN msdb.dbo.backupset bs 
    on rh.backup_set_id=bs.backup_set_id
  INNER JOIN msdb.dbo.backupmediafamily bmf 
    on bs.media_set_id =bmf.media_set_id
    WHERE database_name in ('DADOSADV')
ORDER BY [rh].[restore_date] DESC