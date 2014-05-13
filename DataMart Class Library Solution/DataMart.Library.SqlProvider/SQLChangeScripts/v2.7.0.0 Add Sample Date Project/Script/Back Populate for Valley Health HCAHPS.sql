/*
 * Update datSampleEncounterDate to contain the DischargeDate value
 * for Valley Health HCAHPS surveys
 */
UPDATE s1606.Big_Table_2006_2
   SET datSampleEncounterDate = dischargedate
 WHERE survey_ID IN (7236,7237,7239)

UPDATE s1606.Big_Table_2006_3
   SET datSampleEncounterDate = dischargedate
 WHERE survey_ID IN (7236,7237,7239)

UPDATE s1606.Big_Table_2006_4
   SET datSampleEncounterDate = dischargedate
 WHERE survey_ID IN (7236,7237,7239)