CREATE procedure QP_Rep_Project_MailingCountTitle
 @StartDate datetime,	        -- Start date of dashboard report
 @EndDate datetime,             -- End date of dashboard report
 @Weight decimal(4, 2) = 1.65   -- Weighted factor for multi-page projects
                                -- default weight is 1.65
AS
SELECT @StartDate AS 'Start Date',
       @EndDate AS 'End Date'


