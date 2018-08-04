SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [wrk].[MergeDimCustomertoContact]

AS

BEGIN
	SET NOCOUNT ON;

DELETE a
--SELECT COUNT(*) 
FROM dbo.Contact a
LEFT JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[DimCustomerId] IS NULL 

DELETE a
--SELECT COUNT(*) 
FROM dbo.Contact a
LEFT JOIN [dbo].[vwCRMProcess_DistinctContacts_CriteriaMet] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[SSB_CRMSYSTEM_CONTACT_ID] IS NULL 


TRUNCATE TABLE wrk.customerWorkingList

-- LOAD TM ONLY Accounts within Timeframe
INSERT INTO wrk.customerWorkingList (DimCustomerID, [SSB_CRMSYSTEM_CONTACT_ID], IsPersonAccount, IsBusinessAccount, MDM_UpdatedDate, CRMProcess_UpdatedDate
, SSID_Winner, SourceSystem)
SELECT a.dimcustomerid DimCustomerID
, a.[SSB_CRMSYSTEM_CONTACT_ID] [SSB_CRMSYSTEM_CONTACT_ID]
, CASE WHEN a.IsBusiness = 1 THEN 0 ELSE 1 END IsPersonAccount
, CASE WHEN a.IsBusiness = 1 THEN 1 ELSE 0 END IsBusinessAccount
, a.UpdatedDate MDM_LastUpdated
, GETDATE() SFDCProcess_UpdatedDate
, CASE WHEN SourceSystem LIKE '%CRM%' OR SourceSystem LIKE '%SFDC%' THEN '' ELSE [b].[CRM_FriendlyName] + ' - ' + a.SSID END SSID_Winner 
, a.SourceSystem
-- SELECT COUNT(*)
--INTO wrk.customerWorkingList
 FROM  dbo.vwCompositeRecord_ModAcctID a
 LEFT JOIN dbo.[CRMProcess_SourceSystem_Translation] b ON a.[SourceSystem] = b.[MDM_SourceSystem]
WHERE 1=1
--AND a.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG = 1
--AND a.IsBusiness = 1
AND a.SSB_CRMSYSTEM_ACCT_ID IN (SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID FROM [dbo].[vwCRMProcess_DistinctAccounts_CriteriaMet])
--AND a.SSB_CRMSYSTEM_ACCT_ID IN (SELECT Distinct ISNULL(SSB_CRMSYSTEM_ACCT_ID,SSB_CRMSYSTEM_ACCT_ID) FROM dbo.[vwDimCustomer_ModAcctId] WHERE UpdatedDate >= @LastLoadDate)
--AND a.CustomerType = 'Primary'


-- Load Accounts missing
INSERT INTO wrk.customerWorkingList (DimCustomerID, [SSB_CRMSYSTEM_CONTACT_ID], IsPersonAccount, IsBusinessAccount, MDM_UpdatedDate, CRMProcess_UpdatedDate
, SSID_Winner, SourceSystem)
SELECT a.dimcustomerid DimCustomerID
, a.[SSB_CRMSYSTEM_CONTACT_ID] [SSB_CRMSYSTEM_CONTACT_ID]
, CASE WHEN a.IsBusiness = 1 THEN 0 ELSE 1 END IsPersonAccount
, CASE WHEN a.IsBusiness = 1 THEN 1 ELSE 0 END IsBusinessAccount
, a.UpdatedDate MDM_LastUpdated
, GETDATE() SFDCProcess_UpdatedDate
, CASE WHEN SourceSystem LIKE '%CRM%' OR SourceSystem LIKE '%SFDC%' THEN '' ELSE [b].[CRM_FriendlyName] + ' - ' + a.SSID END SSID_Winner 
, a.SourceSystem
-- SELECT COUNT(*)
--INTO #tmpTest
 from [dbo].[vwDimCustomer_ModAcctId] a
 LEFT JOIN dbo.[CRMProcess_SourceSystem_Translation] b ON a.[SourceSystem] = b.[MDM_SourceSystem]
where 1=1
and a.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
--AND a.IsBusiness = 1
AND a.[SSB_CRMSYSTEM_CONTACT_ID] IN (SELECT DISTINCT [SSB_CRMSYSTEM_CONTACT_ID] FROM [dbo].[vwCRMProcess_DistinctContacts_CriteriaMet])
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] FROM wrk.customerWorkingList)
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] FROM dbo.contact)


TRUNCATE TABLE stg.Contact

INSERT INTO stg.Contact
        ( SSB_CRMSYSTEM_ACCT_ID ,
		  SSB_CRMSYSTEM_Contact_ID ,
          [IsBusinessAccount] ,
          [FullName] ,
          [FirstName] ,
          [LastName] ,
		  Suffix ,
          [AddressPrimaryStreet] ,
          [AddressPrimaryCity] ,
          [AddressPrimaryState] ,
          [AddressPrimaryZip] ,
          [AddressPrimaryCountry] ,
          [Phone] ,
          [EmailPrimary] ,
          [MDM_UpdatedDate] ,
		  [CRMProcess_UpdatedDate]
        )       
