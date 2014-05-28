CREATE PROCEDURE SP_SYS_TeamMembers @Team_id INT, @Role_id INT
AS

IF @Team_id=0 AND @Role_id=0
	SELECT * 
	FROM TeamMember_View

ELSE IF @Team_id=0 AND @Role_id<>0
	SELECT * 
	FROM TeamMember_View
	WHERE Role_id=@Role_id

ELSE IF @Team_id<>0 AND @Role_id=0
	SELECT * 
	FROM TeamMember_View
	WHERE Team_id=@Team_id

ELSE
	SELECT * 
	FROM TeamMember_View
	WHERE Role_id=@Role_id
	AND Team_id=@Team_id


