CREATE PROCEDURE sp_OffTR_AddToTOCL
    @intStudyID int, 
    @intPopID   int

AS

--Add to the take off call list table
INSERT INTO TOCL ( Study_id, Pop_id, datTOCL_Dat ) 
VALUES ( @intStudyID, @intPopID, getdate() )


