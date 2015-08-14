CREATE PROCEDURE [dbo].[CheckForBlankBreakoffs]
AS
-- if we're processing a Breakoff disposition (disposition_id=11) and there are no answered questions, log a Blank Phone Survey disposition too (disposition_id=49)
DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -4, GETDATE());

declare @Breakoffs table (Samplepop_id int, Disposition_id int, questionform_id int, sentmail_id int, numAnswers int)

insert into @breakoffs
SELECT DISTINCT PKey1 as Samplepop_id, Pkey2 as Disposition_id, qf.questionform_id, qf.sentmail_id, 0 as numAnswers
FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
inner join Questionform qf on eq.pkey1=qf.samplepop_id
WHERE eq.ExtractFileID IS NULL 
AND eq.EntityTypeID = 14 
AND eq.Pkey2=11 
and eq.Created > @MinDate
and qf.datReturned is not null

update bo set numAnswers=sub.numAnswers
from @breakoffs bo
inner join (select qr.questionform_id, count(*) as numAnswers
			from @breakoffs bo
			inner join questionresult qr on bo.questionform_id=qr.questionform_id
			where qr.intresponseval>=0
			group by qr.questionform_id) sub
		on bo.questionform_id=sub.questionform_id

insert into DispositionLog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst,bitExtracted)
select bo.sentmail_id, bo.samplepop_id, 49 as disposition_id, 12 as receipttype_id, getdate() as datlogged, 'CheckForBlankBreakoffs' as Loggedby, 0,0,0
from @breakoffs bo
where bo.numAnswers=0