SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Upsert_Person] AS
SELECT --top 1

ssb_crmsystem_Contact_ID__c AS SSB_CRMSYSTEM_Contact_ID__c, a.FirstName, a.LastName ,a.Suffix AS Suffix__c, 
 BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, a.Phone, [LoadType]
 , CASE WHEN b.IsBusinessAccount = 1 THEN '0126A000000szcbQAA' ELSE '0126A000000szdeQAA' END RecordTypeId --updateme
FROM [dbo].[vwCRMLoad_Account_Std_Prep] a
JOIN dbo.Contact b ON a.ssb_crmsystem_Contact_ID__c = b.ssb_crmsystem_Contact_ID
WHERE LoadType = 'Upsert' AND b.IsBusinessAccount = 0
AND ssb_crmsystem_contact_id__c NOT IN ('41BB007B-D4DB-4FD0-A014-97BAAB61941F',
'12E5BC75-F7CE-45D3-B738-792B2A0B8358',
'604E2F55-804E-4CCC-98B9-CCE4D4FE5228',
'9FD551C4-755E-469B-9AC7-1D0EB89781D5',
'ADCB6224-072C-4326-92E7-F13E3391DD4E',
'FDFE97D1-F0A0-411A-8AD3-A8452D188001')





GO
