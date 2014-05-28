CREATE function dbo.QDE_GetDirectSampleunit(@strlithocode varchar(100))
returns int
as
begin

declare @Sampleunit_ID int

select top 1 @Sampleunit_ID = ss.sampleunit_ID
from scheduledmailing scm (NOLOCK), sentmailing sm (NOLOCK), SelectedSample ss, samplepop sp
where	scm.sentmail_ID = sm.sentmail_ID and
		scm.samplepop_ID = sp.samplepop_ID and
		sp.study_ID = ss.study_ID and
		sp.pop_ID = ss.pop_ID and
		ss.strUnitSelectType = 'D' and
		sm.strlithocode = @strlithocode


return @Sampleunit_ID

end


