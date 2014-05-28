/****** Object:  Stored Procedure dbo.sp_PCL_Clean_PCLGenLog    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Removes the data from the PCLGenLog table on mailing items that were */
/*       generated but are in error.      */
/*            */
/* Date Created:  7/12/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Clean_PCLGenLog
 @FrmGenDate varchar(22)
AS
 
 DELETE 
  FROM dbo.PCLGenLog
   FROM dbo.PCLGenLog PGL, dbo.SentMailing SM, dbo.FormGenError FGE
    WHERE PGL.SentMail_id = SM.SentMail_id
    AND SM.ScheduledMailing_id = FGE.ScheduledMailing_id    AND FGE.datgenerated = @FrmGenDate


