CREATE TABLE [QualisysStudy].[Schedule] (
    [ScheduleID]        INT          IDENTITY (1, 1) NOT NULL,
    [Frequency]         VARCHAR (10) NULL,
    [DatePartIncrement] INT          NULL,
    [DatePart]          VARCHAR (50) NULL,
    [DateOffSet]        INT          NULL,
    [DateHour]          INT          CONSTRAINT [DF_Schedule_DateHour] DEFAULT ((3)) NULL,
    CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([ScheduleID] ASC)
);

