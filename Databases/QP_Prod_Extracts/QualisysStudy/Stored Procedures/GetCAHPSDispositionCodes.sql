CREATE PROCEDURE [QualisysStudy].[GetCAHPSDispositionCodes]
	@Client_ID INT

AS
 SET NOCOUNT ON
 BEGIN  

 --DECLARE @ClientID INT;
 --SET @ClientID = 131393164;

    WITH cd AS
	(   
			SELECT  
				  ct.Label AS CAHPSType
				  ,cd.[Label] AS CAHPSDisposition
				  ,cd.CahpsDispositionID
			FROM [Catalyst].NRC_DataMart_CA.[dbo].[CahpsDisposition] cd
			INNER JOIN [Catalyst].NRC_DataMart_CA.[dbo].[CahpsType] ct on cd.CahpsTypeID = ct.CahpsTypeID
			WHERE cd.CAHPSTypeID in (1,0, 7)
	), c AS
	(
		SELECT ClientID, c.ClientName
		FROM [Catalyst].NRC_DataMart_CA.[dbo].v_Client c
		WHERE Client_ID = @Client_ID
		)

	SELECT		@Client_ID AS Client_ID
				,c.ClientName
				,cd.CAHPSType 
				  ,cd.CAHPSDisposition
					,cd.CahpsDispositionID

	FROM cd,c 
   
END
