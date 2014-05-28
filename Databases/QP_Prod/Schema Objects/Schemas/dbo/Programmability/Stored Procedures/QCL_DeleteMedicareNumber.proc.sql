CREATE PROCEDURE QCL_DeleteMedicareNumber
 @MedicareNumber VARCHAR(20)
AS

IF EXISTS (SELECT * FROM SUFacility WHERE MedicareNumber=@MedicareNumber)
BEGIN
 RAISERROR ('MedicareNumber is associated with a facility.',18,1)
 RETURN
END

DELETE MedicareLookup WHERE MedicareNumber=@MedicareNumber


