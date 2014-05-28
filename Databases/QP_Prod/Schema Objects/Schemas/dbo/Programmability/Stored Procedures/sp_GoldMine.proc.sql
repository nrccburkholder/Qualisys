﻿/****** Object:  Stored Procedure dbo.sp_GoldMine  Script Date: 4/4/00 11:17:39 AM ******
 v1.0.0 - Felix Gomez - 4/4/2000
 v1.0.1 - Felix Gomez - 4/12/2000 (Updates StrContactEmail)
 v1.0.2 - Jeffrey Fleming - 2/27/2002 - changed all char params to varchar and rtrimed them all
*/
CREATE PROCEDURE sp_GoldMine 
	@STRCLIENT_NM    varchar(40), 
	@STRCONTACTNAME  varchar(40),
	@STRCONTACTPHONE varchar(25),
	@STRCONTACTFAX   varchar(25),
	@STRCONTACTTITLE varchar(25),
	@STRCONTACTADDR1 varchar(40), 
	@STRCONTACTADDR2 varchar(40), 
	@STRCONTACTCITY  varchar(40), 
	@STRCONTACTSTATE varchar(20), 
	@STRCONTACTZIP   varchar(10), 
	@STRCONTACTEMAIL varchar(35) ,
        @CLIENT  bit OUTPUT,
	@CONTACT bit OUTPUT,
	@PHONE   bit OUTPUT,
	@FAX     bit OUTPUT,
	@TITLE   bit OUTPUT,
	@ADDR1   bit OUTPUT,
	@ADDR2   bit OUTPUT,
	@CITY    bit OUTPUT,
	@STATE   bit OUTPUT,
	@ZIP     bit OUTPUT,
	@EMAIL   bit OUTPUT
as

SET @STRCLIENT_NM = RTrim(@STRCLIENT_NM)
SET @STRCONTACTNAME = RTrim(@STRCONTACTNAME)
SET @STRCONTACTPHONE = RTrim(@STRCONTACTPHONE)
SET @STRCONTACTFAX = RTrim(@STRCONTACTFAX)
SET @STRCONTACTTITLE = RTrim(@STRCONTACTTITLE)
SET @STRCONTACTADDR1 = RTrim(@STRCONTACTADDR1)
SET @STRCONTACTADDR2 = RTrim(@STRCONTACTADDR2)
SET @STRCONTACTCITY = RTrim(@STRCONTACTCITY)
SET @STRCONTACTSTATE = RTrim(@STRCONTACTSTATE)
SET @STRCONTACTZIP = RTrim(@STRCONTACTZIP)
SET @STRCONTACTEMAIL = RTrim(@STRCONTACTEMAIL)

DECLARE @CLIENT_ID  INT
SET @CLIENT_ID = NULL
SET @CLIENT = 0
SET  @CONTACT = 0
SET @PHONE = 0
SET @FAX = 0
SET @TITLE = 0
SET @ADDR1 = 0
SET @ADDR2 = 0
SET @CITY = 0
SET @STATE = 0
SET @ZIP = 0
SET @EMAIL = 0

IF @STRCLIENT_NM IS NULL
  RETURN

SELECT @CLIENT_ID = CLIENT_ID
FROM CLIENT
WHERE STRCLIENT_NM  =  @STRCLIENT_NM


IF  @CLIENT_ID IS NULL
BEGIN	
       INSERT INTO CLIENT(STRCLIENT_NM )
                  VALUES (@STRCLIENT_NM)

      SELECT @CLIENT_ID = CLIENT_ID
      FROM CLIENT
      WHERE STRCLIENT_NM  =  @STRCLIENT_NM
      
     SET @CLIENT = 1
END  

IF NOT  @STRCONTACTNAME IN (SELECT STRCONTACTNAME
        			               FROM CLIENT_CONTACT 
			               WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
BEGIN
    IF (@STRCONTACTNAME)  IS NULL
       RETURN

     INSERT INTO CLIENT_CONTACT(
	STRCONTACTNAME, 
	STRCONTACTPHONE, 
	STRCONTACTFAX, 
	STRCONTACTTITLE,
	STRCONTACTADDR1, 
	STRCONTACTADDR2,
	STRCONTACTCITY,
	 STRCONTACTSTATE, 
	STRCONTACTZIP, 
	STRCONTACTEMAIL,
	CLIENT_ID) 
      VALUES (@STRCONTACTNAME, 	
	@STRCONTACTPHONE, 
	@STRCONTACTFAX, 
	@STRCONTACTTITLE, 
	@STRCONTACTADDR1, 
	@STRCONTACTADDR2, 
	@STRCONTACTCITY, 
	@STRCONTACTSTATE, 
	@STRCONTACTZIP, 
	@STRCONTACTEMAIL,
	@CLIENT_ID)
                  
    set  @CONTACT= 1
END
ELSE
BEGIN
if not @STRCONTACTPHONE in(SELECT STRCONTACTPHONE from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTPHONE = @STRCONTACTPHONE WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @PHONE = 1
end
if not @STRCONTACTFAX in(SELECT STRCONTACTFAX from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET	STRCONTACTFAX = @STRCONTACTFAX WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
    SET @FAX = 1
end

if not @STRCONTACTTITLE in(SELECT STRCONTACTTITLE from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTTITLE = @STRCONTACTTITLE WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @TITLE =1
end

if not @STRCONTACTADDR1 in(SELECT STRCONTACTADDR1 from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTADDR1 = @STRCONTACTADDR1 WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID) 
   SET @ADDR1 = 1
end

if not @STRCONTACTADDR2 in(SELECT STRCONTACTADDR2 from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTADDR2 = @STRCONTACTADDR2 WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @ADDR2 = 1
	

end

if not @STRCONTACTCITY in(SELECT STRCONTACTCITY from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTCITY = @STRCONTACTCITY  WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @CITY = 1
end

if not @STRCONTACTSTATE in(SELECT STRCONTACTSTATE from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTSTATE = @STRCONTACTSTATE  WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @STATE = 1
end


if not @STRCONTACTZIP in(SELECT STRCONTACTZIP from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTZIP = @STRCONTACTZIP  WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @ZIP = 1
end


if not @STRCONTACTEMAIL in(SELECT STRCONTACTEMAIL from CLIENT_CONTACT WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID))
begin
    UPDATE CLIENT_CONTACT SET STRCONTACTEMAIL = @STRCONTACTEMAIL WHERE (STRCONTACTNAME = @STRCONTACTNAME) AND (CLIENT_ID =@CLIENT_ID)
   SET @EMAIL = 1	
end   	

END


