Create Proc SSRS_ReturnsbyType_Details (@samplesets varchar(5000))
as
begin

declare @SQL varchar(8000)

	set @SQL = '
	select isnull(qf.receipttype_Id, 17) as ReceiptType_ID, ReceiptType_nm, count(*) 
	from questionform qf, receipttype rt, samplepop sp
	where	isnull(qf.receipttype_Id, 17) = rt.receiptType_ID and
			sp.samplepop_ID = qf.samplepop_ID and
			sp.sampleset_ID in ( ' + @samplesets + ')
	group by  isnull(qf.receipttype_Id, 17), ReceiptType_nm
	Order by  ReceiptType_nm'

	print @SQL
	exec (@SQL)

end


