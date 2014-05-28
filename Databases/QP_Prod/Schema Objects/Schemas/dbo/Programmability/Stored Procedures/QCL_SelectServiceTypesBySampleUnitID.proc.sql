/*******************************************************************************
 *
 * Procedure Name:
 *           QCL_SelectServiceTypesBySampleUnitID
 *
 * Description:
 *           Pull the service type and sub types selected for the sample unit
 *
 * Parameters:
 *           @SampleUnit_ID      int
 *
 * Return:
 *           -1:     Success
 *           Other:  Fail
 *
 * History:
 *           1.0  03/14/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.QCL_SelectServiceTypesBySampleUnitID (
        @SampleUnit_ID      int
       )
AS
  DECLARE @Service_ID  AS int
  
  --
  -- There is a record in SampleUnitService which has sample unit ID
  -- of "1" and service type of "other". This is not the value we
  -- want for new sample unit
  --
  IF (@SampleUnit_ID <= 0) BEGIN
      SELECT Service_Id,
             ParentService_Id,
             strService_NM
        FROM Service
       WHERE 1 = 0
      
      RETURN -1
  END
  
  --
  -- Find the parent service type ID.
  -- Using this defensive way to get the smallest service type ID if there are
  -- multiple parent service types selected to sample unit
  --
  SELECT TOP 1
         @Service_ID = Service_ID
    FROM (
          -- Parent service
          SELECT sv.Service_ID
            FROM SampleUnitService us,
                 Service sv
           WHERE us.SampleUnit_ID = @SampleUnit_ID
             AND sv.Service_ID = us.Service_ID
             AND sv.ParentService_ID IS NULL
          UNION
          -- Child service's parent service
          SELECT sv.ParentService_ID AS Service_ID
            FROM SampleUnitService us,
                 Service sv
           WHERE us.SampleUnit_ID = @SampleUnit_ID
             AND sv.Service_ID = us.Service_ID
             AND sv.ParentService_ID > 0
         ) sv
   ORDER BY Service_ID

  
  --
  -- Pull the service type and its service sub type of this sample unit
  --
  
  -- Parent service
  SELECT Service_Id,
         ParentService_Id,
         strService_NM
    FROM Service
   WHERE Service_ID = @Service_ID
  
  UNION ALL
  
  -- Child services
  SELECT sv.Service_ID,
         sv.ParentService_ID,
         sv.strService_NM
    FROM SampleUnitService us,
         Service sv
   WHERE us.SampleUnit_ID = @SampleUnit_ID
     AND sv.Service_ID = us.Service_ID
     AND sv.ParentService_ID = @Service_ID
   ORDER BY
         ParentService_ID,
         Service_Id

  RETURN -1


