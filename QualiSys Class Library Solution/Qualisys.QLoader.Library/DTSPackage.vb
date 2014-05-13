Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports Nrc.Framework.BusinessLogic.Configuration

Public Delegate Sub UsedTablesChangedEventHandler(ByVal table As DTSDestination)
Public Delegate Sub SourceColumnChangeEventHandler(ByVal column As SourceColumn)

Public Class DTSPackage

#Region " Private Members "

    Protected mPackageID As Integer
    Protected mVersion As Integer
    Protected mPackageName As String
    Protected mPackageFriendlyName As String
    Protected mStudy As Study
    Protected mCreatorID As Integer
    Protected mDateLastModified As DateTime
    Protected mSignOffByID As Integer
    Protected mSource As DTSDataSet
    Protected mDestinations As New DTSDestinationCollection
    Protected mLockState As PackageLockStates = PackageLockStates.Unlocked
    Protected mLockedBy As String
    Protected mLockDate As DateTime
    Protected mOwnerName As String
    Protected mTeamID As Integer
    Protected mModified As Boolean
    Protected mBadRecordThreshold As Single = 0.1
    Protected mNotes As New PackageNoteCollection
    Protected mBitActive As Boolean = True
    Protected mBitDeleted As Boolean

    'Package Execution variables
    Protected WithEvents mPackage As SQLDTSPackage
    Protected mConnSource As Integer
    Protected mConnDest As Integer
    Protected mConnDest2 As Integer
    Protected mSQLServer As String
    Protected mSQLDatabase As String
    Protected mSQLUser As String
    Protected mSQLPassword As String
    Protected mPreloadTable As String
    Protected mOwnerMemberID As Nullable(Of Integer) = Nothing

    Structure IDAndName
        Dim ID As Integer
        Dim Name As String
    End Structure

#End Region

#Region " Public Properties "

    Public Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
        Set(ByVal value As Integer)
            mPackageID = value
        End Set
    End Property

    Public Property Version() As Integer
        Get
            Return mVersion
        End Get
        Set(ByVal value As Integer)
            mVersion = value
        End Set
    End Property

    Public Property PackageName() As String
        Get
            Return mPackageName
        End Get
        Set(ByVal value As String)
            mPackageName = value
        End Set
    End Property

    Public Property PackageFriendlyName() As String
        Get
            Return mPackageFriendlyName
        End Get
        Set(ByVal value As String)
            mPackageFriendlyName = value
        End Set
    End Property

    Public Property Study() As Study
        Get
            Return mStudy
        End Get
        Set(ByVal value As Study)
            mStudy = value
        End Set
    End Property

    Public Property CreatorID() As Integer
        Get
            Return mCreatorID
        End Get
        Set(ByVal value As Integer)
            mCreatorID = value
        End Set
    End Property

    Public Property DateLastModified() As DateTime
        Get
            Return mDateLastModified
        End Get
        Set(ByVal value As DateTime)
            mDateLastModified = value
        End Set
    End Property

    Public Property SignOffByID() As Integer
        Get
            Return mSignOffByID
        End Get
        Set(ByVal value As Integer)
            mSignOffByID = value
        End Set
    End Property

    Public Property OwnerMemberID() As Nullable(Of Integer)
        Get
            Return mOwnerMemberID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mOwnerMemberID = value
        End Set
    End Property

    Public Property Source() As DTSDataSet
        Get
            Return mSource
        End Get
        Set(ByVal value As DTSDataSet)
            mSource = value
        End Set
    End Property

    Public Property Destinations() As DTSDestinationCollection
        Get
            Return mDestinations
        End Get
        Set(ByVal value As DTSDestinationCollection)
            mDestinations = value
        End Set
    End Property

    Public ReadOnly Property LockStatus() As PackageLockStates
        Get
            Return mLockState
        End Get
    End Property

    Public ReadOnly Property LockMessage() As String
        Get
            Return String.Format("Package has been locked by {0} at {1}.", mLockedBy, mLockDate.ToString)
        End Get
    End Property

    Public Property OwnerName() As String
        Get
            Return mOwnerName
        End Get
        Set(ByVal value As String)
            mOwnerName = value
        End Set
    End Property

    Public Property Modified() As Boolean
        Get
            Return mModified
        End Get
        Set(ByVal value As Boolean)
            mModified = value
        End Set
    End Property

    Public ReadOnly Property DataStorePath() As String
        Get
            'Returns "\\NetworkShare\Environment\ClientID\StudyID\PackageID"
            Return String.Format("{0}\{1}\{2}\{3}", AppConfig.Params("QLDataStorePath").StringValue, Study.ClientID, Study.StudyID, PackageID)
        End Get
    End Property

    Public ReadOnly Property IsValid() As Boolean
        Get
            Return PackageDB.ValidatePackage(mPackageID, mVersion)
        End Get
    End Property

    Public Property BadRecordThreshold() As Single
        Get
            Return mBadRecordThreshold
        End Get
        Set(ByVal value As Single)
            mBadRecordThreshold = value
        End Set
    End Property

    Public Property BitActive() As Boolean
        Get
            Return mBitActive
        End Get
        Set(ByVal value As Boolean)
            mBitActive = value
        End Set
    End Property

    Public Property BitDeleted() As Boolean
        Get
            Return mBitDeleted
        End Get
        Set(ByVal value As Boolean)
            mBitDeleted = value
        End Set
    End Property

    Public ReadOnly Property Notes() As PackageNoteCollection
        Get
            Return mNotes
        End Get
    End Property

