create proc sp_DODAddrCleanStep1
as
truncate table s348.population_load

insert into s348.population_load(Fname, LName, Addr, City, St, Zip5, ServiceInd_22)
select Fname, LName, Addr, City, St, Zip5, pop_id  from s348.population where Del_pt is null


