SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [MERGEPROCESS_New].[PreMerge]
	AS 
Declare @LogDate datetime = (Select getdate())

INSERT INTO MERGEPROCESS_New.LogPreMergeAccount
(
	FK_MergeID
	,ObjectType
	,MergeRecordType
	,LogDate
--update with prodcopy fields
	,	Id
,	IsDeleted
,	MasterRecordId
,	Name
,	Type
,	ParentId
,	BillingStreet
,	BillingCity
,	BillingState
,	BillingPostalCode
,	BillingCountry
,	BillingLatitude
,	BillingLongitude
,	BillingGeocodeAccuracy
,	BillingAddress
,	ShippingStreet
,	ShippingCity
,	ShippingState
,	ShippingPostalCode
,	ShippingCountry
,	ShippingLatitude
,	ShippingLongitude
,	ShippingGeocodeAccuracy
,	ShippingAddress
,	Phone
,	Fax
,	Website
,	PhotoUrl
,	Industry
,	AnnualRevenue
,	NumberOfEmployees
,	Description
,	OwnerId
,	CreatedDate
,	CreatedById
,	LastModifiedDate
,	LastModifiedById
,	SystemModstamp
,	LastActivityDate
,	LastViewedDate
,	LastReferencedDate
,	Jigsaw
,	JigsawCompanyId
,	AccountSource
,	SicDesc
,	copyloaddate
,	LastName
,	FirstName
,	Salutation
,	RecordTypeId
,	PersonContactId
,	IsPersonAccount
,	PersonMailingStreet
,	PersonMailingCity
,	PersonMailingState
,	PersonMailingPostalCode
,	PersonMailingCountry
,	PersonMailingLatitude
,	PersonMailingLongitude
,	PersonMailingGeocodeAccuracy
,	PersonMailingAddress
,	PersonOtherStreet
,	PersonOtherCity
,	PersonOtherState
,	PersonOtherPostalCode
,	PersonOtherCountry
,	PersonOtherLatitude
,	PersonOtherLongitude
,	PersonOtherGeocodeAccuracy
,	PersonOtherAddress
,	PersonMobilePhone
,	PersonHomePhone
,	PersonOtherPhone
,	PersonAssistantPhone
,	PersonEmail
,	PersonTitle
,	PersonDepartment
,	PersonAssistantName
,	PersonLeadSource
,	PersonBirthdate
,	PersonLastCURequestDate
,	PersonLastCUUpdateDate
,	PersonEmailBouncedReason
,	PersonEmailBouncedDate
,	Account_Flag__c
,	Account_Warning__c
,	Business_Email__c
,	Business_Other_Phone__c
,	Employer__c
,	Football_Full__c
,	Football_Partial__c
,	Football_Rookie__c
,	Full_Account_ID__c
,	Full_PAContact_ID__c
,	Men_s_Basketball_Full__c
,	Men_s_Basketball_Partial__c
,	Men_s_Basketball_Rookie__c
,	Patron_ID__c
,	Reasons_Why_Bought__c
,	SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c
,	SSB_CRMSYSTEM_ACCT_ID__c
,	SSB_CRMSYSTEM_Contact_ID__c
,	SSB_CRMSYSTEM_SSID_Paciolan__c
,	Suffix__c
,	SSB_CRMSYSTEM_DimCustomerID__c
,	SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c
,	SSB_CRMSYSTEM_Last_Donation_Date__c
,	SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
,	SSB_CRMSYSTEM_SSID_Winner__c
,	SSB_CRMSYSTEM_Donor_Warning_Flag__c
,	SSB_CRMSYSTEM_Donor_ID__c
,	SSB_CRMSYSTEM_Email_Unsubscribe__c
,	SSB_CRMSYSTEM_Total_Priority_Points__c
,	SSB_CRMSYSTEM_Priority_Point_Rank__c
,	SSB_CRMSYSTEM_Customer_Type__c
,	SSB_CRMSYSTEM_Customer_Comments__c
,	SSB_CRMSYSTEM_Development_Owner__c
,	Full_Contact_ID__pc
,	Inactive__pc
,	School_Alum_Spouse__pc
,	School_Alum__pc
,	School_Grad_Year_Spouse__pc
,	School_Grad_Year__pc
,	School_Student_Athlete_Spouse__pc
,	School_Student_Athlete__pc
,	Secondary_Email__pc
,	SSB_CRMSYSTEM_Football_STH__c
,	SSB_CRMSYSTEM_Football_Rookie__c
,	SSB_CRMSYSTEM_Football_Partial__c
,	SSB_CRMSYSTEM_Men_s_Basketball_STH__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Partial__c
,	SSB_CRMSYSTEM_Donor_Warning__c
,	SSB_CRMSYSTEM_Adobe_Unsubscribe__c


)
Select a.FK_MergeID,ObjectType, 'Winning' MergeRecordType, @LogDate LogDate
--update with prodcopy fields
,	Id
,	IsDeleted
,	MasterRecordId
,	Name
,	Type
,	ParentId
,	BillingStreet
,	BillingCity
,	BillingState
,	BillingPostalCode
,	BillingCountry
,	BillingLatitude
,	BillingLongitude
,	BillingGeocodeAccuracy
,	BillingAddress
,	ShippingStreet
,	ShippingCity
,	ShippingState
,	ShippingPostalCode
,	ShippingCountry
,	ShippingLatitude
,	ShippingLongitude
,	ShippingGeocodeAccuracy
,	ShippingAddress
,	Phone
,	Fax
,	Website
,	PhotoUrl
,	Industry
,	AnnualRevenue
,	NumberOfEmployees
,	Description
,	OwnerId
,	CreatedDate
,	CreatedById
,	LastModifiedDate
,	LastModifiedById
,	SystemModstamp
,	LastActivityDate
,	LastViewedDate
,	LastReferencedDate
,	Jigsaw
,	JigsawCompanyId
,	AccountSource
,	SicDesc
,	copyloaddate
,	LastName
,	FirstName
,	Salutation
,	RecordTypeId
,	PersonContactId
,	IsPersonAccount
,	PersonMailingStreet
,	PersonMailingCity
,	PersonMailingState
,	PersonMailingPostalCode
,	PersonMailingCountry
,	PersonMailingLatitude
,	PersonMailingLongitude
,	PersonMailingGeocodeAccuracy
,	PersonMailingAddress
,	PersonOtherStreet
,	PersonOtherCity
,	PersonOtherState
,	PersonOtherPostalCode
,	PersonOtherCountry
,	PersonOtherLatitude
,	PersonOtherLongitude
,	PersonOtherGeocodeAccuracy
,	PersonOtherAddress
,	PersonMobilePhone
,	PersonHomePhone
,	PersonOtherPhone
,	PersonAssistantPhone
,	PersonEmail
,	PersonTitle
,	PersonDepartment
,	PersonAssistantName
,	PersonLeadSource
,	PersonBirthdate
,	PersonLastCURequestDate
,	PersonLastCUUpdateDate
,	PersonEmailBouncedReason
,	PersonEmailBouncedDate
,	Account_Flag__c
,	Account_Warning__c
,	Business_Email__c
,	Business_Other_Phone__c
,	Employer__c
,	Football_Full__c
,	Football_Partial__c
,	Football_Rookie__c
,	Full_Account_ID__c
,	Full_PAContact_ID__c
,	Men_s_Basketball_Full__c
,	Men_s_Basketball_Partial__c
,	Men_s_Basketball_Rookie__c
,	Patron_ID__c
,	Reasons_Why_Bought__c
,	SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c
,	SSB_CRMSYSTEM_ACCT_ID__c
,	SSB_CRMSYSTEM_Contact_ID__c
,	SSB_CRMSYSTEM_SSID_Paciolan__c
,	Suffix__c
,	SSB_CRMSYSTEM_DimCustomerID__c
,	SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c
,	SSB_CRMSYSTEM_Last_Donation_Date__c
,	SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
,	SSB_CRMSYSTEM_SSID_Winner__c
,	SSB_CRMSYSTEM_Donor_Warning_Flag__c
,	SSB_CRMSYSTEM_Donor_ID__c
,	SSB_CRMSYSTEM_Email_Unsubscribe__c
,	SSB_CRMSYSTEM_Total_Priority_Points__c
,	SSB_CRMSYSTEM_Priority_Point_Rank__c
,	SSB_CRMSYSTEM_Customer_Type__c
,	SSB_CRMSYSTEM_Customer_Comments__c
,	SSB_CRMSYSTEM_Development_Owner__c
,	Full_Contact_ID__pc
,	Inactive__pc
,	School_Alum_Spouse__pc
,	School_Alum__pc
,	School_Grad_Year_Spouse__pc
,	School_Grad_Year__pc
,	School_Student_Athlete_Spouse__pc
,	School_Student_Athlete__pc
,	Secondary_Email__pc
,	SSB_CRMSYSTEM_Football_STH__c
,	SSB_CRMSYSTEM_Football_Rookie__c
,	SSB_CRMSYSTEM_Football_Partial__c
,	SSB_CRMSYSTEM_Men_s_Basketball_STH__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Partial__c
,	SSB_CRMSYSTEM_Donor_Warning__c
,	SSB_CRMSYSTEM_Adobe_Unsubscribe__c


