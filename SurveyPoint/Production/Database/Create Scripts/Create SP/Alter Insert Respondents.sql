
/*
12/2/07 MWB
Purpose:
Generic CRUD statement to insert respondents. 
It has been modified to always add a WAC code after the insert.
Version 1.0 Origional
*/
Alter PROCEDURE insert_Respondents    
 (@RespondentID  [int] OUTPUT,    
  @SurveyInstanceID  [int],    
  @FirstName  [varchar](100),    
  @MiddleInitial  [varchar](10),    
  @LastName  [varchar](100),    
  @Address1  [varchar](250),    
  @Address2  [varchar](250),    
  @City  [varchar](100),    
  @State  [char](2),    
  @PostalCode  [varchar](50),    
  @TelephoneDay  [varchar](50),    
  @TelephoneEvening  [varchar](50),    
  @Email  [varchar](50),    
  @DOB  [datetime],    
  @Gender  [char](1),    
  @ClientRespondentID  [varchar](50),    
  @SSN  [varchar](50),    
  @BatchID  [int],    
  @SurveyID [int] OUTPUT,    
  @ClientID [int] OUTPUT,    
  @SurveyInstanceName [varchar](100) OUTPUT,    
  @SurveyName [varchar](100) OUTPUT,    
  @ClientName [varchar](100) OUTPUT,     
  @PostalCodeExt [varchar](10) = null)    
AS    
BEGIN    
    
INSERT INTO [Respondents]     
  ( [SurveyInstanceID],    
  [FirstName],    
  [MiddleInitial],    
  [LastName],    
  [Address1],    
  [Address2],    
  [City],    
  [State],    
  [PostalCode],    
  [TelephoneDay],    
  [TelephoneEvening],    
  [Email],    
  [DOB],    
  [Gender],    
  [ClientRespondentID],    
  [SSN],    
  [BatchID],    
  [MailingSeedFlag],     
  [PostalCodeExt])     
     
VALUES     
 (@SurveyInstanceID,    
  @FirstName,    
  @MiddleInitial,    
  @LastName,    
  @Address1,    
  @Address2,    
  @City,    
  @State,    
  @PostalCode,    
  @TelephoneDay,    
  @TelephoneEvening,    
  @Email,    
  @DOB,    
  @Gender,    
  @ClientRespondentID,    
  @SSN,    
  @BatchID,    
  0,     
  @PostalCodeExt)    
    
SET @RespondentID = @@IDENTITY    
  
--MWB 11/2/07
--We always add a WAC code to all new respondents.
--This is so any survey can change there mind and use this at any time.  
  declare @RespondentPropertyID int  
  declare @WACCode varchar(15)  
  set @WACCode = dbo.LithoToWac(@RespondentID)  
  Exec insert_RespondentProperties @RespondentPropertyID, @RespondentID, 'WEBACCESSCODE', @WACCode  

  
SELECT @SurveyID = SurveyID, @ClientID = ClientID, @SurveyInstanceName = SurveyInstanceName,    
       @SurveyName = SurveyName, @ClientName = ClientName FROM vw_Respondents     
       WHERE RespondentID = @RespondentID    
    
RETURN     
    
END    