Create Procedure sp_Promote_PCLGen @ver varchar(9), @PWD varchar (11)
as
if @PWD <> 'PhilIsANerd' 
   begin
	Print 'Nice try Jackson... Good by....!'
	RETURN
   end

--Moving new pclgen version onto NRCPCLGEN01
exec master..xp_cmdshell 'del \\nrcpclgen01\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen01\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen01\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN01 Done'
--Moving new pclgen version onto NRCPCLGEN02
exec master..xp_cmdshell 'del \\nrcpclgen02\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen02\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen02\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN02 Done'
--Moving new pclgen version onto NRCPCLGEN03
exec master..xp_cmdshell 'del \\nrcpclgen03\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen03\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen03\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN03 Done'
--Moving new pclgen version onto NRCPCLGEN05
exec master..xp_cmdshell 'del \\nrcpclgen05\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen05\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen05\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN05 Done'
--Moving new pclgen version onto NRCPCLGEN07
exec master..xp_cmdshell 'del \\nrcpclgen07\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen07\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen07\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN07 Done'
--Moving new pclgen version onto NRCPCLGEN08
exec master..xp_cmdshell 'del \\nrcpclgen08\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen08\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen08\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN08 Done'
--Moving new pclgen version onto NRCPCLGEN09
exec master..xp_cmdshell 'del \\nrcpclgen09\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen09\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen09\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN09 Done'
--Moving new pclgen version onto NRCPCLGEN10
exec master..xp_cmdshell 'del \\nrcpclgen10\c$\Progra~1\PCLGen\PCLGenOld.exe'
exec master..xp_cmdshell 'rename \\nrcpclgen10\c$\Progra~1\PCLGen\PCLGen.exe PCLGenOld.exe'
exec master..xp_cmdshell 'copy \\helios\support$\qualisys\components\QualiSysExes\PCLGen.exe \\nrcpclgen10\c$\Progra~1\PCLGen'
Print 'NRCPCLGEN10 Done'


