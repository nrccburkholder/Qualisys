/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectTemplate
 *
 * Description:
 *           Retrieve template info
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_SelectTemplate (
        @Template_ID      int
       )
AS
  SELECT Template_ID,
         TemplateName,
         strClient_NM,
         Description
    FROM GHS_MailMergeTemplate
   WHERE Template_ID = @Template_ID
  
  RETURN -1


