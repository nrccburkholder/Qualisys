/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It returns the sampling algorithms.  
  
Created:  02/27/2006 by Brian Dohmen  
  
Modified:  
*/      
CREATE PROCEDURE QCL_SelectSamplingAlgorithms  
AS  
  
SELECT SamplingAlgorithmID, AlgorithmName  
FROM SamplingAlgorithm


