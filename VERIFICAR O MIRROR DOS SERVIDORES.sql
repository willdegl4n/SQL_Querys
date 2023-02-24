---------------------------------------
-- VERIFICAR O MIRROR DOS SERVIDORES --
---------------------------------------

USE master 
GO

SELECT 
	db.name, 
	db.state_desc, 
	dm.mirroring_role_desc, 
	dm.mirroring_state_desc,
	dm.mirroring_safety_level_desc,
	dm.mirroring_partner_name, 
	dm.mirroring_partner_instance 
FROM sys.databases db
	INNER JOIN sys.database_mirroring dm
		ON db.database_id = dm.database_id
WHERE dm.mirroring_role_desc IS NOT NULL
ORDER BY db.name
GO