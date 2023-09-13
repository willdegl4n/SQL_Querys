/* LISTA USUARIOS ORFÃOS QUE VIERAM DE DATABASES RESTAURADOS E NAO SAO USUARIOS DA INSTANCIA */
USE master
GO

SET LANGUAGE brazilian
GO

/* CRIAÇÃO TABELA TEMPORARIA */

IF OBJECT_ID('tempdb..#TodosUsuariosDatabase') IS NOT NULL	DROP TABLE #TodosUsuariosDatabase;
IF OBJECT_ID('tempdb..#VerificaRoles') IS NOT NULL			DROP TABLE #VerificaRoles;
IF OBJECT_ID('tempdb..#ListaTodosDatabases') IS NOT NULL	DROP TABLE #ListaTodosDatabases;	

CREATE TABLE #ListaTodosDatabases(
			[NomeDatabase] [nvarchar](128) NULL
			,[DatabasePrincipalId] [int] NULL
			,[sysadmin] [varchar](3) NOT NULL
			,[UsuarioDeInstancia] [sysname] NOT NULL
			,[UsuarioDoDatabase] [sysname] NULL
			,[UsuarioOrfao] [varchar](40) NOT NULL
			,[DescricaoTipoUsuarioInstancia] [nvarchar](60) NULL
			,[DescricaoTipoUsuarioDatabase] [nvarchar](60) NULL
			,[TipoUsuarioInstancia] [char](1) NOT NULL
			,[TipoUsuarioDatabase] [char](1) NULL
			,[UsuarioHabilitadoInstancia] [varchar](33) NOT NULL
			,[DatacriaçãoInstancia] [datetime] NOT NULL
			,[DataUltimaModificacaoInstancia] [datetime] NOT NULL
			,[DatacriaçãoDatabase] [datetime] NULL
			,[DataUltimaModificacaoDatabase] [datetime] NULL
			,[DefaultDatabaseNameInstancia] [sysname] NULL
			,[DefaultDatabaseName] [varchar](3) NOT NULL
			,[is_fixed_role] [bit] NOT NULL
			,[type] [char](4) NULL
			,[permission_name] [nvarchar](128) NULL
			,[SIDInstancia] [varbinary](85) NULL
			,[SIDDatabase] [varbinary](85) NULL
			,DataCriacaoUsuario datetime
			,DataAlteracaoUsuario datetime
			,[name] [sysname] NULL
	) ON [PRIMARY];

CREATE TABLE #TodosUsuariosDatabase(
			[NomeDatabase] [nvarchar](128) NULL
			,[DatabasePrincipalId] [int] NULL
			,[sysadmin] [varchar](3)  NULL
			,[UsuarioDeInstancia] [sysname] NOT NULL
			,[UsuarioDoDatabase] [sysname] NULL
			,[UsuarioOrfao] [varchar](40) NOT NULL
			,[DescricaoTipoUsuarioInstancia] [nvarchar](60) NULL
			,[DescricaoTipoUsuarioDatabase] [nvarchar](60) NULL
			,[TipoUsuarioInstancia] [char](1) NOT NULL
			,[TipoUsuarioDatabase] [char](1) NULL
			,[UsuarioHabilitadoInstancia] [varchar](33) NOT NULL
			,[DatacriaçãoInstancia] [datetime] NOT NULL
			,[DataUltimaModificacaoInstancia] [datetime] NOT NULL
			,[DatacriaçãoDatabase] [datetime] NULL
			,[DataUltimaModificacaoDatabase] [datetime] NULL
			,[DefaultDatabaseNameInstancia] [sysname] NULL
			,[DefaultDatabaseName] [varchar](3) NOT NULL
			,[is_fixed_role] [bit] NOT NULL
			,[SIDInstancia] [varbinary](85) NULL
			,[SIDDatabase] [varbinary](85) NULL
			,DatacriacaoUsuario datetime
			,dataAlteracaoUsuario datetime
		) ON [PRIMARY];

