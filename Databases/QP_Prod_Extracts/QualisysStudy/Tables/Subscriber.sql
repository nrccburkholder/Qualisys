CREATE TABLE [QualisysStudy].[Subscriber] (
    [ExtractSubscriberID]  INT           IDENTITY (1, 1) NOT NULL,
    [ExtractClientStudyID] INT           NULL,
    [RecipientType]        VARCHAR (10)  NULL,
    [EmailAddress]         VARCHAR (150) NULL,
    [CreateDate]           DATETIME      NULL,
    [CreateBy]             VARCHAR (50)  NULL,
    [IsActive]             BIT           CONSTRAINT [DF_Subscriber_IsActive] DEFAULT ((1)) NULL,
    [InternalContact]      BIT           CONSTRAINT [DF_Subscriber_InternalContact] DEFAULT ((0)) NULL
);

