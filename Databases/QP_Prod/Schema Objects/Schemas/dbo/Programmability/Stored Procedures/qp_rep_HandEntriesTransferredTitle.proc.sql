CREATE procedure dbo.qp_rep_HandEntriesTransferredTitle
@Associate varchar(50),
@StartDate datetime,
@EndDate datetime
as
set transaction isolation level read uncommitted
Select convert(varchar(10),@startdate,101) + ' to ' + convert(varchar(10),@enddate,101) as 'From'

set transaction isolation level read committed


