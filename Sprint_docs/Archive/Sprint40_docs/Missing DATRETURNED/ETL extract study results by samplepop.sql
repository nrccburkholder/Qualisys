
use QP_Comments
--first check that there are no work tables already out there.
--if work tables exist you must be sure they can be deleted otherwise do not remove them
checkforwork
destroyworktables
--This is the SP that starts the bubble data extract and moves all results into the work tables.
--exec sp_extract_bubbledata
--exec SP_Extract_BubbleData_work

exec SP_Extract_BubbleData_by_samplepop


exec sp_extract_populateaggregatework
exec sp_extract_rollupn
exec sp_dbm_movefromwork 'Study_Results'
exec sp_dbm_movefromaggwork 'Aggregate'
exec SP_DBM_MoveFromRollUpNWork 'RollupN'
exec sp_dbm_movefromwork 'Study_Results_Vertical'



--they should all be gone.
--there is a bug that sometimes does not delete the work tables if only 1 study is being moved.
--if this is the case make sure that records have been updated in the study owned permenate tables
--from the work table(s) that is still present. If you find data in the permenant tables 
--you can drop the work table
checkforwork

--drop table if needed
--drop table s2197.Study_Results_Work
