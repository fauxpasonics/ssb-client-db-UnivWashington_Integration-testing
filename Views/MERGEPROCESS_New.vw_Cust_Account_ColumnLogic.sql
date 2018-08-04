SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW  [MERGEPROCESS_New].[vw_Cust_Account_ColumnLogic] 
AS
SELECT  ID,
		Losing_ID AS Losing_ID ,					
        CAST(SUBSTRING(PersonTitle, 2, 82) AS NVARCHAR(80)) PersonTitle,
		CAST(SUBSTRING(Sales_Owner__c, 2,20) AS NVARCHAR(18)) Sales_Owner__c,
		CAST(SUBSTRING(Service_Owner__c, 2,20) AS NVARCHAR(18)) Service_Owner__c,
		CAST(SUBSTRING(Tyee_Owner__c, 2, 20) AS NVARCHAR(18)) Tyee_Owner__c,
		ISNULL(CAST(SUBSTRING(Football_Comp_Tickets__c, 2, 1) AS BIT),0) Football_Comp_Tickets__c,
		CAST(SUBSTRING(Preferred_Method_of_Contact__c, 2, 257) AS nvarchar(255)) Preferred_Method_of_Contact__c,
		CAST(SUBSTRING(Football_Renewal_Intention__c, 2, 257) AS nvarchar(255)) Football_Renewal_Intention__c,
		CAST(SUBSTRING(Football_Reason_s_Leaving__c, 2, 5000) AS NVARCHAR(MAX)) Football_Reason_s_Leaving__c
FROM    ( SELECT    Winning_ID AS ID ,
					Losing_ID AS Losing_ID ,					
                    --PersonTitle
					MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND PersonTitle IS NOT NULL AND Persontitle != ''
                             THEN '2' + CAST(PersonTitle AS VARCHAR(80))
                             WHEN dta.xtype = 'Losing'
                                  AND PersonTitle IS NOT NULL AND Persontitle != ''
                             THEN '1' + CAST(PersonTitle AS VARCHAR(80))
                        END) PersonTitle,

					--Sales_Owner__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Sales_Owner__c IS NOT NULL AND Sales_Owner__c != ''
                             THEN '2' + CAST(Sales_Owner__c AS VARCHAR(18))
                             WHEN dta.xtype = 'Losing'
                                  AND Sales_Owner__c IS NOT NULL AND Sales_Owner__c != ''
                             THEN '1' + CAST(Sales_Owner__c AS VARCHAR(18))
                        END) Sales_Owner__c,
					--Service_Owner__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Service_Owner__c IS NOT NULL AND Service_Owner__c != ''
                             THEN '2' + CAST(Service_Owner__c AS VARCHAR(18))
                             WHEN dta.xtype = 'Losing'
                                  AND Service_Owner__c IS NOT NULL AND Service_Owner__c != ''
                             THEN '1' + CAST(Service_Owner__c AS VARCHAR(18))
                        END) Service_Owner__c,
						--Tyee_Owner__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Tyee_Owner__c IS NOT NULL AND Tyee_Owner__c != ''
                             THEN '2' + CAST(Tyee_Owner__c AS VARCHAR(18))
                             WHEN dta.xtype = 'Losing'
                                  AND Tyee_Owner__c IS NOT NULL AND Tyee_Owner__c != ''
                             THEN '1' + CAST(Tyee_Owner__c AS VARCHAR(18))
                        END) Tyee_Owner__c,
						--Football_Comp_Tickets__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Football_Comp_Tickets__c IS NOT NULL AND	Football_Comp_Tickets__c != ''
                             THEN '2' + CAST(Football_Comp_Tickets__c AS NVARCHAR(50))
                             WHEN dta.xtype = 'Losing'
                                  AND Football_Comp_Tickets__c IS NOT NULL AND Football_Comp_Tickets__c != ''
                             THEN '1' + CAST(Football_Comp_Tickets__c AS NVARCHAR(50))
                        END) Football_Comp_Tickets__c,
						--Preferred_Method_of_Contact__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Preferred_Method_of_Contact__c IS NOT NULL AND Preferred_Method_of_Contact__c != ''
                             THEN '2' + CAST(Preferred_Method_of_Contact__c AS NVARCHAR(50))
                             WHEN dta.xtype = 'Losing'
                                  AND Preferred_Method_of_Contact__c IS NOT NULL AND Preferred_Method_of_Contact__c != ''
                             THEN '1' + CAST(Preferred_Method_of_Contact__c AS NVARCHAR(50))
                        END) Preferred_Method_of_Contact__c,
						--Football_Renewal_Intention__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Football_Renewal_Intention__c IS NOT NULL AND Football_Renewal_Intention__c != ''
                             THEN '2' + CAST(Football_Renewal_Intention__c AS NVARCHAR(50))
                             WHEN dta.xtype = 'Losing'
                                  AND Football_Renewal_Intention__c IS NOT NULL AND Football_Renewal_Intention__c != ''
                             THEN '1' + CAST(Football_Renewal_Intention__c AS NVARCHAR(50))
                        END) Football_Renewal_Intention__c,
						--Football_Reason_s_Leaving__c
                    MAX(CASE WHEN dta.xtype = 'Winning'
                                  AND Football_Reason_s_Leaving__c IS NOT NULL AND Football_Reason_s_Leaving__c != ''
                             THEN '2' + CAST(Football_Reason_s_Leaving__c AS NVARCHAR(50))
                             WHEN dta.xtype = 'Losing'
                                  AND Football_Reason_s_Leaving__c IS NOT NULL AND Football_Reason_s_Leaving__c != ''
                             THEN '1' + CAST(Football_Reason_s_Leaving__c AS NVARCHAR(50))
                        END) Football_Reason_s_Leaving__c
						                    
FROM      ( SELECT    *
            FROM      ( SELECT    'Winning' xtype ,
                                a.Winning_ID ,
								a.Losing_ID ,					
                                b.*
                        FROM      [MERGEPROCESS_New].[Queue] a
                                JOIN Prodcopy.vw_Account b ON a.Winning_ID = b.ID 
                        UNION ALL
                        SELECT    'Losing' xtype ,
                                a.Winning_ID ,
								a.Losing_ID ,					
                                b.*
                        FROM      [MERGEPROCESS_New].[Queue] a
                                JOIN Prodcopy.vw_Account b ON a.Losing_ID = b.ID 
                    ) x
        ) dta

GROUP BY  Winning_ID ,
		Losing_ID					
        ) aa
	--WHERE aa.ID = '0016A000006rljcQAA'
;








GO
