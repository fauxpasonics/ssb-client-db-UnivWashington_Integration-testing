SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/***?------------------------------------------------------------------------------- 
-- Author name: Abbey Meitin
-- Created date: before we started tracking
-- Purpose: CRM Contact Custom Field Logic
-- Copyright © 2018, SSB, All Rights Reserved 
------------------------------------------------------------------------------- 
-- Modification History -- 
-- 05/24/2018: Abbey Meitin
-- Updated the @fbcurrentyear and @fbprioryear parameters
-- Reviewed by Harry Jordheim

-- 06/20/2018: Abbey Meitin
	Updated Season Year to first reference Config_SeasonYear
	Fixed Football Rookie join on prior year; will need to make the same change 
	on MBB when they give us the go ahead to flip seasons

-- 6/22/2018: Payton Soicher
	Confirmed that process works in Dev with no errors

-- 7/6/2018: Abbey Meitin
	Updated rookie flag to pull from FactTicketSales instead of FactTicketSalesHistory

-- 8/1/18: Tommy Franics
	Put in Service Owner logic.

------------------------------------------------------------------------------- ***/


CREATE PROCEDURE [wrk].[sp_Contact_Custom]
AS
	TRUNCATE TABLE dbo.Contact_Custom;

	MERGE INTO dbo.Contact_Custom Target
	USING dbo.[Contact] source
	ON source.[SSB_CRMSYSTEM_Contact_ID] = Target.[SSB_CRMSYSTEM_Contact_ID__c]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (
				   [SSB_CRMSYSTEM_Contact_ID__c]
			   )
		VALUES ( source.[SSB_CRMSYSTEM_Contact_ID] )
	WHEN NOT MATCHED BY SOURCE THEN DELETE;

	EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact';

	DECLARE @currentmemberyear INT = (
										 SELECT DATEPART(YEAR, GETDATE())
									 );

	DECLARE @previousmemberyear INT = @currentmemberyear - 1;


	UPDATE a
	SET	   [SSB_CRMSYSTEM_SSID_Winner__c] = b.SSID
		   , a.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] = b.SourceSystem
		   , [PersonHomePhone] = b.PhoneHome
		   , [PersonOtherPhone] = b.PhoneOther
		   , [PersonEmail] = b.EmailOne
		   , [PersonBirthdate] = b.Birthday
		   , [SSB_CRMSYSTEM_Customer_Type__c] = b.CustomerType
		   , a.PersonMobilePhone = b.PhoneCell
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_Contact_ID__c]
		   INNER JOIN dbo.[vwDimCustomer_ModAcctId] c ON b.[DimCustomerId] = c.[DimCustomerId]
														 AND c.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;

	---------------------------------------------------------------------------------
	----------------- PACIOLAN FIELDS -----------------------------------------------
	---------------------------------------------------------------------------------
	DECLARE @fbcurrentyear VARCHAR(15) = '2018';

	DECLARE @fbprioryear VARCHAR(15) = '2017';

	DECLARE @mbbcurrentyear VARCHAR(15) = '2017';

	DECLARE @mbbprioryear VARCHAR(15) = '2016';

	-- For Last_Ticket_Purchase_Date
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c] = odet.Ticket_Date
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN (
						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , MAX([I_DATE]) AS Ticket_Date
						  FROM	   [UnivWashington].[dbo].[TK_ODET] a ( NOLOCK )
								   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [a].CUSTOMER = b.SSID
																				 AND b.SourceSystem = 'Paciolan'
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
					  ) odet ON odet.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];

	-- YOP
	UPDATE cc
	SET	   [Football_YOP__c] = c.UD1
		   , [Men_s_Basketball_YOP__c] = c.UD2
		   , [Women_s_Basketball_YOP__c] = c.UD3
	FROM   [dbo].[Contact_Custom] cc ( NOLOCK )
		   INNER JOIN dbo.[vwDimCustomer_ModAcctId] dc ON cc.SSB_CRMSYSTEM_Contact_ID__c = dc.SSB_CRMSYSTEM_CONTACT_ID
		   INNER JOIN [UnivWashington].[dbo].[TK_CUSTOMER] c ( NOLOCK ) ON [c].CUSTOMER = dc.SSID
																		   AND dc.SourceSystem = 'Paciolan'
	WHERE  dc.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;

	-- Rank
	UPDATE cc
	SET	   [Football_Rank__c] = p.UD2
		   , [Men_s_Basketball_Rank__c] = p.UD3
	FROM   [dbo].[Contact_Custom] cc ( NOLOCK )
		   INNER JOIN dbo.[vwDimCustomer_ModAcctId] dc ON cc.SSB_CRMSYSTEM_Contact_ID__c = dc.SSB_CRMSYSTEM_CONTACT_ID
		   INNER JOIN [UnivWashington].[dbo].[PD_PATRON] p ( NOLOCK ) ON p.PATRON = dc.SSID
																		 AND dc.SourceSystem = 'Paciolan'
	WHERE  dc.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;

	--Football STH

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Football_STH__c] = ISNULL(c.FB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS FB_STH
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @fbcurrentyear
								AND fts.DimTicketTypeId IN ( '1', '27' )
								AND ds.Config_Org = 'Football'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--Football STH Comp

	UPDATE a
	SET	   [Football_Comp_Tickets__c] = ISNULL(c.FB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS FB_STH
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN UnivWashington.ro.vw_DimItem di ON fts.DimItemId = di.DimItemId
								INNER JOIN UnivWashington.ro.vw_DimPriceType dpt ON fts.DimPriceTypeId = dpt.DimPriceTypeId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @fbcurrentyear
								AND ds.Config_Org = 'Football'
								AND dpt.PriceTypeClass = 'COMP'
								AND di.ItemCode LIKE 'FS%'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--Football Rookie
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Football_Rookie__c] = ISNULL(r.FB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS FB_STH
						 FROM	[UnivWashington].ro.vw_FactTicketSales fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN UnivWashington.ro.vw_DimTicketCustomer dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND dtc.ETL__SSID_PAC_PATRON = b.SSID
								LEFT JOIN (
											  SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
											  FROM	 [UnivWashington].[ro].[vw_FactTicketSales] fts
													 JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
													 INNER JOIN UnivWashington.ro.vw_DimTicketCustomer dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
													 INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																													AND dtc.ETL__SSID_PAC_PATRON = b.SSID
											  WHERE	 ISNULL(
															   ds.Config_SeasonYear
															   , ds.SeasonYear
														   ) = @fbprioryear
													 AND fts.DimTicketTypeId = 1
													 AND ds.Config_Org = 'Football'
										  ) c ON c.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @fbcurrentyear
								AND fts.DimTicketTypeId IN ( '1', '27' )
								AND ds.Config_Org = 'Football'
								AND c.SSB_CRMSYSTEM_CONTACT_ID IS NULL
					 ) r ON r.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--Football Partial

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Football_Partial__c] = ISNULL(c.FB_PART, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS FB_PART
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @fbcurrentyear
								AND fts.DimTicketTypeId = '2'
								AND ds.Config_Org = 'Football'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--MBB STH
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Men_s_Basketball_STH__c] = ISNULL(c.MB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS MB_STH
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @mbbcurrentyear
								AND fts.DimTicketTypeId IN ( '1', '27' )
								AND ds.Config_Org = 'Men''s Basketball'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--MBB STH Comp

	UPDATE a
	SET	   [Men_s_Basketball_Comp_Tickets__c] = ISNULL(c.MB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS MB_STH
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN UnivWashington.ro.vw_DimItem di ON fts.DimItemId = di.DimItemId
								INNER JOIN UnivWashington.ro.vw_DimPriceType dpt ON fts.DimPriceTypeId = dpt.DimPriceTypeId
								INNER JOIN UnivWashington.ro.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @mbbcurrentyear
								AND ds.Config_Org = 'Men''s Basketball'
								AND dpt.PriceTypeClass = 'COMP'
								AND di.ItemCode LIKE 'FS%'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];

	--MBB Rookie
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Men_s_Basketball_Rookie__c] = ISNULL(r.MB_STH, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS MB_STH
						 FROM	[UnivWashington].ro.vw_FactTicketSales fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN UnivWashington.ro.vw_DimTicketCustomer dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND dtc.ETL__SSID_PAC_PATRON = b.SSID
								LEFT JOIN (
											  SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
											  FROM	 [UnivWashington].[ro].[vw_FactTicketSales_History] fts
													 JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
													 INNER JOIN UnivWashington.ro.vw_DimTicketCustomer dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
													 INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'TM'
																													AND dtc.ETL__SSID_TM_acct_id = b.AccountId
											  WHERE	 ISNULL(
															   ds.Config_SeasonYear
															   , ds.SeasonYear
														   ) = @mbbprioryear
													 AND fts.DimTicketTypeId = 1
													 AND ds.Config_Org = 'Men''s Basketball'
										  ) c ON c.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @mbbcurrentyear
								AND fts.DimTicketTypeId IN ( '1', '27' )
								AND ds.Config_Org = 'Men''s Basketball'
								AND c.SSB_CRMSYSTEM_CONTACT_ID IS NULL
					 ) r ON r.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];

	--MBB Partial
	UPDATE a
	SET	   [SSB_CRMSYSTEM_Men_s_Basketball_Partial__c] = ISNULL(c.MB_PART, 0)
	FROM   [dbo].[Contact_Custom] a WITH ( NOLOCK )
		   LEFT JOIN (
						 SELECT DISTINCT [b].[SSB_CRMSYSTEM_CONTACT_ID]
										 , 1 AS MB_PART
						 FROM	[UnivWashington].[ro].[vw_FactTicketSales] fts
								INNER JOIN [UnivWashington].[ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
								INNER JOIN [UnivWashington].dbo.[vwDimCustomer_ModAcctId] b ON b.SourceSystem = 'Paciolan'
																							   AND fts.[ETL__SSID_PAC_CUSTOMER] = b.SSID
						 WHERE	ISNULL(ds.Config_SeasonYear, ds.SeasonYear) = @mbbcurrentyear
								AND fts.DimTicketTypeId = '2'
								AND ds.Config_Org = 'Men''s Basketball'
					 ) c ON c.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--Last Donation Date

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Donation_Date__c] = don.TransDate
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN (
						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , MAX([TransDate]) AS TransDate
						  FROM	   [UnivWashington].[dbo].[ADV_ContactTransHeader] a ( NOLOCK )
								   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [a].ContactID = b.SSID
																				 AND b.SourceSystem = 'Advantage'
						  WHERE	   TransType = 'Cash Receipt'
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
					  ) don ON don.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];

	--Donor ID

	UPDATE a
	SET	   SSB_CRMSYSTEM_Donor_ID__c = c.ADNumber
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_Contact_ID__c
		   INNER JOIN UnivWashington.[dbo].[ADV_Contact] c ( NOLOCK ) ON c.PatronID = b.SSID
																		 AND b.SourceSystem = 'Paciolan'
	WHERE  b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;

	--Donor Warning

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Donor_Warning__c] = CASE WHEN FBR_Rank <= '100' THEN
													   '1'
												   ELSE '0'
											  END
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   LEFT JOIN (
						 SELECT [b].[SSB_CRMSYSTEM_CONTACT_ID]
								, CASE WHEN FBR_Rank IS NULL THEN '99999'
									   ELSE CAST(FBR_Rank AS INT)
								  END AS FBR_Rank
						 FROM	dbo.[vwDimCustomer_ModAcctId] b
								INNER JOIN UnivWashington.[dbo].[ADV_Contact] c ( NOLOCK ) ON CAST(c.ContactID AS NVARCHAR(50)) = b.SSID
																							  AND b.SourceSystem = 'Advantage'
								INNER JOIN UnivWashington.dbo.ADV_ContactCustom cc ( NOLOCK ) ON c.ContactID = cc.ContactID
					 ) don ON don.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];

	--Development Owner

	UPDATE a
	SET	   SSB_CRMSYSTEM_Development_Owner__c = NULL
	FROM   [dbo].[Contact_Custom] a ( NOLOCK );
	--	INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID__c
	--	INNER JOIN UnivWashington.[dbo].[ADV_Contact] c (NOLOCK) on c.PatronID = b.SSID AND b.SourceSystem = 'Paciolan' 
	--where b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1

	--Total Priority Points 

	UPDATE a
	SET	   a.SSB_CRMSYSTEM_Total_Priority_Points__c = ISNULL(don.FBR_Points, 0)
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   LEFT JOIN (
						 SELECT [b].[SSB_CRMSYSTEM_CONTACT_ID]
								, FBR_Points
						 FROM	dbo.[vwDimCustomer_ModAcctId] b
								INNER JOIN UnivWashington.[dbo].[ADV_Contact] c ( NOLOCK ) ON c.PatronID = b.SSID
																							  AND b.SourceSystem = 'Paciolan'
								INNER JOIN UnivWashington.dbo.ADV_ContactCustom cc ( NOLOCK ) ON c.ContactID = cc.ContactID
						 WHERE	b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
					 ) don ON don.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	----Priority Point Rank 

	UPDATE a
	SET	   SSB_CRMSYSTEM_Priority_Point_Rank__c = ISNULL(don.FBR_Rank, 0)
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   LEFT JOIN (
						 SELECT [b].[SSB_CRMSYSTEM_CONTACT_ID]
								, CASE WHEN FBR_Rank IS NULL THEN '0'
									   ELSE FBR_Rank
								  END AS FBR_Rank
						 FROM	dbo.[vwDimCustomer_ModAcctId] b
								INNER JOIN UnivWashington.[dbo].[ADV_Contact] c ( NOLOCK ) ON c.PatronID = b.SSID
																							  AND b.SourceSystem = 'Paciolan'
								INNER JOIN UnivWashington.dbo.ADV_ContactCustom cc ( NOLOCK ) ON c.ContactID = cc.ContactID
						 WHERE	b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
					 ) don ON don.[SSB_CRMSYSTEM_CONTACT_ID] = a.[SSB_CRMSYSTEM_Contact_ID__c];


	--Customer Comments

	UPDATE a
	SET	   SSB_CRMSYSTEM_Customer_Comments__c = customer.COMMENTS
	FROM   [dbo].[Contact_Custom] a ( NOLOCK )
		   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_Contact_ID__c
		   JOIN UnivWashington.dbo.TK_CUSTOMER customer ( NOLOCK ) ON customer.CUSTOMER = b.SSID
																	  AND b.SourceSystem = 'Paciolan'
	WHERE  b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1;


	--Email Unsubscribe

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Adobe_Unsubscribe__c] = ISNULL(
															x.EmailOptOut_Preferences
															, 0
														)
	FROM   [dbo].[Contact_Custom] a
		   LEFT JOIN (
						 SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
										 , EmailOptOut_Preferences
						 FROM	dbo.[vwDimCustomer_ModAcctId] b ( NOLOCK )
								INNER JOIN UnivWashington.ods.Adobe_Recipient adobe ( NOLOCK ) ON adobe.Email = b.EmailPrimary
						 WHERE	ISNULL(RTRIM(adobe.Email), '') <> ''
								AND [SSB_CRMSYSTEM_PRIMARY_FLAG] = '1'
					 ) x ON a.SSB_CRMSYSTEM_Contact_ID__c = x.SSB_CRMSYSTEM_CONTACT_ID;

	--Email Last Engagement Date

	UPDATE a
	SET	   [SSB_CRMSYSTEM_Last_Adobe_Engagement_Date__c] = x.Engagement_Date
	FROM   [dbo].[Contact_Custom] a
		   INNER JOIN (
						  SELECT   [b].[SSB_CRMSYSTEM_CONTACT_ID]
								   , MAX(LogDate) AS Engagement_Date
						  FROM	   [UnivWashington].[ods].[Adobe_TrackingLog] a ( NOLOCK )
								   INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [a].AccountFK = b.SSID
																				 AND b.SourceSystem = 'Adobe'
						  GROUP BY [b].[SSB_CRMSYSTEM_CONTACT_ID]
					  ) x ON a.SSB_CRMSYSTEM_CONTACT_ID__c = x.SSB_CRMSYSTEM_CONTACT_ID;

--SERVICE OWNER

--Baseline set from prodcopy
UPDATE cc
SET service_owner__c = pca.service_owner__c
--SELECT pca.service_owner__c
FROM contact_custom cc
INNER JOIN contact c
ON c.SSB_CRMSYSTEM_Contact_ID = cc.SSB_CRMSYSTEM_Contact_ID__c
INNER JOIN prodcopy.Account pca
ON c.crm_id = pca.id 
WHERE pca.service_owner__c IS NOT NULL

--round robin update
EXEC wrk.sp_Field_RoundRobinAssign @FieldID = 1 -- int



	EXEC [dbo].[sp_CRMLoad_Contact_ProcessLoad_Criteria];

GO
