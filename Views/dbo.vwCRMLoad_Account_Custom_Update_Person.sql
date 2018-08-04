SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW  [dbo].[vwCRMLoad_Account_Custom_Update_Person]
AS
SELECT  
--b.ssb_crmsystem_Contact_ID,
	 z.[crm_id] Id
	, b.[SSB_CRMSYSTEM_Contact_ID__c] 
	, b.[SSB_CRMSYSTEM_SSID_Winner__c] 																					  --,aa.[SSB_CRMSYSTEM_SSID_Winner__c]
	, b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] 																	  --,aa.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]
	, b.[SSB_CRMSYSTEM_SSID_TIX__c] 																					  --,aa.[SSB_CRMSYSTEM_SSID_Paciolan__c]
	, b.[SSB_CRMSYSTEM_DimCustomerID__c] 																				  --,aa.[SSB_CRMSYSTEM_DimCustomerID__c]
	, b.[AccountId] 																									  --
	, b.[CRMProcess_UpdatedDate]																						  --
	, b.[PersonOtherPhone]																								  --,aa.[PersonOtherPhone]
	, b.[PersonEmail] 																									  --,aa.[PersonEmail]
	, b.[PersonHomePhone]																								  --,aa.[PersonHomePhone]
	,z.AddressPrimaryStreet	PersonMailingStreet																			  --,aa.PersonMailingStreet
	,z.AddressPrimaryCity	PersonMailingCity																			  --,aa.PersonMailingCity
	,z.AddressPrimaryState	PersonMailingState																			  --,aa.PersonMailingState
	,z.AddressPrimaryZip	PersonMailingPostalCode																		  --,aa.PersonMailingPostalCode
	,z.AddressPrimaryCountry PersonMailingCountry																		  --,aa.PersonMailingCountry
	, b.SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c																		  --,aa.SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
	, ISNULL(b.SSB_CRMSYSTEM_Football_STH__c,0)						   Football_Full__c									  --,aa.Football_Full__c
	, ISNULL(b.SSB_CRMSYSTEM_Football_Rookie__c,0)						   Football_Rookie__c							  --,aa.Football_Rookie__c
	, ISNULL(b.SSB_CRMSYSTEM_Football_Partial__c,0)					   Football_Partial__c								  --,aa.Football_Partial__c
	, ISNULL(b.SSB_CRMSYSTEM_Men_s_Basketball_STH__c,0)				   Men_s_Basketball_Full__c							  --,aa.Men_s_Basketball_Full__c
	, ISNULL(b.SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c,0)				   Men_s_Basketball_Rookie__c					  --,aa.Men_s_Basketball_Rookie__c
	, ISNULL(b.SSB_CRMSYSTEM_Men_s_Basketball_Partial__c,0)			   Men_s_Basketball_Partial__c						  --,aa.Men_s_Basketball_Partial__c
	, b.SSB_CRMSYSTEM_Last_Donation_Date__c																				  --,aa.SSB_CRMSYSTEM_Last_Donation_Date__c
	, b.SSB_CRMSYSTEM_Donor_ID__c																						  --,aa.SSB_CRMSYSTEM_Donor_ID__c
	, b.SSB_CRMSYSTEM_Donor_Warning__c																					  --,aa.SSB_CRMSYSTEM_Donor_Warning__c
	, b.SSB_CRMSYSTEM_Development_Owner__c																				  --,aa.SSB_CRMSYSTEM_Development_Owner__c
	, b.SSB_CRMSYSTEM_Total_Priority_Points__c																			  --,aa.SSB_CRMSYSTEM_Total_Priority_Points__c
	, b.SSB_CRMSYSTEM_Priority_Point_Rank__c																			  --,aa.SSB_CRMSYSTEM_Priority_Point_Rank__c
	, b.SSB_CRMSYSTEM_Customer_Type__c																					  --,aa.SSB_CRMSYSTEM_Customer_Type__c
	, b.SSB_CRMSYSTEM_Customer_Comments__c																				  --,aa.SSB_CRMSYSTEM_Customer_Comments__c
	, b.SSB_CRMSYSTEM_Adobe_Unsubscribe__c	SSB_CRMSYSTEM_Email_Unsubscribe__c											  --,aa.SSB_CRMSYSTEM_Email_Unsubscribe__c
	, b.SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c																		  --,aa.SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c
    , b.[Football_Rank__c] 																								  --,aa.[Football_Rank__c]
    , b.[Men_s_Basketball_Rank__c] 																						  --,aa.[Men_s_Basketball_Rank__c]
    , b.[Football_YOP__c] 																								  --,aa.[Football_YOP__c]
    , b.[Men_s_Basketball_YOP__c] 																						  --,aa.[Men_s_Basketball_YOP__c]
    , b.[Women_s_Basketball_YOP__c] 																					  --,aa.[Women_s_Basketball_YOP__c]
	, b.Football_Comp_Tickets__c																						  --,aa.Football_Comp_Tickets__c
	, b.Men_s_Basketball_Comp_Tickets__c																				  --,aa.Men_s_Basketball_Comp_Tickets__c
	, b.PersonMobilePhone																								  --,aa.PersonMobilePhone

	--,case when ISNULL(b.SSB_CRMSYSTEM_SSID_Winner__c,'') != ISNULL(aa.ssb_crmsystem_ssid_winner__c,'')																					then 1 else 0 end as [SSB_CRMSYSTEM_SSID_Winner__c]
	--,case when ISNULL(b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c],'') != ISNULL(aa.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c],'')													then 1 else 0 end as [SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]
	--,case when ISNULL(b.[SSB_CRMSYSTEM_SSID_TIX__c],'') != 	ISNULL(aa.[SSB_CRMSYSTEM_SSID_Paciolan__c],'')																				then 1 else 0 end as [SSB_CRMSYSTEM_SSID_Paciolan__c]
	--,case when ISNULL(b.[SSB_CRMSYSTEM_DimCustomerID__c],'') != ISNULL(aa.[SSB_CRMSYSTEM_DimCustomerID__c],'')																			then 1 else 0 end as [SSB_CRMSYSTEM_DimCustomerID__c]
	--,case when ISNULL(b.[PersonOtherPhone],'') != ISNULL(aa.[PersonOtherPhone],'')																										then 1 else 0 end as [PersonOtherPhone]
	--,case when ISNULL(b.[PersonEmail],'') != ISNULL(aa.[PersonEmail],'')																												then 1 else 0 end as [PersonEmail]
	--,case when ISNULL(b.[PersonHomePhone],'') != ISNULL(aa.[PersonHomePhone],'')																										then 1 else 0 end as [PersonHomePhone]
	--,case when ISNULL(z.AddressPrimaryStreet,'') != ISNULL(aa.PersonMailingStreet,'')																									then 1 else 0 end as PersonMailingStreet
	--,case when ISNULL(z.AddressPrimaryCity,'') != ISNULL(aa.PersonMailingCity,'')																										then 1 else 0 end as PersonMailingCity
	--,case when ISNULL(z.AddressPrimaryState,'') != ISNULL(aa.PersonMailingState,'')																										then 1 else 0 end as PersonMailingState
	--,case when ISNULL(z.AddressPrimaryZip,'') != ISNULL(aa.PersonMailingPostalCode,'')																									then 1 else 0 end as PersonMailingPostalCode
	--,case when ISNULL(z.AddressPrimaryCountry,'') != ISNULL(aa.PersonMailingCountry,'')																									then 1 else 0 end as PersonMailingCountry
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c],'')													then 1 else 0 end as SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Football_STH__c],'0') !=  ISNULL(aa.Football_Full__c,'')																							then 1 else 0 end as Football_Full__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Football_Rookie__c],'0') !=  ISNULL(aa.Football_Rookie__c,'')																					then 1 else 0 end as Football_Rookie__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Football_Partial__c],'0') !=  ISNULL(aa.Football_Partial__c,'')																					then 1 else 0 end as Football_Partial__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_STH__c],'0') !=  ISNULL(aa.Men_s_Basketball_Full__c,'')																			then 1 else 0 end as Men_s_Basketball_Full__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c],'0') !=  ISNULL(aa.Men_s_Basketball_Rookie__c,'')																	then 1 else 0 end as Men_s_Basketball_Rookie__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_Partial__c],'0') !=  ISNULL(aa.Men_s_Basketball_Partial__c,'')																	then 1 else 0 end as Men_s_Basketball_Partial__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Last_Donation_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Donation_Date__c],'')																then 1 else 0 end as SSB_CRMSYSTEM_Last_Donation_Date__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Donor_ID__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Donor_ID__c],'')																					then 1 else 0 end as SSB_CRMSYSTEM_Donor_ID__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Donor_Warning__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Donor_Warning__c],'')																			then 1 else 0 end as SSB_CRMSYSTEM_Donor_Warning__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Development_Owner__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Development_Owner__c],'')																	then 1 else 0 end as SSB_CRMSYSTEM_Development_Owner__c
	--,case when ISNULL(CAST(b.[SSB_CRMSYSTEM_Total_Priority_Points__c] AS decimal(18,2)),0) !=  ISNULL(CAST(aa.[SSB_CRMSYSTEM_Total_Priority_Points__c] AS decimal(18,2)),0)				then 1 else 0 end as SSB_CRMSYSTEM_Total_Priority_Points__c
	--,case when ISNULL(CAST(b.[SSB_CRMSYSTEM_Priority_Point_Rank__c] AS NVARCHAR(100)),'') !=  ISNULL(CAST(aa.[SSB_CRMSYSTEM_Priority_Point_Rank__c] AS NVARCHAR(100)),'')				then 1 else 0 end as SSB_CRMSYSTEM_Priority_Point_Rank__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Customer_Type__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Customer_Type__c],'')																			then 1 else 0 end as SSB_CRMSYSTEM_Customer_Type__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Customer_Comments__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Customer_Comments__c],'')																	then 1 else 0 end as SSB_CRMSYSTEM_Customer_Comments__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Adobe_Unsubscribe__c],'') !=  ISNULL(aa.SSB_CRMSYSTEM_Email_Unsubscribe__c,'')																	then 1 else 0 end as SSB_CRMSYSTEM_Email_Unsubscribe__c
	--,case when ISNULL(b.[SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c],'')												then 1 else 0 end as SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c
	--,case when ISNULL(b.[Football_Rank__c],'') !=  ISNULL(aa.[Football_Rank__c],'')																										then 1 else 0 end as [Football_Rank__c]
	--,case when ISNULL(b.[Men_s_Basketball_Rank__c],'') !=  ISNULL(aa.[Men_s_Basketball_Rank__c],'')																						then 1 else 0 end as [Men_s_Basketball_Rank__c]
	--,case when ISNULL(b.[Football_YOP__c],'') !=  ISNULL(aa.[Football_YOP__c],'')																										then 1 else 0 end as [Football_YOP__c]
	--,case when ISNULL(b.[Men_s_Basketball_YOP__c],'') !=  ISNULL(aa.[Men_s_Basketball_YOP__c],'')																						then 1 else 0 end as [Men_s_Basketball_YOP__c]
	--,case when ISNULL(b.[Women_s_Basketball_YOP__c],'') !=  ISNULL(aa.[Women_s_Basketball_YOP__c],'')																					then 1 else 0 end as [Women_s_Basketball_YOP__c]
	--,case when ISNULL(b.Football_Comp_Tickets__c,'0') !=  ISNULL(aa.Football_Comp_Tickets__c,'')																						then 1 else 0 end as Football_Comp_Tickets__c
	--,case when ISNULL(b.Men_s_Basketball_Comp_Tickets__c,'0') !=  ISNULL(aa.Men_s_Basketball_Comp_Tickets__c,'')																		then 1 else 0 end as Men_s_Basketball_Comp_Tickets__c
	--,case when ISNULL(b.PersonMobilePhone,'') !=  ISNULL(aa.PersonMobilePhone,'')																										then 1 else 0 end as PersonMobilePhone
																																														

	--select count(*)
