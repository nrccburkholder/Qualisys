CREATE PROCEDURE sp_queue_SetNextGeneration @BatchSize INT=NULL
AS

EXEC QCL_SetNextGeneration @BatchSize


