SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwCRMLoad_Account_Custom_Update]
AS
SELECT  
	 z.[crm_id] Id
	, b.[SSB_CRMSYSTEM_Contact_ID__c] 
	, b.[SSB_CRMSYSTEM_SSID_Winner__c] 
	, b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] 
	, b.[SSB_CRMSYSTEM_SSID_TIX__c] 
	, b.[SSB_CRMSYSTEM_DimCustomerID__c] 
	, b.[AccountId] 
	, b.[CRMProcess_UpdatedDate]
	, b.[PersonOtherPhone]
	, b.[PersonEmail] 
	, b.[PersonHomePhone]
	,z.AddressPrimaryStreet	PersonMailingStreet
	,z.AddressPrimaryCity	PersonMailingCity
	,z.AddressPrimaryState	PersonMailingState
	,z.AddressPrimaryZip	PersonMailingPostalCode
	,z.AddressPrimaryCountry PersonMailingCountry
FROM dbo.[vwCRMLoad_Account_Std_Prep] a
INNER JOIN dbo.Contact_Custom b ON [a].[ssb_crmsystem_Contact_ID__c] = b.ssb_crmsystem_Contact_ID__c
INNER JOIN dbo.Contact z ON a.[ssb_crmsystem_Contact_ID__c] = z.ssb_crmsystem_Contact_ID
LEFT JOIN prodcopy.Account AA ON z.crm_ID = aa.ID
WHERE z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id]
AND (ISNULL(b.SSB_CRMSYSTEM_SSID_Winner__c,'') != ISNULL(aa.ssb_crmsystem_ssid_winner__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c],'') != ISNULL(aa.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_SSID_TIX__c],'') != 	ISNULL(aa.[SSB_CRMSYSTEM_SSID_Paciolan__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_DimCustomerID__c],'') != ISNULL(aa.[SSB_CRMSYSTEM_DimCustomerID__c],'')
	OR ISNULL(b.[PersonOtherPhone],'') != ISNULL(aa.[PersonOtherPhone],'')
	OR ISNULL(b.[PersonEmail],'') != ISNULL(aa.[PersonEmail],'')
	OR ISNULL(b.[PersonHomePhone],'') != ISNULL(aa.[PersonHomePhone],'')
	OR ISNULL(z.AddressPrimaryStreet,'') != ISNULL(aa.PersonMailingStreet,'')
	OR ISNULL(z.AddressPrimaryCity,'') != ISNULL(aa.PersonMailingCity,'')
	OR ISNULL(z.AddressPrimaryState,'') != ISNULL(aa.PersonMailingState,'')
	OR ISNULL(z.AddressPrimaryZip,'') != ISNULL(aa.PersonMailingPostalCode,'')
	OR ISNULL(z.AddressPrimaryCountry,'') != ISNULL(aa.PersonMailingCountry,'')
)


GO