FROM dbo.[vwCRMLoad_Account_Std_Prep] a
INNER JOIN dbo.Contact_Custom b ON [a].[ssb_crmsystem_Contact_ID__c] = b.ssb_crmsystem_Contact_ID__c
INNER JOIN dbo.Contact z ON a.[ssb_crmsystem_Contact_ID__c] = z.ssb_crmsystem_Contact_ID
LEFT JOIN prodcopy.Account AA ON z.crm_ID = aa.ID
LEFT JOIN prodcopy.RecordType rt ON aa.RecordTypeId = rt.Id
WHERE z.[SSB_CRMSYSTEM_Contact_ID] <> z.[crm_id]
AND ISNULL(CASE WHEN rt.name = 'Business Account' THEN 1 WHEN rt.name = 'Person Account' THEN 0 END, z.isbusinessaccount) = 0 --updated TCF 6/5/17 to correct name values (was Developer Name values)
AND (1=2
	OR ISNULL(b.SSB_CRMSYSTEM_SSID_Winner__c,'') != ISNULL(aa.ssb_crmsystem_ssid_winner__c,'')
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
	OR ISNULL(b.[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Football_STH__c],'0') !=  ISNULL(aa.Football_Full__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Football_Rookie__c],'0') !=  ISNULL(aa.Football_Rookie__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Football_Partial__c],'0') !=  ISNULL(aa.Football_Partial__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_STH__c],'0') !=  ISNULL(aa.Men_s_Basketball_Full__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c],'0') !=  ISNULL(aa.Men_s_Basketball_Rookie__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Men_s_Basketball_Partial__c],'0') !=  ISNULL(aa.Men_s_Basketball_Partial__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Last_Donation_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Donation_Date__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Donor_ID__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Donor_ID__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Donor_Warning__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Donor_Warning__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Development_Owner__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Development_Owner__c],'')
	OR ISNULL(CAST(b.[SSB_CRMSYSTEM_Total_Priority_Points__c] AS decimal(18,2)),0) !=  ISNULL(CAST(aa.[SSB_CRMSYSTEM_Total_Priority_Points__c] AS decimal(18,2)),0)
	OR ISNULL(CAST(b.[SSB_CRMSYSTEM_Priority_Point_Rank__c] AS NVARCHAR(100)),'') !=  ISNULL(CAST(aa.[SSB_CRMSYSTEM_Priority_Point_Rank__c] AS NVARCHAR(100)),'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Customer_Type__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Customer_Type__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Customer_Comments__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Customer_Comments__c],'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Adobe_Unsubscribe__c],'') !=  ISNULL(aa.SSB_CRMSYSTEM_Email_Unsubscribe__c,'')
	OR ISNULL(b.[SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c],'') !=  ISNULL(aa.[SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c],'')
	OR ISNULL(b.[Football_Rank__c],'') !=  ISNULL(aa.[Football_Rank__c],'')
	OR ISNULL(b.[Men_s_Basketball_Rank__c],'') !=  ISNULL(aa.[Men_s_Basketball_Rank__c],'')
	OR ISNULL(b.[Football_YOP__c],'') !=  ISNULL(aa.[Football_YOP__c],'')
	OR ISNULL(b.[Men_s_Basketball_YOP__c],'') !=  ISNULL(aa.[Men_s_Basketball_YOP__c],'')
	OR ISNULL(b.[Women_s_Basketball_YOP__c],'') !=  ISNULL(aa.[Women_s_Basketball_YOP__c],'')
	OR ISNULL(b.Football_Comp_Tickets__c,'0') !=  ISNULL(aa.Football_Comp_Tickets__c,'')
	OR ISNULL(b.Men_s_Basketball_Comp_Tickets__c,'0') !=  ISNULL(aa.Men_s_Basketball_Comp_Tickets__c,'')
	OR ISNULL(b.PersonMobilePhone,'') !=  ISNULL(aa.PersonMobilePhone,'')


)





GO
