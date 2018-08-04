SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_CRMProcess_UpdateGUIDs_ProdCopy_Account]
as
UPDATE b
SET [b].SSB_CRMSYSTEM_Contact_ID__c = a.SSB_CRMSYSTEM_Contact_ID__c
--SELECT a.* 
FROM [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyAccount] a 
INNER JOIN ProdCopy.Account b ON a.Id = b.Id
WHERE ISNULL(b.SSB_CRMSYSTEM_Contact_ID__c,'a') <> ISNULL(a.SSB_CRMSYSTEM_Contact_ID__c,'a')



GO
