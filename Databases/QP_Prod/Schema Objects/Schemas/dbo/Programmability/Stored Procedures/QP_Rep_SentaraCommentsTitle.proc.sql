CREATE PROCEDURE [dbo].[QP_Rep_SentaraCommentsTitle]
    @Associate varchar(50),
    @StartDate datetime,
    @EndDate   datetime
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select convert(varchar(10), @StartDate, 101) + ' to ' + convert(varchar(10), @EndDate, 101) as 'From'

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


