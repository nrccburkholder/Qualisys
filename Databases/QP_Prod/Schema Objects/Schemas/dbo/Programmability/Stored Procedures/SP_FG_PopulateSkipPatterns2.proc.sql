CREATE PROCEDURE SP_FG_PopulateSkipPatterns2 @Survey_id INT, @GetDate DATETIME    
AS    
    
--Get the questions in order they would appear on a form    
SELECT QstnCore, (Section_id*1000000)+(subSection*1000)+Item qstnorder, subType, Section_id, subSection, Item    
INTO #t    
FROM Sel_Qstns sq    
WHERE Survey_id=@Survey_id    
AND subType in (1,4)    
AND Language=1    
    
--determine the skip patterns the cross at least one question    
INSERT INTO SkipIdentifier (Survey_id, datGenerated, QstnCore, intResponseVal)    
SELECT ss.Survey_id, @GetDate datGenerated, QstnCore, Val    
FROM Sel_Skip ss, Sel_Qstns sq, Sel_Scls s    
WHERE (ss.numSkip<>1 or ss.numSkipType<>1)    
AND ss.Survey_id=sq.Survey_id    
AND ss.SelQstns_id=sq.SelQstns_id    
AND sq.subType=1    
AND sq.Language=1    
AND ss.Survey_id=@Survey_id    
AND sq.Survey_id=s.Survey_id    
AND sq.Language=s.Language    
AND sq.Scaleid=s.QPC_id    
AND ss.ScaleItem=s.Item    
ORDER BY Section_id, subSection, sq.Item    
    
--get the data back into a temp table along with the skip information.    
SELECT DISTINCT t.*, ss.numSkip, ss.numSkipType, (Section_id*1000000)+(subSection*1000)+sq.Item qstnorder, Section_id, subSection, sq.Item qstnItem    
INTO #temp    
FROM SkipIdentifier t, Sel_Skip ss, Sel_Qstns sq, Sel_Scls sc
WHERE datGenerated=@GetDate    
AND t.Survey_id=@Survey_id    
AND t.Survey_id=sq.Survey_id    
AND t.QstnCore=sq.QstnCore    
AND sq.subType=1    
AND sq.Language=1    
AND sq.Scaleid=sc.qpc_id
AND sq.Survey_id=sc.Survey_id
AND t.intResponseVal=sc.Val
AND sc.Item=ss.ScaleItem
AND sq.Survey_id=ss.Survey_id    
AND sq.SelQstns_id=ss.SelQstns_id    
AND (ss.numSkip<>1 OR numSkipType<>1)    
    
--#cores will house the information to get written to SkipQstns    
CREATE TABLE #cores (skip_id INT, QstnCore INT)    
--#qstnorder is only used to store a variable to be retreived after the executesql statement.    
CREATE TABLE #qstnorder (qstnorder INT)    
    
DECLARE @beginqstnorder INT, @endqstnorder INT, @skiptype INT, @sql NVARCHAR(2000)    
DECLARE @core INT, @skip_id INT, @numSkip INT    
    
--loop by skip pattern.  This should be in order they would appear on a Survey.    
SELECT TOP 1 @skip_id=skip_id FROM #temp ORDER BY skip_id    
WHILE @@ROWCOUNT>0    
BEGIN    
     
 SELECT @core=QstnCore, @skiptype=numSkipType, @numSkip=numSkip FROM #temp WHERE skip_id=@skip_id    
    
 SELECT @beginqstnorder=qstnorder FROM #t WHERE QstnCore=@core    
     
 /*  
 --@skiptype: 1=qstns, 2=subSection, 3=Section    
 IF @skiptype=1    
 SET @sql='SELECT MAX(qstnorder)     
  FROM #t     
   WHERE qstnorder IN (SELECT TOP '+LTRIM(STR(@numSkip))+' qstnorder FROM #t WHERE qstnorder>'+LTRIM(STR(@beginqstnorder))+' ORDER BY qstnorder)'    
 ELSE IF @skiptype=2    
 SET @sql='SELECT MAX(qstnorder)     
  FROM #t     
   WHERE qstnorder IN (SELECT TOP '+LTRIM(STR(@numSkip))+' qstnorder FROM #t WHERE qstnorder>'+LTRIM(STR(@beginqstnorder+500))+' ORDER BY qstnorder)'    
 ELSE     
 SET @sql='SELECT ISNULL(MAX(qstnorder),5000000)     
  FROM #t     
   WHERE qstnorder IN (SELECT TOP '+LTRIM(STR(@numSkip))+' qstnorder FROM #t WHERE qstnorder>'+LTRIM(STR(@beginqstnorder+500000))+' ORDER BY qstnorder)'    
    
 TRUNCATE TABLE #qstnorder    
 --put the value INTO a temp table so I can set the value back to a variable    
 INSERT INTO #qstnorder    
 EXECUTE SP_ExecuteSQL @sql     
  
 SELECT @endqstnorder=qstnorder FROM #qstnorder    
 */  
  
 SELECT @endqstnorder=CASE numskiptype WHEN 1 THEN (Section_id*1000000)+(subSection*1000)+qstnItem+numskip --Same subSection  
            WHEN 2 THEN (Section_id*1000000)+((1+subSection)*1000)+numskip --Next subSection  
            ELSE ((1+Section_id)*1000000)+1001 END --Next Section  
 FROM #Temp WHERE Skip_id=@Skip_id  
  
 --now can INSERT the values INTO SkipQstns    
 INSERT INTO SkipQstns    
 SELECT @skip_id, QstnCore    
 FROM #t    
 WHERE qstnorder>@beginqstnorder    
 AND qstnorder<@endqstnorder    
    AND subType=1    
 ORDER BY qstnorder    
     
 DELETE #temp WHERE skip_id=@skip_id    
     
 SELECT TOP 1 @skip_id=skip_id FROM #temp ORDER BY skip_id    
    
END    
    
--clean up    
DROP TABLE #temp    
DROP TABLE #cores    
DROP TABLE #qstnorder    
DROP TABLE #t


