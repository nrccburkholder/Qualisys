﻿ALTER TABLE [dbo].[MAILINGSTEP]  WITH CHECK ADD  CONSTRAINT [FK__MAILINGST__Quota__60B4AB0C] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[MAILINGSTEP] CHECK CONSTRAINT [FK__MAILINGST__Quota__60B4AB0C]
