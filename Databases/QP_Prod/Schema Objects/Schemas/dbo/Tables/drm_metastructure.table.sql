CREATE TABLE [dbo].[drm_metastructure](
	[TABLE_ID] [int] NOT NULL,
	[FIELD_ID] [int] NOT NULL,
	[BITKEYFIELD_FLG] [bit] NOT NULL,
	[BITUSERFIELD_FLG] [bit] NOT NULL,
	[BITMATCHFIELD_FLG] [bit] NOT NULL,
	[BITPOSTEDFIELD_FLG] [bit] NOT NULL,
	[bitPII] [bit] NULL,
	[bitAllowUS] [bit] NULL
) ON [PRIMARY]


