CREATE  PROCEDURE QCL_InsertFacility
@AHA_id INT,
@strFacility_nm VARCHAR(100),
@City VARCHAR(42),
@State VARCHAR(2),
@Country VARCHAR(42),
@Region_id INT,
@AdmitNumber INT,
@BedSize INT,
@bitPeds BIT,
@bitTeaching BIT,
@bitTrauma BIT,
@bitReligious BIT,
@bitGovernment BIT,
@bitRural BIT,
@bitForProfit BIT,
@bitRehab BIT,
@bitCancerCenter BIT,
@bitPicker BIT,
@bitFreeStanding BIT,
@MedicareNumber VARCHAR(20)
AS

INSERT INTO SUFacility (AHA_id, strFacility_nm, City, State, Country,   
  Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching, bitTrauma,   
  bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab,   
  bitCancerCenter, bitPicker, bitFreeStanding, MedicareNumber)
VALUES (@AHA_id, @strFacility_nm, @City, @State, @Country,   
  @Region_id, @AdmitNumber, @BedSize, @bitPeds, @bitTeaching, @bitTrauma,   
  @bitReligious, @bitGovernment, @bitRural, @bitForProfit, @bitRehab,   
  @bitCancerCenter, @bitPicker, @bitFreeStanding, @MedicareNumber)

SELECT SCOPE_IDENTITY()


