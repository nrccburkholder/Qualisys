CREATE PROCEDURE sp_worldtrak
AS

declare @begindate datetime, @enddate datetime

select @begindate = isnull((max(end_extract_dt)),'1/1/90')  from worldtrak_extract

set @enddate = getdate()
/*
insert into worldtrak_extract
select @begindate, @enddate
*/

create table #worldtrak (qt_id int identity, strclient_nm varchar(40), strcontactname varchar(40), strcontactphone varchar(25), strcontactfax varchar(25), 
	strcontacttitle varchar(25), strcontactaddr1 varchar(40), strcontactaddr2 varchar(40), strcontactcity varchar(40), strcontactst varchar(20),
	strcontactzip varchar(10), strcontactemail varchar(50))


insert into #worldtrak
select company_name strclient_nm, first_name + ' ' + last_name strcontactname, null, null, e.title strcontacttitle, e.address1 strcontactaddr1, e.address2 strcontactaddr2,
	e.city strcontactcity, e.state_prov_abbr strcontactst, e.postcode strcontactzip, e.e_mail_address strcontactemail
--into #worldtrak
from nrc32.wt_test.dbo.entities e, nrc32.wt_test.dbo.entity_assoc ea, nrc32.wt_test.dbo.entity_phones ep
where ea.entity_assoc_type = 'customer'
and ea.entity_id = e.entity_id
and e.company_name is not null
and e.first_name is not null
and e.last_name is not null
and e.origin_date between @begindate and @enddate
union
select company_name strclient_nm, first_name + ' ' + last_name strcontactname, null, null, e.title strcontacttitle, e.address1 strcontactaddr1, e.address2 strcontactaddr2,
	e.city strcontactcity, e.state_prov_abbr strcontactst, e.postcode strcontactzip, e.e_mail_address strcontactemail
from nrc32.wt_test.dbo.entities e, nrc32.wt_test.dbo.entity_assoc ea, nrc32.wt_test.dbo.entity_phones ep
where ea.entity_assoc_type = 'customer'
and ea.entity_id = e.entity_id
and e.company_name is not null
and e.first_name is not null
and e.last_name is not null
and e.change_date between @begindate and @enddate

declare	@strClient_Nm      varchar(40), 
	@strContactName    varchar(40),
	@strContactPhone   varchar(25),
	@strContactFax     varchar(25),
	@strContactTitle   varchar(25),
	@strContactAddr1   varchar(40), 
	@strContactAddr2   varchar(40), 
	@strContactCity    varchar(40), 
	@strContactState   varchar(20), 
	@strContactZip     varchar(10), 
	@strContactEMail   varchar(50)

--Declare variables
DECLARE @ClientID int
DECLARE @strTemp  varchar(100)
DECLARE @WTID int

WHILE (SELECT COUNT(*) FROM #worldtrak) > 0
BEGIN

SET @wtid = (SELECT MIN(wt_id) FROM #worldtrak)

--Trim off any trailing blanks
SELECT 	  @strClient_Nm    = RTrim(strClient_Nm)
	, @strContactName  = RTrim(strContactName)
	, @strContactPhone = RTrim(strContactPhone)
	, @strContactFax   = RTrim(strContactFax)
	, @strContactTitle = RTrim(strContactTitle)
	, @strContactAddr1 = RTrim(strContactAddr1)
	, @strContactAddr2 = RTrim(strContactAddr2)
	, @strContactCity  = RTrim(strContactCity)
	, @strContactState = RTrim(strContactState)
	, @strContactZip   = RTrim(strContactZip)
	, @strContactEMail = RTrim(strContactEMail)
FROM #worldtrak
WHERE wt_id = @wtid

--Initialize variables
SET @ClientID = NULL

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
    
END
ELSE
BEGIN
    --Check the contact phone
    SET @strTemp = (SELECT strContactPhone FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactPhone IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactPhone)
    BEGIN
        UPDATE Client_Contact SET strContactPhone = @strContactPhone WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact fax
    SET @strTemp = (SELECT strContactFax FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactFax IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactFax)
    BEGIN
        UPDATE Client_Contact SET strContactFax = @strContactFax WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact title
    SET @strTemp = (SELECT strContactTitle FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactTitle IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactTitle)
    BEGIN
        UPDATE Client_Contact SET strContactTitle = @strContactTitle WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact address1
    SET @strTemp = (SELECT strContactAddr1 FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactAddr1 IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactAddr1)
    BEGIN
        UPDATE Client_Contact SET strContactAddr1 = @strContactAddr1 WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact address2
    SET @strTemp = (SELECT strContactAddr2 FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactAddr2 IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactAddr2)
    BEGIN
        UPDATE Client_Contact SET strContactAddr2 = @strContactAddr2 WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact city
    SET @strTemp = (SELECT strContactCity FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactCity IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactCity)
    BEGIN
        UPDATE Client_Contact SET strContactCity = @strContactCity WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact state
    SET @strTemp = (SELECT strContactState FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactState IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactState)
    BEGIN
        UPDATE Client_Contact SET strContactState = @strContactState WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact zip
    SET @strTemp = (SELECT strContactZip FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactZip IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactZip)
    BEGIN
        UPDATE Client_Contact SET strContactZip = @strContactZip WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

    --Check the contact email
    SET @strTemp = (SELECT strContactEMail FROM Client_Contact WHERE strContactName = @strContactName AND Client_id = @ClientID)
    IF NOT @strContactEMail IS NULL AND (@strTemp IS NULL OR @strTemp <> @strContactEMail)
    BEGIN
        UPDATE Client_Contact SET strContactEMail = @strContactEMail WHERE strContactName = @strContactName AND Client_id = @ClientID
    END

END

DELETE #worldtrak WHERE wt_id = @wtid

END


