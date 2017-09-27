/*
	RTP-4840 HCAHPS Export Double-Counting Ineligibles
	
	Deployed with an Emergency Change Request - not to be included in a regular release

	Dave Gilsdorf

*/
use qp_prod
go
/*
Business Purpose:
This procedure is used to calculate the number of eligible discharges.  It
is used IN the header record of the CMS export

Created:	06/22/2006 by DC

Modified:
			4/15/2010 MWB: changed logic to count distinct pop_ID only instead of pop_ID,enc_ID
			(which esentially counted distinct Enc_IDs)
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table


*/

ALTER PROCEDURE [dbo].[Export_HCAHPSSampleunitAvailableCount]
 @Sampleunit_id INT,
    @startDate DATETIME,
    @EndDate DATETIME
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select count(*)
from (select distinct pop_id
  from EligibleEncLog
  where sampleunit_id=@sampleunit_id
   and SampleEncounterDate between @startDate and dateadd(s,-1,dateadd(d,1,@EndDate))
   --and IneligibleAfterDRGUpdate=0  -- IneligibleAfterDRGUpdate counts are removed in qp_comments..DCL_ExportFileCMSAvailableCount so we want to include them here so that when they're remove there the count will be accurate.
   ) p
GO