CREATE PROCEDURE QCL_UpdateFacility
@Facility_id INT,
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

UPDATE SUFacility
 SET AHA_id=@AHA_id,
 strFacility_nm=@strFacility_nm,
 City=@City,
 State=@State,
 Country=@Country,
 Region_id=@Region_id,
 AdmitNumber=@AdmitNumber,
 BedSize=@BedSize,
 bitPeds=@bitPeds,
 bitTeaching=@bitTeaching,
 bitTrauma=@bitTrauma,
 bitReligious=@bitReligious,
 bitGovernment=@bitGovernment,
 bitRural=@bitRural,
 bitForProfit=@bitForProfit,
 bitRehab=@bitRehab,
 bitCancerCenter=@bitCancerCenter,
 bitPicker=@bitPicker,
 bitFreeStanding=@bitFreeStanding,
 MedicareNumber=@MedicareNumber
WHERE SUFacility_id=@Facility_id