CREATE TABLE #VerificaRoles(
			[NomeDatabase] [nvarchar](128) NULL
			,[DatabasePrincipalId] [int] NULL
			,[sysadmin] [varchar](3) NOT NULL
			,[UsuarioDeInstancia] [sysname] NOT NULL
			,[UsuarioDoDatabase] [sysname] NULL
			,[UsuarioOrfao] [varchar](40) NOT NULL
			,[DescricaoTipoUsuarioInstancia] [nvarchar](60) NULL
			,[DescricaoTipoUsuarioDatabase] [nvarchar](60) NULL
			,[TipoUsuarioInstancia] [char](1) NOT NULL
			,[TipoUsuarioDatabase] [char](1) NULL
			,[UsuarioHabilitadoInstancia] [varchar](33) NOT NULL
			,[DatacriaçãoInstancia] [datetime] NOT NULL
			,[DataUltimaModificacaoInstancia] [datetime] NOT NULL
			,[DatacriaçãoDatabase] [datetime] NULL
			,[DataUltimaModificacaoDatabase] [datetime] NULL
			,[DefaultDatabaseNameInstancia] [sysname] NULL
			,[DefaultDatabaseName] [varchar](3) NOT NULL
			,[is_fixed_role] [bit] NOT NULL
			,[type] [char](4) NULL
			,[permission_name] [nvarchar](128) NULL
			,[SIDInstancia] [varbinary](85) NULL
			,[SIDDatabase] [varbinary](85) NULL
			,DataCriacaoUsuario datetime
			,DataAlteracaoUsuario datetime 
		) ON [PRIMARY];  	  
 
/* POPULANDO AS TABELAS TEMPORÁRIAS */
EXEC sp_MSForEachDB 'USE [?];

