SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [MERGEPROCESS_New].[vwQueue_Account]

AS

SELECT * FROM MERGEPROCESS_New.Queue WHERE 1=1
AND ObjectType = 'Account'
--AND FK_MergeID = 4




GO
