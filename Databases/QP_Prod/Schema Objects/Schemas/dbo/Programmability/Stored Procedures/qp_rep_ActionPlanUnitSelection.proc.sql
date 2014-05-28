CREATE procedure [dbo].[qp_rep_ActionPlanUnitSelection]
@Associate varchar(50), @Client varchar(50), @ModifiedSince datetime ='1/1/1999'
as
insert into dashboardlog (report, associate, client, StartDate, ProcedureBegin) 
select 'ActionPlanUnitSelection', @associate, @client, @ModifiedSince, getdate()
exec datamart.qp_comments.dbo.qp_rep_ActionPlanUnitSelection @Client, @ModifiedSince


