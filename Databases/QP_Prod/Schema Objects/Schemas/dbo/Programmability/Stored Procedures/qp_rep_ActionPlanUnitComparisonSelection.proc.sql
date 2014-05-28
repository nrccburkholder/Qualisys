CREATE procedure [dbo].[qp_rep_ActionPlanUnitComparisonSelection]
@Associate varchar(50), @Client varchar(50), @ModifiedSince datetime ='1/1/1999'
as
insert into dashboardlog (report, associate, client, StartDate, ProcedureBegin) 
select 'ActionPlanUnitComparisonSelection', @associate, @client, @ModifiedSince, getdate()
exec datamart.qp_comments.dbo.qp_rep_ActionPlanUnitComparisonSelection @Client, @ModifiedSince


