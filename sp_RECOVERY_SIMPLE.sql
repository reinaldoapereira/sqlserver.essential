-- Convert all user databases to recovery simple mode
create procedure [dbo].[sp_RECOVERY_SIMPLE]
as
begin
	begin try drop table ##salkdfjsimples end try begin catch /**/ end catch
	create table ##salkdfjsimples (banco nvarchar(100))
	insert into ##salkdfjsimples (banco) (SELECT name FROM sys.databases where name not in ('master','tempdb','model','msdb','DWDiagnostics','DWConfiguration','DWQueue'))
	declare @banco nvarchar(100)
	begin try close	_csrsalkdfj end try begin catch /**/ end catch
	begin try deallocate _csrsalkdfj end try begin catch /**/ end catch
	declare @cmd nvarchar(2000)
	declare _csrsalkdfj cursor for select banco from ##salkdfjsimples
	open _csrsalkdfj
	fetch next from _csrsalkdfj into @banco
	while @@FETCH_STATUS=0
	begin
		set @cmd = 'USE [master]; ALTER DATABASE ['+@banco+'] SET RECOVERY SIMPLE;'  
		print 'Change '+@banco
		execute(@cmd)
		fetch next from _csrsalkdfj into @banco
	end
	begin try close	_csrsalkdfj end try begin catch /**/ end catch
	begin try deallocate _csrsalkdfj end try begin catch /**/ end catch
	begin try drop table ##salkdfjsimples end try begin catch /**/ end catch
end
