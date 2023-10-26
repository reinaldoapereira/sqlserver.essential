create procedure [dbo].[sp_cmd_DIR_2TAB] (@folder nvarchar(1000), @tab nvarchar(200)) as
begin

	begin try drop table [~dirTbd43] end try begin catch /*pass*/ end catch

	create table [REI.SISTEMA].dbo.[~dirTbd43]  
	(	Number int identity (1,1),
		dt_Create date,
		[nType] bigint,
		[Type] nvarchar(30),
		Bytes bigint,
		[Name] nvarchar(400),
		Folder nvarchar(4000))

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

	insert into [~dirTbd43] (dt_Create, nType, Bytes, Name) (select dt_create,[type],Bytes,[file] from @endtab)

	set @run = 'begin try drop table '+@tab+'  end try begin catch /*pass*/ end catch'
	execute(@run)

	set @run = '
		create table '+@tab+' 
		(	Number int identity (1,1),
			dt_Create date,
			nType bigint,
			[Type] nvarchar(30),
			Bytes bigint,
			[Name] nvarchar(400),
			Folder nvarchar(4000))'
	execute(@run)

	set @run = 'insert into '+@tab+'(dt_Create,nType,Bytes,[Name]) (select dt_Create,nType,Bytes,[Name] from [~dirTbd43]);'
	execute(@run)

	begin try drop table [~dirTbd43] end try begin catch /*pass*/ end catch

	set @run = 'update '+@tab+'  set [type]=''File'' where [ntype]=1'
	execute(@run)

	set @run = 'update '+@tab+'  set [type]=''Folder'' where [ntype]=0'
	execute(@run)

	set @run = 'update '+@tab+'  set folder='+char(39)+@folder+char(39)
	execute(@run)

end
