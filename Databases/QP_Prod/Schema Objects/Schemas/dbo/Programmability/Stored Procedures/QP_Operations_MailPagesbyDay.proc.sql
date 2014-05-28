CREATE PROCEDURE QP_Operations_MailPagesbyDay AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @mpd TABLE (datMailed DATETIME, PaperConfig_id INT, Match BIT, Cnt INT)

INSERT INTO @mpd
SELECT CONVERT(VARCHAR(10),datMailed,120), PaperConfig_id, Integrated, COUNT(*)
FROM NextMailingStep n, SentMailing sm, ScheduledMailing schm, MailingStep ms, Sel_Cover sc
WHERE datUpdated IS NULL
AND n.SentMail_id = sm.SentMail_id
AND sm.SentMail_id = schm.SentMail_id
AND schm.MailingStep_id = ms.MailingStep_id
AND ms.SelCover_id = sc.SelCover_id
AND ms.Survey_id = sc.Survey_id
GROUP BY CONVERT(VARCHAR(10),datMailed,120), PaperConfig_id, Integrated

UPDATE mpd
SET mpd.Cnt = mpd.Cnt + t.Cnt
FROM MailPagesbyDay mpd, @mpd t
WHERE mpd.datMailed = t.datMailed
AND mpd.PaperConfig_id = t.PaperConfig_id
AND mpd.Match = t.Match

DELETE t
FROM MailPagesbyDay mpd, @mpd t
WHERE mpd.datMailed = t.datMailed
AND mpd.PaperConfig_id = t.PaperConfig_id
AND mpd.Match = t.Match

INSERT INTO MailPagesbyDay (datMailed, PaperConfig_id, Match, Cnt) 
SELECT datMailed, PaperConfig_id, Match, Cnt
FROM @mpd


