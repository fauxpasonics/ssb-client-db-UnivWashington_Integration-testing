SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyAccount]
AS

SELECT DISTINCT b.SSID Id, b.SSB_CRMSYSTEM_Contact_ID SSB_CRMSYSTEM_Contact_ID__c
--, REPLACE(REPLACE(c.[new_ssbcrmsystemcontactid],'{',''),'}','')
FROM dbo.vwDimCustomer_ModAcctId b
INNER JOIN ProdCopy.vw_Account c WITH(NOLOCK) ON b.SSID = CAST(c.ID AS VARCHAR(50))
WHERE c.SSB_CRMSYSTEM_Contact_ID__c IS NULL OR c.SSB_CRMSYSTEM_Contact_ID__c <> b.SSB_CRMSYSTEM_Contact_ID

GO