select 
dc.SSB_CRMSYSTEM_ACCT_ID
, dc.SSB_CRMSYSTEM_Contact_ID
, isbusinessAccount as IsBusinessAccount
, COALESCE(CASE WHEN dc.IsBusiness = 1 THEN CompanyName ELSE NULL END,FullName, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') + CASE WHEN ISNULL(Suffix,'') <> '' THEN ' ' + Suffix ELSE ''END) FullName
, FirstName
, LastName
, Suffix
, AddressPrimaryStreet + ' ' + AddressPrimarySuite AS BillingStreet
, AddressPrimaryCity as BillingCity
, AddressPrimaryState as BillingState
, AddressPrimaryZip as BillingPostalCode
, AddressPrimaryCountry as BillingCountry
, dc.PhonePrimary AS Phone
, dc.EmailPrimary AS Email
, MDM_UpdatedDate as MDM_UpdatedDate
, GETDATE() AS CRMProcess_UpdatedDate
FROM dbo.[vwCompositeRecord_ModAcctID] dc 
join  wrk.customerWorkingList wrlist ON dc.DimCustomerID = wrlist.DimCustomerID
--LEFT JOIN dbo.SFDCProcess_DistinctAccounts da ON dc.SSB_CRMSYSTEM_ACCT_ID = da.SSB_CRMSYSTEM_ACCT_ID


--peform merge ..update all contact ids that are eligible and cross them
-- TRUNCATE TABLE dbo.Account
MERGE INTO dbo.contact AS target
USING  stg.contact AS SOURCE 
ON target.SSB_CRMSYSTEM_Contact_ID = source.SSB_CRMSYSTEM_Contact_ID
WHEN MATCHED THEN UPDATE SET
TARGET.SSB_CRMSYSTEM_ACCT_ID = SOURCE.SSB_CRMSYSTEM_ACCT_ID
, TARGET.IsBusinessAccount = SOURCE.IsBusinessAccount
, TARGET.FullName = SOURCE.FullName
, TARGET.FirstName = SOURCE.FirstName
, TARGET.LastName = SOURCE.LastName
, TARGET.Suffix = SOURCE.Suffix
, TARGET.[AddressPrimaryStreet] = SOURCE.[AddressPrimaryStreet]
, TARGET.[AddressPrimaryCity] = SOURCE.[AddressPrimaryCity]
, TARGET.[AddressPrimaryState] = SOURCE.[AddressPrimaryState]
, TARGET.[AddressPrimaryZip] = SOURCE.[AddressPrimaryZip]
, TARGET.[AddressPrimaryCountry] = SOURCE.[AddressPrimaryCountry]
, TARGET.Phone = SOURCE.Phone
, TARGET.[EmailPrimary] = SOURCE.[EmailPrimary]
, TARGET.MDM_UpdatedDate = SOURCE.MDM_UpdatedDate
, TARGET.[CRMProcess_UpdatedDate] = SOURCE.[CRMProcess_UpdatedDate]
WHEN NOT MATCHED THEN 
INSERT 
(
		  SSB_CRMSYSTEM_ACCT_ID ,
		  SSB_CRMSYSTEM_Contact_ID ,
          [IsBusinessAccount] ,
          [FullName] ,
          [FirstName] ,
          [LastName] ,
		  Suffix ,
          [AddressPrimaryStreet] ,
          [AddressPrimaryCity] ,
          [AddressPrimaryState] ,
          [AddressPrimaryZip] ,
          [AddressPrimaryCountry] ,
          [Phone] ,
          [EmailPrimary] ,
          [MDM_UpdatedDate] ,
		  [CRMProcess_UpdatedDate],
		  CRM_ID
)
VALUES
(
		  SOURCE.SSB_CRMSYSTEM_ACCT_ID
		, SOURCE.SSB_CRMSYSTEM_Contact_ID
		, SOURCE.IsBusinessAccount
		, SOURCE.FullName
		, SOURCE.FirstName
		, SOURCE.LastName
		, Source.Suffix
		, SOURCE.[AddressPrimaryStreet]
		, SOURCE.[AddressPrimaryCity]
		, SOURCE.[AddressPrimaryState]
		, SOURCE.[AddressPrimaryZip]
		, SOURCE.[AddressPrimaryCountry]
		, SOURCE.Phone
		, SOURCE.[EmailPrimary]
		, SOURCE.MDM_UpdatedDate
		, SOURCE.CRMProcess_UpdatedDate
		, SOURCE.SSB_CRMSYSTEM_Contact_ID
);


-- Assign CRM IDs in dbo.Account
EXEC dbo.sp_CRMProcess_CRMID_Assign_Contact

--SELECT COUNT(*) FROM dbo.[CRMLoad_Account_ProcessLoad_Criteria]

--DROP TABLE #tmpA
--DROP TABLE #tmpNewSSIDs
--DROP TABLE #tmpGUIDLookup
--DROP TABLE #tmpGUIDResults
--DROP TABLE #LoserSSIDs
--DROP TABLE #tmpRedoSSIDs_Acct

END




GO
