SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [MERGEPROCESS_New].[vwMergeAccountRanks]

AS

SELECT a.SSBID
	, c.ID
	--Add in custom ranking here
	,ROW_NUMBER() OVER(PARTITION BY SSBID ORDER BY CASE WHEN d.name like '%ETL%' OR d.name LIKE '%SSB%' THEN 0  --UpdateME
														WHEN d.IsActive = 0 THEN 1 ELSE 99 
														END DESC, c.createddate DESC) xRank
FROM MERGEPROCESS_New.DetectedMerges a with (nolock)
JOIN mergeprocess_new.tmp_dimcust b with (nolock)
	ON a.SSBID = b.SSB_CRMSYSTEM_CONTACT_ID
	AND a.MergeType = 'Account'
JOIN mergeprocess_new.tmp_pcaccount c with (nolock)
	ON b.SSID = ID
JOIN [ProdCopy].[vw_User] d
	ON c.OwnerId = d.Id
WHERE MergeComplete = 0;





GO
