CREATE VIEW TeamMember_View
AS
SELECT TOP 100 PERCENT TeamName, t.Team_id, strNTLogin_nm, tm.Employee_id, RoleName, tm.Role_id, strEmail
FROM Employee e, TeamMember tm, Team t, Role r
WHERE t.Team_id=tm.Team_id
AND tm.Employee_id=e.Employee_id
AND tm.Role_id=r.Role_id
AND t.Team_id<>999
ORDER BY 1,3


