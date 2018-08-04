CREATE TABLE [wrk].[Field_RoundRobin]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FK_Field_ID] [int] NULL,
[AssignmentCount] [int] NULL,
[Active] [bit] NULL
)
GO
