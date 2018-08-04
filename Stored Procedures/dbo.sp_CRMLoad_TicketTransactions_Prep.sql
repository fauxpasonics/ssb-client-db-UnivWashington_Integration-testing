SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_CRMLoad_TicketTransactions_Prep]
AS 

TRUNCATE TABLE stg.CRMLoad_TicketTransactions

INSERT INTO stg.CRMLoad_TicketTransactions
SELECT * 
FROM UnivWashington.[dbo].[vwCRMLoad_TicketTransactions] t WITH (NOLOCK)--updateme
WHERE t.Order_Total__c > 0
AND t.order_date__C > DATEADD(YEAR, -2, GETDATE())--updateme

TRUNCATE TABLE dbo.TicketTrans_ErrorOutput


GO
