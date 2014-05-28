CREATE procedure [dbo].[QP_Rep_ResponseRateDateType_ByDate]
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @MinDate datetime,
 @MaxDate datetime,
 @DateType varchar(10)

AS

select @DateType as [Date Type]


