--Declare the required variables
DECLARE @TypeID int

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'HCAHPS Problem Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 18670

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'HCAHPS Problem Score w/ N Size'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 18877

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'HCAHPS Positive Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 18070

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'HCAHPS Positive Score w/ N Size'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 17938

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Positive Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 13868

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Positive Score w/ N Size'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 16849

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Problem Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 11142

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Problem Score w/ N Size'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 15711

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Would Recommend Problem Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 15303

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Mean Score'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 11143

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Mean Score w/ FY 2004'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 11495

--Insert standard type and get the new type's identity
INSERT INTO dbo.OneClickTypes(strOneClickType_Nm) SELECT 'Mean Score w/ FY 2005'
SET @TypeID = SCOPE_IDENTITY()

--Insert the reports of this type
INSERT INTO dbo.OneClickDefinitions(OneClickType_id, strCategory_Nm, strOneClickReport_Nm, 
                                    strOneClickReport_Dsc, Report_id, intOrder)
SELECT @TypeID, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM OneClickReport
WHERE ClientUser_id = 11150
