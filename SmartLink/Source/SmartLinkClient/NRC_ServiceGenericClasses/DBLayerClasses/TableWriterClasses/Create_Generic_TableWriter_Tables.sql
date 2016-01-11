/*******************************************************************
*	Created by: ELIBAD
*	Created date: 2009/04/06
*	
*	This script creates the tables needed to use the TW_TableWriter_MSSQLGeneric class
*	
*	This table stores the information about how a row can be uniquely identified.
*	There is no need to add the information of the primary key (this is handled automatically within the class)
*	
*	There is not going to be an exception if this table does not exists.
********************************************************************/

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblDBKeyGroup')
CREATE TABLE tblDBKeyGroup
(
	tblDBKeyGroupKey UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID()
	, TableName VARCHAR(150) NOT NULL
	, KeyName VARCHAR(25) NOT NULL
	, KeyFieldNames VARCHAR(MAX) NOT NULL
	, KeyGroupOrder INT NOT NULL
	CONSTRAINT [PK_tblDBKeyGroup] PRIMARY KEY CLUSTERED
		(
			tblDBKeyGroupKey
		)
)

ALTER TABLE tblDBKeyGroup
ADD 	CONSTRAINT [UQK_tblDBKeyGroup] UNIQUE NONCLUSTERED 
		(
			[TableName]
			, [KeyName]
		)

CREATE INDEX IX_tblDBKeyGroup_Table_Name ON tblDBKeyGroup(TableName)