#End Region

#Region " Public Events "

    Public Event UsedTablesChanged As UsedTablesChangedEventHandler
    Public Event SourceColumnChanged As SourceColumnChangeEventHandler
    Public Event PackageProgress As PackageProgressEventHandler

    Private Sub RaiseSourceColumnEvent(ByVal column As SourceColumn)

        RaiseEvent SourceColumnChanged(column)

    End Sub

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

    Public Sub New(ByVal packageID As Integer)

        LoadFromDB(packageID, -1)

    End Sub

    Public Sub New(ByVal packageID As Integer, ByVal versionID As Integer)

        LoadFromDB(packageID, versionID)

    End Sub

#End Region

#Region " Load Package "

    Public Sub LoadFromDB(ByVal packageID As Integer)

        LoadFromDB(packageID, -1)

    End Sub

    Public Shared Function CreatePackageCollectionByStudyIds(ByVal studyIDs As List(Of Integer)) As List(Of DTSPackage)

        Dim rdr As IDataReader = Nothing

        Try
            Dim retVal As List(Of DTSPackage) = New List(Of DTSPackage)
            Dim packageIDs As List(Of Integer) = New List(Of Integer)
            For Each studyID As Integer In studyIDs
                rdr = PackageDB.GetPackageIDFromStudyID(studyID)
                While rdr.Read
                    Dim packageID As Integer
                    packageID = CInt(rdr("Package_id"))
                    If Not ExistsInList(packageIDs, packageID) And packageID > 0 Then
                        retVal.Add(New DTSPackage(packageID))
                    End If
                End While
                rdr.Close()
            Next
            Return retVal

        Catch ex As Exception
            Throw ex

        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Close()
            End If

        End Try

    End Function

    Private Shared Function ExistsInList(ByVal list As List(Of Integer), ByVal s As Integer) As Boolean

        If Not list Is Nothing Then
            For Each listItem As Integer In list
                If listItem = s Then
                    Return True
                End If
            Next
        End If

        Return False

    End Function

    Public Shared Function GetPackageByID(ByVal PackageID As Integer) As DTSPackage

        Return New DTSPackage(PackageID)

    End Function

    Public Sub LoadFromDB(ByVal packageID As Integer, ByVal versionID As Integer)

        Destinations.Clear()
        Study = Nothing
        Dim ds As DataSet = PackageDB.GetPackageData(packageID, versionID)

        'Load the package info
        LoadPackageInfo(ds.Tables(0))
        LoadDestinations(ds.Tables(1))
        LoadSourceColumns(ds.Tables(2))
        LoadDestinationColumns(ds.Tables(3))
        mNotes = PackageNote.GetPackageNotes(mPackageID)

        'Package is newly loaded so not modified
        mModified = False

    End Sub

    Private Sub LoadPackageInfo(ByVal table As DataTable)

        Dim sourceType As DataSetTypes
        Dim row As DataRow

        'Make sure the table not null and that a row was returned
        If table Is Nothing OrElse table.Rows.Count < 1 Then
            Throw New Exception("No package info was returned.")
        End If
        row = table.Rows(0)

        PackageID = CType(row("Package_id"), Integer)
        Version = CType(row("intVersion"), Integer)
        PackageName = row("strPackage_nm").ToString
        PackageFriendlyName = row("strPackageFriendly_nm").ToString
        SignOffByID = CType(row("SignOffBy_id"), Integer)
        BitActive = CType(row("BitActive"), Boolean)
        mLockedBy = row("Associate").ToString

        If mLockedBy.Length > 0 Then
            If mLockedBy = Environment.UserName Then
                mLockState = PackageLockStates.LockedByMe
            Else
                mLockState = PackageLockStates.LockedByOther
            End If
            mLockDate = CType(row("LockDate"), Date)
        End If

        sourceType = CType(row("FileType_id"), DataSetTypes)

        Select Case sourceType
            Case DataSetTypes.DBF
                Source = New DTSDbaseData

            Case DataSetTypes.Text
                Source = New DTSTextData

            Case DataSetTypes.Excel
                Source = New DTSExcelData

            Case DataSetTypes.AccessDB
                Source = New DTSAccessData

            Case DataSetTypes.XML
                Source = New DTSXmlData

            Case Else
                Throw New Exception("Unknown Source File Type")

        End Select

        Source.SplitSettings(row("FileTypeSettings").ToString)
        Source.BadRecordThreshold = mBadRecordThreshold

        Study = New Study
        Study.ClientID = CType(row("Client_id"), Integer)
        Study.ClientName = row("strClient_nm").ToString.Trim()
        Study.StudyID = CType(row("Study_id"), Integer)
        Study.StudyName = row("strStudy_nm").ToString.Trim()

        If row("OwnerMember_ID") IsNot DBNull.Value Then
            OwnerMemberID = CType(row("OwnerMember_ID"), Integer)
        End If

    End Sub

    Private Sub LoadDestinations(ByVal table As DataTable)

        Dim row As DataRow
        Dim dest As DTSDestination

        For Each row In table.Rows
            dest = New DTSDestination(Me)
            dest.TableID = CType(row("Table_id"), Integer)
            dest.TableName = row("strTable_nm").ToString
            dest.UsedInPackage = CType(row("Included"), Boolean)
            dest.HasDupCheckDefined = CType(row("bitDupCheck"), Boolean)

            Destinations.Add(dest)
        Next

    End Sub

    Private Sub LoadSourceColumns(ByVal table As DataTable)

        Dim column As SourceColumn
        Dim row As DataRow

        For Each row In table.Rows
            column = New SourceColumn(Source)
            column.SourceID = CType(row("Source_id"), Integer)
            column.ColumnName = row("strAlias").ToString
            column.OriginalName = row("strName").ToString
            column.Length = CType(row("intLength"), Integer)
            column.DataType = CType(row("DataType_id"), DataTypes)
            column.Ordinal = CType(row("Ordinal"), Integer)
            column.MapCount = CType(row("MapCount"), Integer)

            AddHandler column.ColumnChanged, AddressOf RaiseSourceColumnEvent
            Source.Columns.Add(column)
        Next

    End Sub

    Private Sub LoadDestinationColumns(ByVal table As DataTable)

        Dim view As DataView
        Dim row As DataRowView
        Dim dest As DTSDestination
        Dim column As DestinationColumn
        Dim index As Integer
        Dim sourceList As String()
        Dim sourceID As String
        Dim sourceCol As SourceColumn

        For Each dest In Destinations
            view = New DataView(table)
            view.RowFilter = String.Format("Table_id = {0}", dest.TableID)

            index = 1
            For Each row In view
                column = dest.NewColumn
                column.DestinationID = CType(row("Field_id"), Integer)
                column.ColumnName = row("strField_nm").ToString
                column.IsMatchField = CType(row("bitMatchField_flg"), Boolean)
                column.Formula = row("Formula").ToString
                column.FrequencyLimit = CType(row("intFreqLimit"), Integer)
                column.CheckNulls = CType(row("bitNullCount"), Boolean)
                column.IsDupCheckField = CType(row("bitDupCheck"), Boolean)
                column.DataType = CType(row("DataType_id"), DataTypes)
                column.Length = CType(row("intLength"), Integer)
                column.Ordinal = index
                column.IsSystemField = CType(row("bitSystem"), Boolean)
                column.IsPIIField = CType(row("bitPII"), Boolean)
                column.IsTransferedToUS = CType(row("bitAllowUS"), Boolean)

                If Not row("Sources").ToString = "" AndAlso Not row("Sources").ToString = "0" Then
                    sourceList = row("Sources").ToString.Split(Char.Parse(","))

                    For Each sourceID In sourceList
                        sourceCol = Source.Columns.GetSourceColumn(CType(sourceID, Integer))
                        If sourceCol Is Nothing Then
                            Throw New Exception("Destination references an unknown source.")
                        End If
                        column.SourceColumns.Add(sourceCol)
                    Next
                End If
                dest.Columns.Add(column)
                index += 1
            Next
        Next

    End Sub

