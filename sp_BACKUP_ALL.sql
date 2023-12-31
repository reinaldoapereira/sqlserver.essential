ALTER procedure [dbo].[sp_BACKUP_ALL] @path nvarchar(400)
as
begin
	declare @filedate nvarchar(30)
	declare @name nvarchar(400)
	declare @filename nvarchar(400)
	select @fileDate = convert(nvarchar(20), getdate(), 112) 
	begin try close _csrFyhlcm end try begin catch /* pass */ end catch
	begin try deallocate _csrFyhlcm end try begin catch /* pass */ end catch
	declare _csrFyhlcm cursor for  
		select name 
		from master.dbo.sysdatabases 
		where name not in ('master','model','msdb','tempdb')  
	open _csrFyhlcm   
	fetch next from _csrFyhlcm into @name   
	while @@FETCH_STATUS = 0   
	begin   
		set @fileName = @path + @name + '_' + @fileDate + '.bak'  
		backup database @name to disk = @fileName  
		fetch next from _csrFyhlcm into @name   
	end   
	begin try close _csrFyhlcm end try begin catch end catch
	begin try deallocate _csrFyhlcm end try begin catch /* pass */ end catch
end