FROM MERGEPROCESS_New.Queue a with (nolock)
JOIN mergeprocess_new.tmp_pcaccount b with (nolock)
	ON a.Winning_ID = b.ID
UNION ALL
Select a.FK_MergeID,ObjectType, 'Losing' MergeRecordType, @LogDate LogDate
--update with prodcopy fields
,	Id
,	IsDeleted
,	MasterRecordId
,	Name
,	Type
,	ParentId
,	BillingStreet
,	BillingCity
,	BillingState
,	BillingPostalCode
,	BillingCountry
,	BillingLatitude
,	BillingLongitude
,	BillingGeocodeAccuracy
,	BillingAddress
,	ShippingStreet
,	ShippingCity
,	ShippingState
,	ShippingPostalCode
,	ShippingCountry
,	ShippingLatitude
,	ShippingLongitude
,	ShippingGeocodeAccuracy
,	ShippingAddress
,	Phone
,	Fax
,	Website
,	PhotoUrl
,	Industry
,	AnnualRevenue
,	NumberOfEmployees
,	Description
,	OwnerId
,	CreatedDate
,	CreatedById
,	LastModifiedDate
,	LastModifiedById
,	SystemModstamp
,	LastActivityDate
,	LastViewedDate
,	LastReferencedDate
,	Jigsaw
,	JigsawCompanyId
,	AccountSource
,	SicDesc
,	copyloaddate
,	LastName
,	FirstName
,	Salutation
,	RecordTypeId
,	PersonContactId
,	IsPersonAccount
,	PersonMailingStreet
,	PersonMailingCity
,	PersonMailingState
,	PersonMailingPostalCode
,	PersonMailingCountry
,	PersonMailingLatitude
,	PersonMailingLongitude
,	PersonMailingGeocodeAccuracy
,	PersonMailingAddress
,	PersonOtherStreet
,	PersonOtherCity
,	PersonOtherState
,	PersonOtherPostalCode
,	PersonOtherCountry
,	PersonOtherLatitude
,	PersonOtherLongitude
,	PersonOtherGeocodeAccuracy
,	PersonOtherAddress
,	PersonMobilePhone
,	PersonHomePhone
,	PersonOtherPhone
,	PersonAssistantPhone
,	PersonEmail
,	PersonTitle
,	PersonDepartment
,	PersonAssistantName
,	PersonLeadSource
,	PersonBirthdate
,	PersonLastCURequestDate
,	PersonLastCUUpdateDate
,	PersonEmailBouncedReason
,	PersonEmailBouncedDate
,	Account_Flag__c
,	Account_Warning__c
,	Business_Email__c
,	Business_Other_Phone__c
,	Employer__c
,	Football_Full__c
,	Football_Partial__c
,	Football_Rookie__c
,	Full_Account_ID__c
,	Full_PAContact_ID__c
,	Men_s_Basketball_Full__c
,	Men_s_Basketball_Partial__c
,	Men_s_Basketball_Rookie__c
,	Patron_ID__c
,	Reasons_Why_Bought__c
,	SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c
,	SSB_CRMSYSTEM_ACCT_ID__c
,	SSB_CRMSYSTEM_Contact_ID__c
,	SSB_CRMSYSTEM_SSID_Paciolan__c
,	Suffix__c
,	SSB_CRMSYSTEM_DimCustomerID__c
,	SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c
,	SSB_CRMSYSTEM_Last_Donation_Date__c
,	SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c
,	SSB_CRMSYSTEM_SSID_Winner__c
,	SSB_CRMSYSTEM_Donor_Warning_Flag__c
,	SSB_CRMSYSTEM_Donor_ID__c
,	SSB_CRMSYSTEM_Email_Unsubscribe__c
,	SSB_CRMSYSTEM_Total_Priority_Points__c
,	SSB_CRMSYSTEM_Priority_Point_Rank__c
,	SSB_CRMSYSTEM_Customer_Type__c
,	SSB_CRMSYSTEM_Customer_Comments__c
,	SSB_CRMSYSTEM_Development_Owner__c
,	Full_Contact_ID__pc
,	Inactive__pc
,	School_Alum_Spouse__pc
,	School_Alum__pc
,	School_Grad_Year_Spouse__pc
,	School_Grad_Year__pc
,	School_Student_Athlete_Spouse__pc
,	School_Student_Athlete__pc
,	Secondary_Email__pc
,	SSB_CRMSYSTEM_Football_STH__c
,	SSB_CRMSYSTEM_Football_Rookie__c
,	SSB_CRMSYSTEM_Football_Partial__c
,	SSB_CRMSYSTEM_Men_s_Basketball_STH__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c
,	SSB_CRMSYSTEM_Men_s_Basketball_Partial__c
,	SSB_CRMSYSTEM_Donor_Warning__c
,	SSB_CRMSYSTEM_Adobe_Unsubscribe__c


FROM MERGEPROCESS_New.Queue a with (nolock)
JOIN mergeprocess_new.tmp_pcaccount b with (nolock)
	ON a.Losing_ID = b.ID


GO
