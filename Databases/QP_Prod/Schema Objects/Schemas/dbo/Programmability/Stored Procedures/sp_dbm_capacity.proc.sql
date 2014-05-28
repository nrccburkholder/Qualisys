CREATE procedure sp_dbm_capacity as
select dat_dt, generated, scheduled, notformgened, notpclgened, actualsampled, countsampled, samples, actualloaded, countloaded, loads,
countboth, countimported, countreturned, countunused 
from capacity where dat_dt >= dateadd(d,-8,getdate()) order by dat_dt
set nocount on
--declare @scheduled int, @sampled int, @loaded int, @both int, @imported int, @returned int, @unused int
print ''
print 'Actual Current Week'
print ''
select sum(generated) as scheduled, sum(actualsampled) as sampled, sum(actualloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where dat_dt >= dateadd(d,-8,getdate()) 
print ''
print 'Actual Current Month'
print ''
select sum(generated) as scheduled, sum(actualsampled) as sampled, sum(actualloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where datepart(m,dat_dt) = datepart(m,getdate())
and datepart(year,dat_dt) = datepart(year,getdate())
print ''
print 'Actual Previous Month'
print ''
select sum(generated) as scheduled, sum(actualsampled) as sampled, sum(actualloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where datepart(m,dat_dt) = case when datepart(m,getdate()) > 1 then (datepart(m,getdate()) - 1) else 12 end
and datepart(year,dat_dt) = case when datepart(m,getdate()) > 1 then datepart(year,getdate()) else (datepart(year,getdate()) - 1) end

print ''
print 'Current Week'
print ''
select (sum(scheduled)-sum(notformgened)) as scheduled, sum(countsampled) as sampled, sum(countloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where dat_dt >= dateadd(d,-8,getdate()) 
print ''
print 'Current Month'
print ''
select (sum(scheduled)-sum(notformgened)) as scheduled, sum(countsampled) as sampled, sum(countloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where datepart(m,dat_dt) = datepart(m,getdate())
and datepart(year,dat_dt) = datepart(year,getdate())
print ''
print 'Previous Month'
print ''
select (sum(scheduled)-sum(notformgened)) as scheduled, sum(countsampled) as sampled, sum(countloaded) as loaded, sum(countboth) as both, 
sum(countimported) as imported, sum(countreturned) as returned, sum(countunused) as unused
from capacity 
where datepart(m,dat_dt) = case when datepart(m,getdate()) > 1 then (datepart(m,getdate()) - 1) else 12 end
and datepart(year,dat_dt) = case when datepart(m,getdate()) > 1 then datepart(year,getdate()) else (datepart(year,getdate()) - 1) end


