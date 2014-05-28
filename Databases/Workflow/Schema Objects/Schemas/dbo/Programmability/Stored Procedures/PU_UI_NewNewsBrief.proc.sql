/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_NewNewsBrief
 *
 * Description:
 *           Create a new PU Report
 *
 * Parameters:
 *           @PU_ID          int
 *             Project Update ID
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_UI_NewNewsBrief (
                       @Content       text,
                       @Published     bit,
                       @Skip          bit,
                       @Employee_ID   int
) AS

  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  DECLARE @News_ID    int
  
  
  INSERT INTO NewsBrief (  
          Content,
          Published,
          Skip,
          CreatedBy
         )  
  VALUES (  
          @Content,  
          @Published,  
          @Skip,  
          @Employee_ID
         )  

  SET @News_ID = @@IDENTITY

  RETURN @News_ID


