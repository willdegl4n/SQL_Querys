use master
go

create database DBA
go

use DBA
go

create table monit_size (
	 NomeDoBanco varchar(128) 
	,TamanhoArquivoDataMB NUMERIC(10,2)
	,TamanhoArquivoLogMB NUMERIC(10,2)
	,DataHoraDaColeta smalldatetime
);
go

--truncate table dba.dbo.monit_size

select * from dba.dbo.monit_size
go


INSERT INTO dba.dbo.monit_size 
select
    db.name as NomeDoBanco
    ,(select CONVERT(NUMERIC(10,2), SUM(size) * 8.0 / 1024.0) from sys.master_files where type = 0 and sys.master_files.database_id = db.database_id) TamanhoArquivoDataMB
    ,(select CONVERT(NUMERIC(10,2), SUM(size) * 8.0 / 1024.0) from sys.master_files where type = 1 and sys.master_files.database_id = db.database_id) TamanhoArquivoLogMB
	,CONVERT (smalldatetime, GETDATE()) DataHoraDaColeta
from sys.databases db
where db.name NOT IN ('master', 'tempdb', 'model', 'msdb')
go


select top(10) NomeDoBanco, TamanhoArquivoDataMB, TamanhoArquivoLogMB, DataHoraDaColeta
from dba.dbo.monit_size 
--where NomeDoBanco IN ('dba','tee')
order by 4,1 
desc
go

/*
select NomeDoBanco, TamanhoArquivoDataMB, TamanhoArquivoLogMB, DataHoraDaColeta
from tee.dbo.monit_size 
--where NomeDoBanco = 'dba'
order by 1,4 desc
go
*/
