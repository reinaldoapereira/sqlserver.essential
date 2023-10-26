
create procedure [dbo].[sp_cmd_DIR] (@folder nvarchar(1000)) as
begin
    declare @run varchar(8000) = 'dir/ -C /4 /N "' + @folder + '"'
	declare @back table (line int identity(1,1), back varchar(max))
    declare @endtab table (line bigint identity(1,1), dt_create datetime, [type] bit, Bytes bigint, [file] varchar(255))
    insert into  @back exec master.dbo.xp_cmdshell @command_string = @run
    insert into @endtab(dt_create, [type], Bytes, [file])
		select convert(datetime, left(back, 17), 103) as dt_create, 0 as [type], 0 as lenBytes, substring(back, 37, len(back)) as [file]
		from @back 
		where back is not null and line < (select max(line) from @back)-2 and back like '%<DIR>%' and substring(back, 37, len(back)) not in ('.', '..')
		order by [file]
    insert into @endtab (dt_create, [type], Bytes, [file])
		select convert(datetime, left(back, 17), 103) as dt_create, 1 as [type], ltrim(substring(ltrim(back), 18, 19)) as Qt_Tamanho,
			substring(back, charindex(ltrim(substring(ltrim(back), 18, 19)), back, 18) + len(ltrim(substring(ltrim(back), 18, 19))) + 1, len(back)) as dt_create
		from @back
		where back is not null and line >= 6 and line < (select max(line) from @back)-2 and back not like '%<DIR>%'
		order by back
    select * from  @endtab
end
