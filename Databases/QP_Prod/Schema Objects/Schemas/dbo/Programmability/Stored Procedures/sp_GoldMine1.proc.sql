/****** Object:  Stored Procedure dbo.sp_GoldMine  Script Date: 4/4/00 11:17:39 AM ******
 v1.0.0 - Felix Gomez - 4/4/2000
 v1.0.1 - Felix Gomez - 4/12/2000 (Updates StrContactEmail)
 v1.0.2 - Jeffrey Fleming - 2/27/2002 - changed all char params to varchar and rtrimed them all
*/
CREATE PROCEDURE sp_GoldMine1 
	@strClient_Nm      varchar(40), 
	@strContactName    varchar(40),
	@strContactPhone   varchar(25),
	@strContactFax     varchar(25),
	@strContactTitle   varchar(25),
	@strContactAddr1   varchar(40), 
	@strContactAddr2   varchar(40), 
	@strContactCity    varchar(40), 
	@strContactState   varchar(20), 
	@strContactZip     varchar(10), 
	@strContactEMail   varchar(35),
    @bitClientUpdated  bit output,
	@bitContactUpdated bit output,
	@bitPhoneUpdated   bit output,
	@bitFaxUpdated     bit output,
	@bitTitleUpdated   bit output,
	@bitAddr1Updated   bit output,
	@bitAddr2Updated   bit output,
	@bitCityUpdated    bit output,
	@bitStateUpdated   bit output,
	@bitZipUpdated     bit output,
	@bitEMailUpdated   bit output

AS

--Declare variables
DECLARE @ClientID int
DECLARE @strTemp  varchar(100)

--Trim off any trailing blanks
SET @strClient_Nm    = RTrim(@strClient_Nm)
SET @strContactName  = RTrim(@strContactName)
SET @strContactPhone = RTrim(@strContactPhone)
SET @strContactFax   = RTrim(@strContactFax)
SET @strContactTitle = RTrim(@strContactTitle)
SET @strContactAddr1 = RTrim(@strContactAddr1)
SET @strContactAddr2 = RTrim(@strContactAddr2)
SET @strContactCity  = RTrim(@strContactCity)
SET @strContactState = RTrim(@strContactState)
SET @strContactZip   = RTrim(@strContactZip)
SET @strContactEMail = RTrim(@strContactEMail)

--Initialize variables
SET @ClientID = NULL
SET @bitClientUpdated  = 0
SET @bitContactUpdated = 0
SET @bitPhoneUpdated   = 0
SET @bitFaxUpdated     = 0
SET @bitTitleUpdated   = 0
SET @bitAddr1Updated   = 0
SET @bitAddr2Updated   = 0
SET @bitCityUpdated    = 0
SET @bitStateUpdated   = 0
SET @bitZipUpdated     = 0
SET @bitEMailUpdated   = 0

--If the client name is null then we are out of here
IF @strClient_Nm IS NULL
    RETURN

--If the contact name is null then we are out of here
IF @strContactName IS NULL 
    RETURN

--Get the client id
SELECT @ClientID = Client_id
FROM Client
WHERE strClient_Nm = @strClient_Nm

--If the client id is null then we need to add the client
IF @ClientID IS NULL
BEGIN
    INSERT INTO Client (strClient_Nm) VALUES (@strClient_Nm)

    SELECT @ClientID = Client_id
    FROM Client
    WHERE strClient_Nm = @strClient_Nm
    
    SET @bitClientUpdated = 1
END  

--Check the contact name
SET @strTemp = (SELECT strContactName FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
IF @strTemp IS NULL OR @strTemp <> @strContactName
BEGIN
    --The record does not exist so add it
    INSERT INTO CLIENT_CONTACT (strContactName, strContactPhone, strContactFax, strContactTitle, strContactAddr1, 
                                strContactAddr2, strContactCity, strContactState, strContactZip, strContactEMail, Client_id) 
    VALUES (@strContactName, @strContactPhone, @strContactFax, @strContactTitle, @strContactAddr1, @strContactAddr2, 
            @strContactCity, @strContactState, @strContactZip, @strContactEMail, @ClientID)
    
    SET @bitContactUpdated = 1
END
ELSE
BEGIN
    --Check the contact phone
    SET @strTemp = (SELECT strContactPhone FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactPhone IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactPhone)
    BEGIN
        UPDATE Client_Contact SET strContactPhone = @strContactPhone WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitPhoneUpdated = 1
    END

    --Check the contact fax
    SET @strTemp = (SELECT strContactFax FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactFax IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactFax)
    BEGIN
        UPDATE Client_Contact SET strContactFax = @strContactFax WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitFaxUpdated = 1
    END

    --Check the contact title
    SET @strTemp = (SELECT strContactTitle FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactTitle IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactTitle)
    BEGIN
        UPDATE Client_Contact SET strContactTitle = @strContactTitle WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitTitleUpdated = 1
    END

    --Check the contact address1
    SET @strTemp = (SELECT strContactAddr1 FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactAddr1 IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactAddr1)
    BEGIN
        UPDATE Client_Contact SET strContactAddr1 = @strContactAddr1 WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitAddr1Updated = 1
    END

    --Check the contact address2
    SET @strTemp = (SELECT strContactAddr2 FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactAddr2 IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactAddr2)
    BEGIN
        UPDATE Client_Contact SET strContactAddr2 = @strContactAddr2 WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitAddr2Updated = 1
    END

    --Check the contact city
    SET @strTemp = (SELECT strContactCity FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactCity IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactCity)
    BEGIN
        UPDATE Client_Contact SET strContactCity = @strContactCity WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitCityUpdated = 1
    END

    --Check the contact state
    SET @strTemp = (SELECT strContactState FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactState IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactState)
    BEGIN
        UPDATE Client_Contact SET strContactState = @strContactState WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitStateUpdated = 1
    END

    --Check the contact zip
    SET @strTemp = (SELECT strContactZip FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactZip IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactZip)
    BEGIN
        UPDATE Client_Contact SET strContactZip = @strContactZip WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitZipUpdated = 1
    END

    --Check the contact email
    SET @strTemp = (SELECT strContactEMail FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactEMail IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactEMail)
    BEGIN
        UPDATE Client_Contact SET strContactEMail = @strContactEMail WHERE strContactName = @strContactName AND Client_id = @ClientID
        SET @bitEMailUpdated = 1
    END

END


