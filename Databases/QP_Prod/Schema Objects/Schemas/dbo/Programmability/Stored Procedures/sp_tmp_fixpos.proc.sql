CREATE PROCEDURE sp_tmp_fixpos AS

set rowcount 1000

select count(*) from qualpro_params
while @@rowcount > 0 
begin
    delete from bubblepos where qstncore = 776 -- 0:43
end

select count(*) from qualpro_params
while @@rowcount > 0 
begin
    delete from bubbleitempos where qstncore = 776 -- 2:39
end

select count(*) from qualpro_params
while @@rowcount > 0 
begin
    update bubblepos set readmethod_id=5 where qstncore in (796,892,896) and readmethod_id=-5 -- 0:26
end

select count(*) from qualpro_params
while @@rowcount > 0 
begin
    delete from bubbleitempos where qstncore in (796,892,896) and val=2 -- 2:32
end

set rowcount 0


