Create Procedure QCL_SelectMedicarePropCalcType (@MedicarePropCalcType_id int)
as
begin
	select MedicarePropCalcType_ID,MedicarePropCalcTypeName
	from  MedicarePropCalcTypes
	where MedicarePropCalcType_ID = @MedicarePropCalcType_id
end


