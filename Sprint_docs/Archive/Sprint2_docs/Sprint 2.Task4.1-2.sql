/*
story 4: As an Authorized HCAHPS Vendor, we want to update the final disposition when eligibility changes due to a DRG Update, so that 
we can report correct data.
task 4.1: Modify ld_updatemsdrg_updater
task 4.2: Modify ld_updatedrg_updater
(instead of modifying the procs, we're changing the default value of DispositionLog.bitExtracted to 0, so any process that inserts
new records into the disposition log and doesn't specify a value for bitExtracted will get a value of 0.

*/
use qp_prod
go
ALTER TABLE [dbo].[DispositionLog]
ADD CONSTRAINT DF__DispositionLog__bitExtracted DEFAULT 0 FOR [bitExtracted] 
