﻿ALTER TABLE [dbo].[QPReport]  WITH CHECK ADD  CONSTRAINT [FK_QPReport_UserGroup] FOREIGN KEY([UserGroup_id])
REFERENCES [dbo].[UserGroup] ([UserGroup_id])
ON UPDATE CASCADE
ON DELETE CASCADE


GO
ALTER TABLE [dbo].[QPReport] CHECK CONSTRAINT [FK_QPReport_UserGroup]

