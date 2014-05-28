/*
select dbo.GetHCAHPSEstResponseRate (82440)

Created by:	Michael Beltz 
			9/24/08

Purpose:	called from QCL_CalcTargets if default response rate is 0.  it looks up the response rate
			from the medicarelookup table
*/
Create function GetHCAHPSEstResponseRate (@Sampleunit_ID int)
RETURNS int
as
begin

	Declare @estRespRate int
	set @estRespRate = 0

	select distinct @estRespRate = ml.estRespRate * 100
	from sampleunit su, sufacility sf, medicarelookup ml
	where	su.sufacility_ID = sf.sufacility_ID and
			ml.medicarenumber = sf.medicarenumber and
			su.bitHCAHPS = 1 and 
			su.dontsampleUnit = 0 and
			su.sampleunit_ID = @Sampleunit_ID

	if @@Rowcount = 0 return 1
	if @estRespRate = 0 return 1
    if @estRespRate is null return 1

	return @estRespRate

End


