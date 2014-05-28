CREATE Procedure sp_Promote_FormLayout @ver varchar(9), @PWD varchar (11)
as
if @PWD <> 'PhilIsANerd' 
   begin
	Print 'Nice try Jackson... Good by....!'
	RETURN
   end

begin tran
   Update QualPro_Params
   set StrParam_Value = @ver
   where Param_id = 173
Commit tran

--Deleting previous old version "FormGenOld.exe"
exec master..xp_cmdshell 'del \\nrc00\c$\Winnt\system32\Repl\Export\scripts\Updates\Qualisys\formlayoutOld.exe'
--renaming current version to FormGenOld.exe
exec master..xp_cmdshell 'rename \\nrc00\c$\Winnt\system32\Repl\Export\scripts\Updates\Qualisys\formlayout.exe FormLayoutOld.exe'
--Moving new version into the correct place.
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\FormLayout.exe \\nrc00\c$\Winnt\system32\Repl\Export\scripts\Updates\Qualisys\'


