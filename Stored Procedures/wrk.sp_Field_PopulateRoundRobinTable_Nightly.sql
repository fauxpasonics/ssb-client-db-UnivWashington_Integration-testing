SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [wrk].[sp_Field_PopulateRoundRobinTable_Nightly]
AS 
--This sproc brings over users/teams for any configured Lead Source and drops them in a table so that we know who is active to receive leads, and so we can keep track of the number of leads that they have received.
--As part of nightly job need to merge users/teams into the Round Robin table. 
--If user is added, they are added at the lowest number present for that team/leadtype
--If a user is removed, they are set to inactive in the table
--If matched, make sure that rep is set to active (because the query only returns active users

select rruf.*, ur.name AS TeamName, ur.id AS TeamID, u.id AS UserID, u.name UserName, ISNULL(rr.Min_LeadCount,0) AS Min_LeadCount
--INTO #temp_UsersbyTeam
from [dbo].[RoundRobinUser_Fields] rruf --updateme
inner join UnivWashington_Reporting.prodcopy.UserRole ur  --updateme
on rruf.AssignmentTeamName = ur.name
inner join prodcopy.[User] u --updateme
	ON u.UserRoleId = ur.Id
left JOIN (SELECT [FK_Field_ID], MIN([AssignmentCount]) AS Min_LeadCount FROM wrk.[Field_RoundRobin] where active = 1 GROUP BY [FK_Field_ID]) rr 
ON rr.[FK_Field_ID] = rruf.Id
where u.isactive = 1


MERGE INTO [wrk].[Field_RoundRobin] AS target
USING  #temp_UsersbyTeam AS SOURCE 
ON target.UserID = source.UserID
AND target.[FK_Field_ID] = source.id


WHEN NOT MATCHED BY SOURCE THEN
UPDATE 
SET active = 0

WHEN NOT MATCHED BY TARGET THEN
INSERT 
(

			  UserID
			, UserName
			, [FK_Field_ID]
			, [AssignmentCount]
			, Active

)
VALUES
(
		  SOURCE.UserID
		, SOURCE.UserName
		, source.Id
		, SOURCE.Min_LeadCount
		, 1
		);



GO
