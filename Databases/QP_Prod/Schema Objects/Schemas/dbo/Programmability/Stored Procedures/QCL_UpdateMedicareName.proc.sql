CREATE PROCEDURE QCL_UpdateMedicareName
 @MedicareNumber VARCHAR(20),
 @MedicareName VARCHAR(45)
AS

UPDATE MedicareLookup
SET MedicareName = @MedicareName
WHERE MedicareNumber = @MedicareNumber