#End Region

#Region " Save Package "

    Public Function SaveAs(ByVal newClientID As Integer, ByVal newStudyID As Integer, ByVal newPackageName As String, _
                           ByVal newPackageFriendlyName As String, ByVal userName As String) As Integer

        Dim teamNum As Integer = mTeamID
        Dim fileTypeID As Integer = mSource.DataSetType
        Dim fileSettings As String = mSource.ConcatSettings
        Dim newID As Integer
        Dim newPack As DTSPackage
        Dim conn As SqlClient.SqlConnection = Nothing
        Dim trans As SqlClient.SqlTransaction = Nothing

        Try
            conn = New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
            conn.Open()
            trans = conn.BeginTransaction(IsolationLevel.ReadCommitted)

            newID = PackageDB.SavePackageAs(trans, mPackageID, newPackageName, newClientID, newStudyID, teamNum, userName, fileTypeID, _
                                            fileSettings, mSignOffByID, newPackageFriendlyName, OwnerMemberID.Value)

            Dim templatePath As String = String.Format("{0}\{1}", DataStorePath, Source.TemplateFileName)
            Dim oldFile As New IO.FileInfo(templatePath)

            newPack = New DTSPackage(newID)

            templatePath = String.Format("{0}\{1}", newPack.DataStorePath, oldFile.Name)
            Dim newFile As New IO.FileInfo(templatePath)

            If Not newFile.Directory.Exists Then newFile.Directory.Create()
            oldFile.CopyTo(newFile.FullName, True)

            trans.Commit()

            Return newID

        Catch ex As Exception
            If Not trans Is Nothing Then
                trans.Rollback()
            End If
            Throw

        Finally
            If Not trans Is Nothing Then
                trans.Dispose()
            End If
            If Not conn Is Nothing Then
                conn.Dispose()
            End If

        End Try

    End Function

    Public Function SaveToDB() As Integer

        Dim conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
        conn.Open()
        Dim trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)

        Try
            SavePackageInfo(trans)
            SaveDestinationColumns(trans)
            Notes.SaveAllToDB()
            mModified = False

            trans.Commit()
            conn.Close()

        Catch ex As Exception
            trans.Rollback()
            conn.Close()
            Throw ex

        End Try

        Return PackageID

    End Function

    Private Sub SavePackageInfo(ByVal transaction As SqlClient.SqlTransaction)

        Dim result As Integer
        Const bogusTeamID As Integer = -9999

        result = PackageDB.SavePackageInfo(transaction, PackageID, PackageName, Study.ClientID, Study.StudyID, _
                                           bogusTeamID, Environment.UserName, Source.DataSetType, Source.ConcatSettings, _
                                           SignOffByID, PackageFriendlyName, BitActive, BitDeleted, OwnerMemberID)

        Select Case result
            Case -1
                Throw New Exception("Client_id, Study_id, or Package_id changed from previous values.")

            Case -2
                Throw New Exception("A package with this name already exists in the study.")

            Case Else
                PackageID = result

        End Select

    End Sub

    Public Sub SaveSourceColumns()

        Dim conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
        conn.Open()
        Dim trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)
        Dim column As SourceColumn
        Dim result As Integer

        Try
            Version = PackageDB.IncrementVersion(trans, PackageID, True, Source.DataSetType)

            For Each column In Source.Columns
                result = PackageDB.SaveSourceColumn(trans, PackageID, Version, column.SourceID, column.OriginalName, column.ColumnName, column.DataType, column.Length, column.Ordinal)

                Select Case result
                    Case -2
                        Throw New Exception("Source name is not unique to this package.")

                    Case -3
                        Throw New Exception("Package and/or version does not exist.")

                    Case Else
                        column.SourceID = result

                End Select
            Next

            PackageDB.SyncronizeTemplates(trans, PackageID, Version)
            SavePackageInfo(trans)

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            Throw ex

        End Try

    End Sub

    Private Sub SaveDestinationColumns(ByVal transaction As SqlClient.SqlTransaction)

        Dim result As Integer
        Dim dest As DTSDestination
        Dim destCol As DestinationColumn
        Dim sourceCol As SourceColumn
        Dim sourceIDs As String
        Dim tableList As String = String.Empty

        For Each dest In Destinations
            'Clear out the unused destination columns so the will save blank
            If Not dest.UsedInPackage Then
                For Each destCol In dest.Columns
                    destCol.Formula = ""
                    destCol.SourceColumns.Clear()
                Next
            Else
                tableList &= dest.TableID & ","
            End If

            'If dest.UsedInPackage Then
            For Each destCol In dest.Columns
                If Not destCol.IsSystemField Then
                    sourceIDs = String.Empty
                    For Each sourceCol In destCol.SourceColumns
                        If sourceCol.SourceID > 0 Then sourceIDs &= sourceCol.SourceID.ToString & ","
                    Next
                    If sourceIDs.Length > 0 Then
                        sourceIDs = sourceIDs.Substring(0, sourceIDs.Length - 1)
                    End If

                    result = PackageDB.SaveDestinationColumn(transaction, PackageID, Version, destCol.DestinationID, DirectCast(destCol.Parent, DTSDestination).TableID, destCol.Formula, sourceIDs, destCol.CheckNulls, destCol.FrequencyLimit)

                    Select Case result
                        Case -3
                            Throw New Exception("Package and/or version does not exist.")
                    End Select
                End If
            Next
            'End If
        Next

        If tableList.Length > 0 Then
            tableList = tableList.Substring(0, tableList.Length - 1)
        End If

        If PackageDB.PackageTableCleanup(transaction, PackageID, tableList) < 0 Then
            Throw New Exception("Error occurred while cleaning up package table list.")
        End If

    End Sub

