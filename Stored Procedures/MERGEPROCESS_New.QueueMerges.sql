SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [MERGEPROCESS_New].[QueueMerges] --TrailBlazers
--Exec  [MERGEPROCESS_New].[QueueMerges] 'UnivWashington'
	@Client VARCHAR(100) 
AS
--Declare @Client VARCHAR(100) ='Raiders'
DECLARE @Account VARCHAR(100) = (SELECT CASE WHEN @client = 'UnivWashington' THEN 'UW PC_SFDC Account' ELSE CONCAT(@client,' PC_SFDC Account' ) END);
DECLARE @Contact VARCHAR(100) = (SELECT CASE WHEN @client = 'UnivWashington' THEN 'UW PC_SFDC Contact' ELSE CONCAT(@client,' PC_SFDC Contact' ) END );

--WITH only2Acct as
TRUNCATE TABLE MERGEPROCESS_New.Queue 
INSERT INTO MERGEPROCESS_New.Queue

SELECT PK_MergeID, b.MergeType,  MAX(CASE WHEN xRank =1 THEN CAST(c.ID AS VARCHAR(100)) END) AS Winner, MAX(CASE WHEN xRank =2 THEN CAST(c.ID AS VARCHAR(100)) END) AS Loser
FROM mergeprocess_new.tmp_dimcust a 
JOIN MERGEPROCESS_New.DetectedMerges b with (nolock) ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSBID AND SourceSystem = @Account
JOIN MERGEPROCESS_New.vwMergeAccountRanks c ON a.SSID = c.ID --removed cast
WHERE ((AutoMerge = 1 and NumRecords < 4 AND b.NumRecords != 1) OR Approved = 1)
AND b.MergeType = 'Account'
AND MergeComplete = 0 
GROUP BY PK_MergeID,b.MergeType
HAVING MAX(CASE WHEN xRank =1 THEN CAST(c.ID AS VARCHAR(100)) END) IS NOT NULL AND  MAX(CASE WHEN xRank =2 THEN CAST(c.ID AS VARCHAR(100)) END) IS NOT NULL



GO
