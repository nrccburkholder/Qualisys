create proc sp_DODAddrCleanStep2
as
update p
set p.Addr = pl.Addr,
    p.City = pl.City,
    p.St = pl.St,
    p.Zip5 = pl.Zip5,
    p.Zip4 = pl.Zip4,
    p.Del_pt = pl.Del_pt,
    p.AddrErr = pl.AddrErr,
    p.AddrStat = pl.AddrStat
from s348.population_load pl, s348.population p
where pl.ServiceInd_22 = p.pop_id


