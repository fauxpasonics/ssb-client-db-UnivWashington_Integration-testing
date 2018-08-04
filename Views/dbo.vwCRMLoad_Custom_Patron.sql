SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Custom_Patron]
AS
SELECT DISTINCT a.[crm_id] Account__c, a.[SSB_CRMSYSTEM_Contact_ID] SSB_CRMSYSTEM_CONTACT_ID__c,dimcust.[SSID] Patron_ID__c
FROM dbo.[vwDimCustomer_ModAcctId] dimcust WITH (NOLOCK)
JOIN dbo.[Contact] a WITH (NOLOCK) ON dimcust.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_CONTACT_ID] 
LEFT JOIN prodcopy.patron__c z WITH (NOLOCK) ON dimcust.ssid = z.patron_id__c AND z.isdeleted = 0
LEFT JOIN prodcopy.account acct WITH (NOLOCK) ON acct.id = a.crm_id AND acct.IsDeleted = 0
WHERE dimcust.[SourceSystem] = 'Paciolan' --updateme
AND a.[SSB_CRMSYSTEM_CONTACT_ID] <> [a].[crm_id]
AND acct.id IS NOT NULL
AND (z.id IS NULL OR acct.id != z.account__c OR  a.SSB_CRMSYSTEM_CONTACT_ID != z.SSB_CRMSYSTEM_CONTACT_ID__c )






GO
