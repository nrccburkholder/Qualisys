/****** Object:  Stored Procedure dbo.sp_PCL_Clean_PCLOutput    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Removes the data from the PCLOutput table on mailing items that were */
/*       generated but are in error.      */
/*            */
/* Date Created:  7/12/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Clean_PCLOutput
 @FrmGenDate varchar(22)
AS
 DELETE PO
   FROM dbo.PCLOutput2 PO, dbo.SentMailing SM, dbo.FormGenError FGE
    WHERE PO.SentMail_id = SM.SentMail_id  
    AND SM.ScheduledMailing_id = FGE.ScheduledMailing_id
    AND FGE.datGenerated = @FrmGenDate


