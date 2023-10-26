-- @fileIN file to compact
-- @fileRAR output rar file
-- sample:  exec [sp_CMD_WINRAR_compact] 'k:\folder\backup.rar', 'k:\foldeer\BAK20231026.bak'

create procedure [dbo].[sp_cmd_WINRAR_COMPACT](@fileIN nvarchar(1000), @fileRAR nvarchar(1000))
as 
begin
	-- Winrar in path C:\Program Files\WinRAR\winrar.exe
    set nocount on
    declare @cmd varchar(8000) = '""C:\Program Files (x86)\WinRAR\rar.exe" a "'+@fileIN+'" "'+@fileRAR+'""'
	  declare @back table (back nvarchar(max))
    insert into @back
    exec master.dbo.xp_cmdshell @command_string = @cmd
	select * from @back
end
