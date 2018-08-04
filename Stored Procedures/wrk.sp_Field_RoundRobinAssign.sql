SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Field_RoundRobinAssign]
@FieldID int
AS



--BEFORE THIS, YOU MUST DETERMINE EXISTING RECORD OWNERS - This is set up in the Prep sproc


	--Find Top SSBLead with Lead Source that doesn't have RecordOwner
	--Determine Team For Lead Source
	--Determine Member of Team with leads leads in category
	--Give out to Member of Team
	--Add count to Team Member/Lead Source

--DECLARE @FieldID INT SET @FieldID = 1
DECLARE @BaseTable NVARCHAR(100) SET @BaseTable = (SELECT [DBO_BaseTable] from dbo.RoundRobinUser_Fields WHERE id = @FieldID);
DECLARE @CustomTable NVARCHAR(100) SET @CustomTable = (SELECT [DBO_BaseTable] + '_custom' from dbo.RoundRobinUser_Fields WHERE id = @FieldID);
DECLARE @CustomField NVARCHAR(100) SET @CustomField =  (SELECT [Field] from dbo.RoundRobinUser_Fields WHERE id = @FieldID);
DECLARE @GUIDType NVARCHAR(100) SET @GUIDType = (SELECT CASE WHEN [DBO_BaseTable] = 'Account' 
			THEN 'SSB_CRMSYSTEM_ACCT_ID' 
			ELSE 'SSB_CRMSYSTEM_' + [DBO_BaseTable] + '_ID' 
			END FROM  dbo.RoundRobinUser_Fields WHERE id = @FieldID);
DECLARE @SQL NVARCHAR(4000) SET @SQL = 
(SELECT CAST('DECLARE @RecordOwnerNeededCount int;
set @RecordOwnerNeededCount = 
(select count(*) 
FROM dbo.'+ @BaseTable + ' BaseTable 
INNER JOIN '+ @CustomTable + ' BaseCustomTable 
ON BaseTable.' + @GUIDType + ' = BaseCustomTable.' + @GUIDType + '__c ' 
+ CAST((SELECT [criteria] FROM  [dbo].[RoundRobinUser_Fields] WHERE id = @fieldid)  AS NVARCHAR(MAX)) +' AND BaseCustomTable.' + @CustomField +' IS NULL);


while @RecordOwnerNeededCount > 0
begin
    if exists (select * from sys.tables where name = ''tmp_RepAssign'' and type = ''U'')
    begin
        drop table dbo.tmp_RepAssign
    end;
    select top 1 basetable.' + @GUIDType +' as GUID, '+ CAST(@FieldID AS NVARCHAR(100)) + ' AS FieldID 
    into dbo.tmp_RepAssign
     FROM dbo.'+ @BaseTable + ' BaseTable 
	 INNER JOIN '+ @CustomTable + ' BaseCustomTable 
	 on BaseTable.' + @GUIDType + ' = BaseCustomTable.' + @GUIDType + '__c ' 
	 + CAST((SELECT [criteria] FROM  [dbo].[RoundRobinUser_Fields] WHERE id = @fieldid) AS NVARCHAR(MAX))  +' AND BaseCustomTable.' + @CustomField +' IS NULL
	 




	if exists (select * from sys.tables where name = ''tmp_RR'' and type = ''U'')
    begin
        drop table dbo.tmp_RR
    end;
	SELECT TOP 1 frr.*
	INTO dbo.tmp_RR
	FROM  dbo.tmp_RepAssign ra
	INNER JOIN [wrk].[Field_RoundRobin] frr
	ON frr.FK_Field_ID = ra.FieldID
	WHERE frr.active = 1
	ORDER BY frr.[AssignmentCount]

	UPDATE ' + @CustomTable + '
	SET ' + @CustomField + ' = rr.UserID
	FROM ' + @CustomTable + ' c
	INNER JOIN dbo.tmp_RepAssign ra
	ON c.' + @GUIDType + '__c = ra.GUID
	INNER JOIN dbo.tmp_RR rr
	ON 1=1;

	UPDATE [wrk].[Field_RoundRobin]
	SET AssignmentCount = frr.AssignmentCount + 1
	FROM [wrk].[Field_RoundRobin] frr
	INNER JOIN dbo.tmp_RR rr
	ON rr.id = frr.id




	if exists (select * from sys.tables where name = ''tmp_RepAssign'' and type = ''U'')
    begin
        drop table dbo.tmp_RepAssign
    END;
	if exists (select * from sys.tables where name = ''tmp_RR'' and type = ''U'')
    begin
        drop table dbo.tmp_RR
    end;
    

    
set @RecordOwnerNeededCount = (select count(*) 
FROM dbo.'+ @BaseTable + ' BaseTable 
INNER JOIN '+ @CustomTable + ' BaseCustomTable 
on BaseTable.' + @GUIDType + ' = BaseCustomTable.' + @GUIDType + '__c ' 
+ CAST((SELECT [criteria] FROM  [dbo].[RoundRobinUser_Fields] WHERE id = @fieldid) AS NVARCHAR(MAX)) +' AND BaseCustomTable.' + @CustomField +' IS NULL)
END
' AS NVARCHAR(MAX)))

EXEC (@SQL)


GO
