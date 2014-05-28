/****** Object:  Stored Procedure dbo.sp_QPAddDataSet    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddDataSet    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddDataSet    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QPAddDataSet 
@mintStudy_id int,
@mdatLoad_str varchar(24),
@mintGood_recs int,
@mintBad_recs int,
@mintAddrNoChg int,
@mintAddrCleaned int,
@mintAddrError int,
@IDKey int OUTPUT
AS
BEGIN TRANSACTION
	INSERT into Data_Set
	(Study_id, datLoad_dt, intGood_recs, intBad_recs, 
	intAddrNoChg, intAddrCleaned, intAddrError)
	VALUES
	(@mintStudy_id, convert(datetime,@mdatLoad_str), @mintGood_recs, @mintBad_recs,
	@mintAddrNoChg, @mintAddrCleaned, @mintAddrError)

	SELECT @IDKey = SCOPE_IDENTITY()
COMMIT TRANSACTION


