create procedure qp_rep_TOCLFreq_Title
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstSampleSet datetime,
 @LastSampleSet datetime
as
set transaction isolation level read uncommitted

select convert(varchar,@FirstSampleSet,120) + ' to ' + convert(varchar,@LastSampleSet,120) as 'From sample set:'

set transaction isolation level read committed