;WITH 
  usuariosInstancia	AS ( SELECT * FROM sys.server_principals WHERE NAME not  like ''%#%'')
 ,UsariosOrfaos	AS     ( SELECT * FROM sys.database_principals)


 INSERT INTO  #TodosUsuariosDatabase
 SELECT DB_NAME() AS NomeDatabase
       ,orfao.principal_id AS DatabasePrincipalId
	   ,null [sysadmin] 
       ,instancia.NAME AS UsuarioDeInstancia
       ,Orfao.NAME AS UsuarioDoDatabase
       ,CASE WHEN orfao.NAME IS NULL THEN ''Usuário Orfão - Sem Login Vinculado'' ELSE ''Usuario tem Login vinculado na Instancia'' END UsuarioOrfao
       ,instancia.type_desc AS DescricaoTipoUsuarioInstancia
       ,orfao.type_desc AS DescricaoTipoUsuarioDatabase
       ,instancia.type AS TipoUsuarioInstancia,orfao.type TipoUsuarioDatabase
       ,CASE WHEN  instancia.is_disabled =1 THEN ''Usuario Desabilitado na Instancia'' ELSE ''Usuario Habilitado na Instancia'' END UsuarioHabilitadoInstancia
       ,instancia.create_date AS DatacriaçãoInstancia
       ,instancia.modify_date AS DataUltimaModificacaoInstancia
       ,orfao.create_date AS DatacriaçãoDatabase
       ,orfao.modify_date AS DataUltimaModificacaoDatabase
       ,instancia.default_database_name AS DefaultDatabaseNameInstancia
       ,''N/A''  AS DefaultDatabaseName
       ,instancia.is_fixed_role 
       ,instancia.sid SIDInstancia,orfao.sid SIDDatabase 
	   ,users.createdate
	   ,users.updatedate
 FROM usuariosInstancia Instancia 
		LEFT JOIN UsariosOrfaos Orfao ON instancia.NAME collate Latin1_General_100_CI_AS_KS_WS = orfao.NAME collate Latin1_General_100_CI_AS_KS_WS 
		LEFT JOIN  sys.sysusers Users ON orfao.name = users.name
 WHERE instancia.NAME NOT LIKE ''NT SERVICE\%''
		AND instancia.NAME NOT LIKE ''NT AUTHORITY\%''
		AND instancia.NAME NOT LIKE ''##%''
		AND instancia.TYPE_DESC <> ''SERVER_ROLE''
		AND instancia.NAME <> ''sa'' '



INSERT INTO #VerificaRoles
 SELECT NomeDatabase
       ,DatabasePrincipalId
       ,CASE WHEN s.sysadmin = '1' THEN 'SIM' ELSE 'NÃO' END [sysadmin] 
       ,UsuarioDeInstancia
       ,UsuarioDoDatabase
       ,UsuarioOrfao
       ,DescricaoTipoUsuarioInstancia
       ,DescricaoTipoUsuarioDatabase
       ,TipoUsuarioInstancia
       ,TipoUsuarioDatabase
       ,UsuarioHabilitadoInstancia
       ,DatacriaçãoInstancia
       ,DataUltimaModificacaoInstancia
       ,DatacriaçãoDatabase
       ,DataUltimaModificacaoDatabase
       ,DefaultDatabaseNameInstancia
       ,DefaultDatabaseName
       ,is_fixed_role 
	   ,sp.type
	   ,sp.permission_name
       ,SIDInstancia
       ,SIDDatabase 
	   ,createdate AS DataCriacaoUsuario
	   ,updatedate AS DataAlteracaoUsuario
 FROM #TodosUsuariosDatabase AS P 
		LEFT JOIN sys.syslogins AS s			ON p.SIDInstancia = s.sid
		LEFT JOIN sys.server_permissions AS sp	ON p.DatabasePrincipalId = sp.grantee_principal_id
WHERE p.DescricaoTipoUsuarioInstancia IN ('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP')
-- Logins que não são logins de processo
		AND p.UsuarioDeInstancia NOT LIKE '##%'
ORDER BY DescricaoTipoUsuarioInstancia,p.UsuarioDeInstancia


INSERT INTO #ListaTodosDatabases
SELECT	NomeDatabase
		,DatabasePrincipalId
		,[sysadmin] 
		,UsuarioDeInstancia
		,UsuarioDoDatabase
		,UsuarioOrfao
		,DescricaoTipoUsuarioInstancia
		,DescricaoTipoUsuarioDatabase
		,TipoUsuarioInstancia
		,TipoUsuarioDatabase
		,UsuarioHabilitadoInstancia
		,DatacriaçãoInstancia
		,DataUltimaModificacaoInstancia
		,DatacriaçãoDatabase
		,DataUltimaModificacaoDatabase
		,DefaultDatabaseNameInstancia
		,DefaultDatabaseName
		,vr.is_fixed_role 
		,vr.type
		,vr.permission_name
		,SIDInstancia
		,SIDDatabase 
		,PRole.name 
		,DataCriacaoUsuario
		,DataAlteracaoUsuario
FROM #VerificaRoles VR
		/*database user*/
		left join sys.server_principals		AS ulogin	(nolock) ON vr.DatabasePrincipalId = ulogin.principal_id
		/*Login accounts*/
		left JOIN sys.database_principals	AS PMember  (nolock) ON PMember.[sid] = ulogin.[sid]
		left JOIN sys.database_role_members AS DRM		(nolock) ON PMember.principal_id = drm.member_principal_id
		left JOIN sys.database_principals	AS PRole	(nolock) ON PRole.principal_id = drm.role_principal_id
ORDER BY prole.name



SELECT 
	 NomeDatabase			AS NomeDoBanco
	,UsuarioDeInstancia		AS UsuarioDeInstancia
	,UsuarioDoDatabase		AS UsuarioDoBanco
--	,DataCriacaoUsuario		AS DatadeCriacao
--	,DataAlteracaoUsuario
	,CASE 
		WHEN usuariodeinstancia IS NULL AND		usuariododatabase IS NOT NULL	THEN 'Existe somente no Database'
		WHEN usuariodeinstancia IS NOT NULL AND usuariododatabase IS NULL		THEN 'Existe somente na Instancia'
		WHEN usuariodeinstancia IS NOT NULL AND usuariododatabase IS NOT NULL	THEN 'Existe na Instancia e no Database'
	END LocalDoUsuario 
FROM #ListaTodosDatabases
ORDER BY UsuarioOrfao DESC, NomeDatabase