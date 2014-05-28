CREATE PROCEDURE WebPref_LithoToBarcode @Litho VARCHAR(20)
AS
SELECT dbo.LithoToBarCode(@Litho,1)


