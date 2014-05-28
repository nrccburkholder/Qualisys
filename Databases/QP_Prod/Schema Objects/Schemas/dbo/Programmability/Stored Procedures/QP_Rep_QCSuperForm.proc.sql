CREATE PROCEDURE QP_Rep_QCSuperForm @Associate VARCHAR(50), @Client  VARCHAR(50), @Study  VARCHAR(50), @Survey  VARCHAR(50), @MinSampleDate  DATETIME, @MaxSampleDate  DATETIME
AS 
-- Proc only here to ensure that the sheet gets the name "QCSuperForm" (rather than "Question Mapping - inherited from last proc executed).
SELECT 'QC SuperForm' AS SheetNameDummy, '' AS 'QC SuperForm'


