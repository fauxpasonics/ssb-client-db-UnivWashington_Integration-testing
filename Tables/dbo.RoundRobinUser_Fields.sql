CREATE TABLE [dbo].[RoundRobinUser_Fields]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CRMObject] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBO_BaseTable] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Field] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssignmentTeamName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssignmentTeamID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Criteria] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
