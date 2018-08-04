SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [MERGEPROCESS_New].[MergeDetect]  --OleMiss --'raiders'
--[MERGEPROCESS_New].[MergeDetect]  'UnivWashington'
	@Client VARCHAR(100) 
AS
Declare @Date Date = (select cast(getdate() as date));
DECLARE @Account varchar(100) = (Select CASE WHEN @client = 'UnivWashington' THEN 'UW PC_SFDC Account' ELSE Concat(@client,' PC_SFDC Account' ) END); --updateme
--DECLARE @Contact varchar(100) = (Select CASE WHEN @client = 'TrailBlazers' THEN 'CRM_Contact' ELSE Concat(@client,' PC_SFDC Contact' ) END );

With MergeAccount as (
select ISNULL(SSB_CRMSYSTEM_CONTACT_ID,SSB_CRMSYSTEM_ACCT_ID) SSB_CRMSYSTEM_CONTACT_ID, count(1) CountAccounts,
MAX(CASE WHEN k.SSID is not null then 1 else 0 END) Key_Related, MAX(pca.recordtypeid) MAX_RT, MIN(pca.recordtypeid) MIN_RT
from dbo.vwDimCustomer_ModAcctID a 
left join dbo.vw_KeyAccounts k on a.ssb_crmsystem_contact_id = k.ssbid
inner join prodcopy.account pca with (nolock)
on a.ssid = pca.id and a.sourcesystem = @Account
where 
--SourceSystem = @Account AND 
ISNULL(SSB_CRMSYSTEM_CONTACT_ID,SSB_CRMSYSTEM_ACCT_ID) IS NOT NULL
group by ISNULL(SSB_CRMSYSTEM_CONTACT_ID,SSB_CRMSYSTEM_ACCT_ID)--, pca.recordtypeid
having count(1) > 1)


MERGE  MERGEPROCESS_New.DetectedMerges  as tar
using ( Select 'Account' MergeType, SSB_CRMSYSTEM_CONTACT_ID SSBID, CASE WHEN Key_Related = 0 and MAX_RT = MIN_RT THEN 1 ELSE 0 END AutoMerge, @Date DetectedDate, CountAccounts NumRecords FROM MergeAccount
		) as sour
	ON tar.MergeType = sour.MergeType
	AND tar.SSBID = sour.SSBID
WHEN MATCHED  AND (sour.DetectedDate <> tar.DetectedDate 
				OR sour.NumRecords <> tar.NumRecords
				OR sour.AutoMerge != tar.AutoMerge
				OR MergeComplete =  1
				OR 0 <> tar.Mergecomplete) THEN UPDATE 
	Set DetectedDate = @Date
	,NumRecords = sour.NumRecords
	,AutoMerge = sour.AutoMerge
	,MergeComplete = 0 
	,tar.MergeComment = NULL
WHEN Not Matched THEN Insert
	(MergeType
	,SSBID
	,AutoMerge
	,DetectedDate
	,NumRecords)
Values(
	 sour.MergeType
	,sour.SSBID
	,sour.AutoMerge
	,sour.DetectedDate
	,sour.NumRecords)
WHEN NOT MATCHED BY SOURCE AND tar.MergeComment IS NULL THEN UPDATE
	SET MergeComment = CASE WHEN tar.Mergecomplete = 1 then 'Merge Detection - Merge Successfully completed'
							WHEN tar.mergeComplete = 0 THEN 'Merge Detection - Merge not completed, but no longer detected' END
		,MergeComplete = 1
	;

UPDATE MERGEPROCESS_New.DetectedMerges SET AutoMerge = 1
FROM MERGEPROCESS_New.DetectedMerges dm
INNER JOIN MERGEPROCESS_New.ForceMerge fm
ON dm.PK_MergeID = fm.FK_MergeID AND fm.complete = 0
WHERE AutoMerge != 1

--Do we want to keep these materialized tables.
--Do we want to add a force merge capability
	
--SET UP FOR PERSON ACCOUNT MODEL
IF OBJECT_ID('mergeprocess_new.tmp_pcaccount', 'U') IS NOT NULL 
DROP TABLE mergeprocess_new.tmp_pcaccount; 

IF OBJECT_ID('mergeprocess_new.tmp_pccontact', 'U') IS NOT NULL 
DROP TABLE mergeprocess_new.tmp_pccontact;

IF OBJECT_ID('mergeprocess_new.tmp_dimcust', 'U') IS NOT NULL 
DROP TABLE mergeprocess_new.tmp_dimcust;

select * into mergeprocess_new.tmp_dimcust 
from dbo.vwdimcustomer_modacctid  where ssb_crmsystem_contact_id in (
select ssb_crmsystem_contact_id from dbo.vwdimcustomer_modacctid where sourcesystem = @Account group by ssb_crmsystem_contact_id having count(*) > 1 )
and sourcesystem = @Account

--create nonclustered index ix_tmp_dimcust_acct on mergeprocess_new.tmp_dimcust (sourcesystem, ssb_crmsystem_acct_id)
create nonclustered index ix_tmp_dimcust_contact on mergeprocess_new.tmp_dimcust (sourcesystem, ssb_crmsystem_contact_id)
create nonclustered index ix_tmp_dimcust_ssid on mergeprocess_new.tmp_dimcust (sourcesystem, ssid)
--0:05

--select pcc.* into mergeprocess_new.tmp_pccontact from mergeprocess_new.tmp_dimcust dc
--inner join prodcopy.vw_contact pcc on dc.ssid = pcc.id
--where dc.sourcesystem = @Contact
--0:07

select pca.* into mergeprocess_new.tmp_pcaccount from mergeprocess_new.tmp_dimcust dc
inner join prodcopy.vw_account pca with (nolock) on dc.ssid = pca.id
where dc.sourcesystem = @Account
--0:08

alter table mergeprocess_new.tmp_pcaccount
alter column id varchar(200)
----0:03

--alter table mergeprocess_new.tmp_pccontact
--alter column id varchar(200)
--0:02

create nonclustered index ix_tmp_pcaccount on mergeprocess_new.tmp_pcaccount (id)
--0:05

--create nonclustered index ix_tmp_pccontact on mergeprocess_new.tmp_pccontact (id)
--0:01
GO
