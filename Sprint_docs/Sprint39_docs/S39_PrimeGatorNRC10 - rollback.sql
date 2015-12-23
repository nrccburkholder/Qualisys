/*

Sprint 39 SQLCMD Script for Prime/Gator/NRC10

\Sprint_docs\Sprint39_docs\S39_PrimeGatorNRC10 - rollback.sql

Chris Burkholder

*/

--test print generate script :r "\ATLASRelease38&39\Sprint39_docs\S39_US17.4 Run Test Prints for Hospice QuestionCore change.sql"

--select query :r "\ATLASRelease38&39\Sprint39_docs\S39_US11.2_HCAHPS_Custom_Methodologies_list.sql"

:r "\ATLASRelease38&39\Sprint39_docs\S39 US3 INC0050992 QSL_PhoneVendorCancelList fix - rollback.sql"

:r "\ATLASRelease38&39\Sprint39_docs\S39_US11_HCAHPS_No_Custom_Methodologies_ROLLBACK.sql"

:r "\ATLASRelease38&39\Sprint39_docs\S39_US19 SV_SamplePlan_Has_Consistent_CCNs_ROLLBACK.sql"

-- this was part of an off-cycle release
--:r "\ATLASRelease38&39\Sprint39_docs\S39_US17.2_ Hospice_CAHPS_2.0_Language-Speak Question_ROLLBACK.sql"