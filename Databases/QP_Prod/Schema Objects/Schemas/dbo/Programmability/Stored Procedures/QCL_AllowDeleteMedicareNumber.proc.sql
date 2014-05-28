CREATE PROCEDURE QCL_AllowDeleteMedicareNumber
 @MedicareNumber VARCHAR(20)
AS

IF EXISTS (SELECT * FROM SUFacility WHERE MedicareNumber=@MedicareNumber)
SELECT 0
ELSE
SELECT 1