#End Region

#Region "Delete\Restore Package"

    Public Shared Sub DeletePackage(ByVal userName As String, ByVal packageID As Integer)

        Dim package As DTSPackage = DTSPackage.GetPackageByID(packageID)
        Dim PackageName As String = package.PackageName()

        If CanDeletePackage(packageID) Then
            package.BitDeleted = True
            package.SaveToDB()

            'PackageDB.DeletePackage(packageID)
            MessageBox.Show(String.Format("'{0}' has been successfully deleted.", PackageName), "Success!", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            MessageBox.Show(String.Format("'{0}' cannot be deleted!", PackageName), "Failed to delete the package", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

    End Sub

    Public Shared Sub RestorePackage(ByVal userName As String, ByVal packageID As Integer)

        Dim package As DTSPackage = DTSPackage.GetPackageByID(packageID)

        'PackageDB.RestorePackage(packageID)
        package.BitDeleted = False
        package.SaveToDB()

    End Sub

    Public Shared Function CanDeletePackage(ByVal PackageID As Integer) As Boolean

        Return PackageDB.CanDeletePackage(PackageID)

    End Function

    Public Shared Function GetDeletedPackagesAsGenericList(ByVal userName As String) As List(Of DTSPackage)

        Dim DeletedPackagesTable As DataTable = PackageDB.GetDeletedPackageList(userName)
        Dim resultList As New List(Of DTSPackage)

        For Each row As DataRow In DeletedPackagesTable.Rows
            resultList.Add(New DTSPackage(CType(row("Package_id"), Integer)))
        Next

        Return resultList

    End Function

    Public Shared Function GetDeletedPackages(ByVal userName As String) As DataTable

        Return PackageDB.GetDeletedPackageList(userName)

    End Function

#End Region

    Public Sub ClearAllMappings()

        Dim dest As DTSDestination
        Dim col As DestinationColumn
        Dim scol As SourceColumn

        'For each destination table and each destination column
        For Each dest In Destinations
            For Each col In dest.Columns
                'Decrement each mapcount
                For Each scol In col.SourceColumns
                    scol.MapCount -= 1
                Next

                'Clear the sources and reset formula
                col.SourceColumns.Clear()
                col.Formula = ""
            Next
        Next

        mModified = True

    End Sub

#Region " Package Execution "

    Public Sub ExecutePackage(ByVal dataFile As DataFile, ByVal saveToServer As Boolean)

        Dim errorCount As Integer   'The max number or rows that can error
        mPreloadTable = dataFile.PreloadTable

        'Determine the maximum number of rows that can fail
        '10% of all row count
        errorCount = CType(dataFile.RecordCount * mBadRecordThreshold, Integer)

        'BEGIN PACKAGE EXECUTION...
        mPackage = New SQLDTSPackage(String.Format("{0}_{1}", PackageName, dataFile.DataFileID))     'Create the object
        AddConnections(AppConfig.QLoaderConnection, dataFile)     'Add the connections

        'If we are loading from XML we need to PreLoad outside of DTS
        If Source.DataSetType = DataSetTypes.XML Then
            PreLoadXML(dataFile)
        Else
            'For all types other than XML we do the PreLoad as part of the DTS package
            AddPreloadStep(dataFile, dataFile.ExceptionFilePath)                'Create the Preload Step
        End If
        AddDTSSteps(errorCount, dataFile.ExceptionFilePath)                 'Create the DTS Step

        mPackage.Execute(mSQLServer, mSQLUser, mSQLPassword, saveToServer)        'Execute
        mPackage = Nothing

        'Call the garbage collector since these COM Objects do really bad things when used in rapid succession
        'GC.Collect()

        'now finish this load
        Try
            PackageDB.FinishLoad(dataFile.DataFileID)

        Catch ex As Exception
            Throw New Exception(String.Format("Package could not finish being loaded.  {0}", ex.Message))

        End Try

    End Sub

    Private Sub PreLoadXML(ByVal dataFile As DataFile)

        Dim connection As String = String.Format("PROVIDER=SQLOLEDB;Data Source={0};UID={1};PWD={2};Initial Catalog={3};", mSQLServer, mSQLUser, mSQLPassword, mSQLDatabase)
        Dim xmlFile As DTSXmlData = DirectCast(Source, DTSXmlData)
        Dim mappingFilePath As String = String.Format("{0}{1}.xsd", dataFile.Folder, dataFile.FileName)
        Dim xmlFilePath As String = dataFile.Folder & dataFile.FileName

        'Create the mapping XSD file
        xmlFile.CreateXsd(mappingFilePath, dataFile.PreloadTable)

        'Create the bulk load COM object
        Dim bulkLoad As New Interop.SQLXMLBULKLOADLib.SQLXMLBulkLoad3

        'Set the connection string for the bulk load
        bulkLoad.ConnectionString = connection
        bulkLoad.KeepIdentity = False

        'Execute it!!!!
        bulkLoad.Execute(mappingFilePath, xmlFilePath)

        'We will force a GC after the DTS execution to clean up this COM mess.
        bulkLoad = Nothing

    End Sub

    Private Sub AddConnections(ByVal connection As String, ByVal dataFile As DataFile)

        'Get all the pieces of the connection string stored
        SetConnectionParts(connection)

        'Add a connection to the SQL server (it seems to require two connections, one for preload and one for _Load)
        mConnDest = mPackage.addSQLConnection(mSQLServer, mSQLDatabase, mSQLUser, mSQLPassword)
        mConnDest2 = mPackage.addSQLConnection(mSQLServer, mSQLDatabase, mSQLUser, mSQLPassword)

        'Create the source connection based on the file type
        Select Case Source.DataSetType
            Case DataSetTypes.DBF
                mConnSource = mPackage.addDBFConnection(dataFile.Folder)

            Case DataSetTypes.Text
                Dim txt As DTSTextData = DirectCast(Source, DTSTextData)
                mConnSource = mPackage.addTextConnection(dataFile.Path, txt.IsDelimited, txt.Delimiter, txt.TextQualifier, txt.HasHeader, txt.ColumnLengths)

            Case DataSetTypes.AccessDB
                Dim mdb As DTSAccessData = DirectCast(Source, DTSAccessData)
                mConnSource = mPackage.addAccessConnection(dataFile.Path, mdb.TableName)

            Case DataSetTypes.Excel
                Dim xls As DTSExcelData = DirectCast(Source, DTSExcelData)
                mConnSource = mPackage.addExcelConnection(dataFile.Path, "Sheet", xls.HasHeader)

        End Select

    End Sub

    Private Sub AddPreloadStep(ByVal dataFile As DataFile, ByVal exceptionFilePath As String)

        Dim task As New SQLDTSTask

        'Add a step and call it "PreloadStep", the task name will be "PreloadTask"
        mPackage.addStep("PreloadStep", "PreloadTask", "Copy the data file to SQL Server")

        'Set task name  (this way it is associated with the step)
        task.Name = "PreloadTask"

        'Set the source connection ID and then depending on the file type set the object name of the source
        task.SourceConnectionID = mConnSource
        Select Case Source.DataSetType
            Case DataSetTypes.DBF
                'File name without the ".DBF"
                task.SourceObject = dataFile.FileName.ToUpper.Replace(".DBF", "")

            Case DataSetTypes.Text
                'File path
                task.SourceObject = dataFile.Path

            Case DataSetTypes.AccessDB
                'Name of the Access table
                task.SourceObject = DirectCast(Source, DTSAccessData).TableName

            Case DataSetTypes.Excel
                'Spreadsheet name ?
                task.SourceObject = DirectCast(Source, DTSExcelData).TableName(dataFile.Path)

        End Select

        'specify the destination connection ID and the preload table name
        task.DestConnectionID = mConnDest
        task.DestObject = mPreloadTable

        'Create a new transformation wrapper object
        Dim trans As New SQLDTSTransformation("Preload")
        Dim column As SourceColumn
        Dim colTemp As SourceColumn

        'For each column in the source file
        For Each column In Source.Columns
            'Make a copy of the column because we need the column name to actually be the original column name
            'We coded ourselves into a corner trying to make the code generic and assume that it should always use column name
            'Later we discovered we need to use original column name for preload and column name for "real" load
            colTemp = New SourceColumn(column.Parent)
            colTemp.ColumnName = column.OriginalName
            colTemp.Length = column.Length
            colTemp.DataType = column.DataType
            colTemp.Ordinal = column.Ordinal

            'Add the column with the original column name to the source list
            trans.SourceColumns.Add(colTemp)

            'Add the column with the new column name to the destination list
            trans.DestColumns.Add(column)

            'Add the copy column command from originalName to newName
            'Modified this to always add a Trim() to every field.  This ensures that
            'extra spaces are never exist in the data
            trans.AddFormula(String.Format("DTSDestination(""{0}"") = Trim(DTSSource(""{1}""))", column.ColumnName, column.OriginalName))
            'trans.AddCopyColumnCommand(column.OriginalName, column.ColumnName)
        Next

        'Add the transformation to the task
        task.Transformations.Add(trans)

        'Now add the dataPumpTask to the package
        mPackage.addDataPumpTask(task, 0, exceptionFilePath)

    End Sub

    'Adds the steps to the package to actually move the data from preload tables to _Load tables
    Private Sub AddDTSSteps(ByVal errorCount As Integer, ByVal exceptionFilePath As String)

        Dim dest As DTSDestination
        Dim task As SQLDTSTask
        Dim trans As SQLDTSTransformation
        Dim destCol As DestinationColumn
        Dim sourceCol As SourceColumn
        Dim usedSources As New Dictionary(Of String, Boolean)
        Dim func As DTSFunction

        'We need to add a task/transformation for each destination table used in the package
        For Each dest In Destinations
            If dest.UsedInPackage Then

                'Create a new Task wrapper object
                task = New SQLDTSTask
                usedSources = New Dictionary(Of String, Boolean)    'Clear out the hashtable

                'Add the step for loading into this table
                mPackage.addStep(dest.TableName, String.Format("{0}_Task", dest.TableName), "Load data from preload table to load tables")

                'Set the task name
                task.Name = String.Format("{0}_Task", dest.TableName)

                'Set the Source connection ID and specify the name of the preload table
                task.SourceConnectionID = mConnDest
                task.SourceObject = mPreloadTable

                'Set the destination connection ID (same as source but it seems to make you use two)
                'and specify the name of the _Load table
                task.DestConnectionID = mConnDest2
                task.DestObject = String.Format("s{0}.{1}_Load", Study.StudyID, dest.TableName)

                'Create a new Transformation wrapper object for this table
                trans = New SQLDTSTransformation(dest.TableName)

                'Now for each column in this _Load table table
                For Each destCol In dest.Columns
                    'If the column has a formula
                    If Not destCol.Formula = "" Then
                        'Add this column to the DTS Package
                        trans.DestColumns.Add(destCol)

                        'Now check each source used in this destination formula and if it has not
                        'been added to the Package then add it
                        For Each sourceCol In destCol.SourceColumns
                            If Not usedSources.ContainsKey(sourceCol.ColumnName) OrElse usedSources(sourceCol.ColumnName) = False Then
                                trans.SourceColumns.Add(sourceCol)              'Add it to the package
                                usedSources.Add(sourceCol.ColumnName, True)     'Mark it as used so we don't add it twice
                            End If
                        Next

                        'If the field is a system field then we just force a straight copy
                        'From the preload table to the _Load table
                        If destCol.IsSystemField Then
                            trans.SourceColumns.Add(destCol)
                        End If

                        'Add the formula for this destination
                        trans.AddFormula(destCol.Formula)
                    End If
                Next

                'Okay now we have added all the columns and formulas for this task (_Load table)
                'Now we need to include any CUSTOM FUNCTIONS used in the formulas to the task ActiveX script

                'Add each function to the transformation object
                For Each func In DTSFunction.GetAllFunctions(Study.ClientID)
                    trans.AddFunction(func.SourceCode)
                Next

                'Add the transformation to the task
                task.Transformations.Add(trans)

                'Now we can add the task to the package (it corresponds with a step but the objects are not "technically" connected...FYI)
                'Specify the maximum number of rows that can fail on this DataPumpTask
                mPackage.addDataPumpTask(task, errorCount, exceptionFilePath)

                'If this is any type other than XML
                If Not Source.DataSetType = DataSetTypes.XML Then
                    'Now add a dependency to the step so that it cannot begin until the "PreloadStep" has completed
                    mPackage.addStepDependancy("PreloadStep", dest.TableName)
                End If
            End If
        Next

    End Sub

    'Splits the connection string into certain parts that we need: SERVER, DATABASE, USER, PASSWORD
    Private Sub SetConnectionParts(ByVal connection As String)

        'Split it into NAME-VALUE pairs
        Dim parts As String() = connection.Split(Char.Parse(";"))
        Dim part As String
        Dim values As String()

        'For each name-value pair
        For Each part In parts
            'Split it into the NAME and the VALUE
            values = part.Split(Char.Parse("="))

            'based on the NAME set certain variables to the VALUE
            Select Case values(0).ToLower.Trim
                Case "data source"
                    mSQLServer = values(1).Trim

                Case "initial catalog"
                    mSQLDatabase = values(1).Trim

                Case "uid"
                    mSQLUser = values(1).Trim

                Case "pwd"
                    mSQLPassword = values(1).Trim

            End Select
        Next

    End Sub

    'Event handler for monitoring the package execution progress
    Private Sub mPackage_PackageProgress(ByVal eventSource As String, ByVal progressDescription As String, ByVal rowCount As Integer) Handles mPackage.PackageProgress

        RaiseEvent PackageProgress(eventSource, progressDescription, rowCount)

    End Sub

#End Region

#Region " Review "

    ''' <summary>
    ''' Retrieve dataset for reviewing the loading result.
    ''' </summary>
    ''' <param name="fileID">loading data file ID</param>
    ''' <param name="beginID">retrieve records begin with this ID</param>
    ''' <param name="viewSkippedOnly">Flag indicates if view skipped record only</param>
    ''' <returns>
    ''' DataSet, which includes 5 DataTables
    ''' (1) Total records in preload table; increment for each retrieve
    ''' (2) First and last DF_ID in dataset
    ''' (3) Preload table data
    ''' (4) Load tables data records from different loading tables are joined into 1 record in this dataset
    ''' (5) Loading table schema table name, column name
    ''' </returns>
    ''' <remarks></remarks>
    Public Function Review(ByVal fileID As Integer, ByVal beginID As Integer, ByVal viewSkippedOnly As Boolean) As DataSet

        Using conn As New SqlConnection(AppConfig.QLoaderConnection)
            Dim cmd As New SqlCommand("LD_FileReview", conn)
            Try
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@File_id", fileID)
                cmd.Parameters.AddWithValue("@BeginID", beginID)
                cmd.Parameters.AddWithValue("@ViewSkippedOnly", IIf(viewSkippedOnly, 1, 0))

                Dim da As New SqlDataAdapter(cmd)
                Dim ds As New DataSet()
                da.Fill(ds, "LoadResult")

                Return ds

            Catch ex As Exception
                Throw New ArgumentException(String.Format("DB error: {0}", ex.Message))

            End Try
        End Using

    End Function

#End Region

    Protected Overrides Sub Finalize()

        MyBase.Finalize()

        Dim col As SourceColumn

        If Not mSource Is Nothing _
           AndAlso mSource.Columns IsNot Nothing _
           AndAlso mSource.Columns.Count > 0 Then
            For Each col In mSource.Columns
                RemoveHandler col.ColumnChanged, AddressOf RaiseSourceColumnEvent
            Next
        End If

        If mLockState = PackageLockStates.LockedByMe Then
            UnlockPackage()
        End If

    End Sub

    Public Sub LockPackage()

        Using conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
            Dim result As Integer = -1
            conn.Open()

            Using trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)
                Try
                    result = PackageDB.UpdatePackageStatus(trans, PackageID, Environment.UserName, True)
                    If result < 1 Then Throw New Exception("Package is already locked.")
                    mLockState = PackageLockStates.LockedByMe

                    trans.Commit()
                    conn.Close()

                Catch ex As Exception
                    trans.Rollback()
                    conn.Close()
                    Throw New PackageLockException(ex.Message, ex, PackageID)

                End Try
            End Using
        End Using

    End Sub

    Public Sub UnlockPackage()

        UnlockPackage(False)

    End Sub

    Public Sub UnlockPackage(ByVal forceUnlock As Boolean)

        If mLockState = PackageLockStates.LockedByMe OrElse (mLockState = PackageLockStates.LockedByOther AndAlso forceUnlock) Then
            Using conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
                Dim result As Integer = -1
                conn.Open()

                Using trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)
                    Try
                        If forceUnlock Then
                            result = PackageDB.UpdatePackageStatus(trans, PackageID, mLockedBy, False)
                        Else
                            result = PackageDB.UpdatePackageStatus(trans, PackageID, Environment.UserName, False)
                        End If
                        mLockState = PackageLockStates.Unlocked

                        trans.Commit()
                        conn.Close()

                    Catch ex As Exception
                        trans.Rollback()
                        Throw New PackageLockException(ex.Message, ex, PackageID)

                    End Try
                End Using
            End Using
        End If

    End Sub

    Public Function CreateNewNote(ByVal userName As String) As PackageNote

        Dim note As New PackageNote(AppConfig.QLoaderConnection, mPackageID, userName)

        Return note

    End Function

    Public Shared Function IsUniqueFriendlyPackageName(ByVal clientId As Integer, ByVal friendlyPackageName As String) As Boolean

        Return PackageDB.ConfirmUnqiueFriendlyPackageName(clientId, friendlyPackageName)

    End Function

End Class
