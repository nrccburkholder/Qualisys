create function mb_getHCAHPSValue (@strlithocode varchar(10)) RETURNS varchar(5)
as
begin

declare @HCAHPSvalue varchar(5)

select top 1 @HCAHPSvalue=hcahpsvalue
from dl_lithocodes l, vendordispositionlog vdl, vendordispositions vd, disposition d
where l.dl_lithocode_id = vdl.dl_lithocode_id
and vdl.vendor_id = vd.vendor_id
and vdl.vendordisposition_id = vd.vendordisposition_id
and	d.disposition_ID = vd.disposition_ID
and l.strlithocode = @strlithocode
order by d.hcahpshierarchy

return @HCAHPSvalue

end


