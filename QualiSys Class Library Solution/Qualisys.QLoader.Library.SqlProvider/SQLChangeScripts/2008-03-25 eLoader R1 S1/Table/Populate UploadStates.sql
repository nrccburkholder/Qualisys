USE [QP_Load]
GO
TRUNCATE TABLE UploadStates
GO
INSERT INTO UploadStates (UploadState_Nm) VALUES ('UploadQueued')
GO
INSERT INTO UploadStates (UploadState_Nm) VALUES ('Uploading')
GO
INSERT INTO UploadStates (UploadState_Nm) VALUES ('Uploaded')
GO
INSERT INTO UploadStates (UploadState_Nm) VALUES ('UploadAbandoned')
GO
