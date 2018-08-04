SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Prep]
AS 
SELECT
	  a.ssb_crmsystem_Contact_ID ssb_crmsystem_Contact_ID__c
      ,[FullName] Name
	  ,FirstName
	  ,LastName
	  ,NULLIF(Suffix,'') Suffix
      ,nullif([AddressPrimaryStreet],'') BillingStreet
      ,NULLIF(nullif([AddressPrimaryCity],''),'**') BillingCity
      ,nullif([AddressPrimaryState],'') BillingState
      ,nullif([AddressPrimaryZip],'') BillingPostalCode
      ,nullif([AddressPrimaryCountry],'') BillingCountry
      ,nullif([Phone],'') Phone
      ,[crm_id] Id
	  ,c.[LoadType]
  FROM [dbo].Contact a WITH (NOLOCK)
INNER JOIN dbo.[CRMLoad_Contact_ProcessLoad_Criteria] c WITH (NOLOCK) ON [c].ssb_crmsystem_Contact_ID = [a].ssb_crmsystem_Contact_ID


GO
