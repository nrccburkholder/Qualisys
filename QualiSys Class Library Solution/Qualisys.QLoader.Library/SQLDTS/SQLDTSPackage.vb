Option Strict Off

Imports DTS = Microsoft.SqlServer.DTSPkg80
Imports System.Runtime.InteropServices

'Event handler for when the DTS package progresses
Public Delegate Sub PackageProgressEventHandler(ByVal eventSource As String, ByVal progressDescription As String, ByVal rowCount As Integer)

'SQLDTSPackage is essentially a wrapper class around Microsoft's DTSPackage2 COMM object
'This class automates many of the steps to build a package and execute it.
'Many of the package settings here are not understood completely but have been "discovered"
'by creating DTS Packages through the SQL Server interface and exporting them to VB code.
Public Class SQLDTSPackage

    'Instance variables
    Private mPackage As DTS.Package2Class
    'Private WithEvents mPES As PackageEventsSink        'EventsSink (handles events through COMM)
    Public Event PackageProgress As PackageProgressEventHandler

    'Constructor
    Sub New(ByVal strPackageName As String)
        Me.mPackage = New DTS.Package2Class

        'Set the package name
        Me.mPackage.Name = strPackageName

        'Set a bunch of properties...
        Me.mPackage.WriteCompletionStatusToNTEventLog = False
        Me.mPackage.FailOnError = True
        Me.mPackage.PackagePriorityClass = DTS.DTSPackagePriorityClass.DTSPriorityClass_Normal
        Me.mPackage.MaxConcurrentSteps = 4
        Me.mPackage.LineageOptions = DTS.DTSLineageOptions.DTSLineage_None
        Me.mPackage.UseTransaction = True
        Me.mPackage.TransactionIsolationLevel = DTS.DTSIsolationLevel.DTSIsoLevel_CursorStability
        Me.mPackage.AutoCommitTransaction = False
        Me.mPackage.RepositoryMetadataOptions = DTS.DTSRepositoryMetadataOptions.DTSReposMetadata_Default
        Me.mPackage.UseOLEDBServiceComponents = True
        Me.mPackage.LogToSQLServer = False
        'Me.mPackage.LogFileName = "\\NRC4\NRC4\LoadingProject\LogFile.txt"
        Me.mPackage.LogServerFlags = DTS.DTSSQLServerStorageFlags.DTSSQLStgFlag_Default
        Me.mPackage.FailPackageOnLogFailure = False
        Me.mPackage.ExplicitGlobalVariables = False
        Me.mPackage.PackageType = DTS.DTSPackageType.DTSPkgType_Default
    End Sub


#Region " Connection SQL "
    Public Function addSQLConnection(ByVal SQLServer As String, ByVal SQLDatabase As String, ByVal userName As String, ByVal password As String) As Integer
        Dim dtsConnection As DTS.Connection2 = Me.mPackage.Connections.New("SQLOLEDB")
        Dim connID As Integer

        'Auto assign the connection IDs
        dtsConnection.ID = Me.mPackage.Connections.Count + 1
        dtsConnection.Name = SQLDatabase & "_" & dtsConnection.ID

        'Set all the properties...
        dtsConnection.Reusable = True
        dtsConnection.ConnectImmediate = False
        dtsConnection.DataSource = SQLServer
        dtsConnection.UserID = userName
        dtsConnection.Password = password
        dtsConnection.ConnectionTimeout = 0
        dtsConnection.Catalog = SQLDatabase
        dtsConnection.UseTrustedConnection = False
        dtsConnection.UseDSL = False
        dtsConnection.ConnectionProperties.Item("Persist Security Info").Value = True
        dtsConnection.ConnectionProperties.Item("User ID").Value = userName
        dtsConnection.ConnectionProperties.Item("Initial Catalog").Value = SQLDatabase
        dtsConnection.ConnectionProperties.Item("Data Source").Value = SQLServer
        dtsConnection.ConnectionProperties.Item("Locale Identifier").Value = 1033
        dtsConnection.ConnectionProperties.Item("Prompt").Value = 4
        dtsConnection.ConnectionProperties.Item("Connect Timeout").Value = 0
        dtsConnection.ConnectionProperties.Item("General Timeout").Value = 0
        dtsConnection.ConnectionProperties.Item("Use Procedure for Prepare").Value = 1
        dtsConnection.ConnectionProperties.Item("Auto Translate").Value = True
        dtsConnection.ConnectionProperties.Item("Packet Size").Value = 4096
        dtsConnection.ConnectionProperties.Item("Application Name").Value = "QLoader"
        dtsConnection.ConnectionProperties.Item("Use Encryption for Data").Value = False
        dtsConnection.ConnectionProperties.Item("Tag with column collation when possible").Value = False

        'add to the package and return the new ConnectionID
        Me.mPackage.Connections.Add(dtsConnection)
        connID = dtsConnection.ID

        dtsConnection = Nothing
        Return connID
    End Function

#End Region

#Region " Connection DBF "
    'Adds a connection to a DBF File
    Public Function addDBFConnection(ByVal folder As String) As Integer
        Dim dtsConnection As DTS.Connection2
        Dim connID As Integer

        dtsConnection = Me.mPackage.Connections.New("Microsoft.Jet.OLEDB.4.0")

        'Datasource is set to folder name
        dtsConnection.ConnectionProperties.Item("Data Source").Value = folder
        dtsConnection.ConnectionProperties.Item("Extended Properties").Value = "dBase IV"

        dtsConnection.Name = "DBF File"

        'Auto-assign the connectionID
        dtsConnection.ID = Me.mPackage.Connections.Count + 1

        'Set some properties
        dtsConnection.Reusable = True
        dtsConnection.ConnectImmediate = False
        dtsConnection.DataSource = folder       'Datasource is just the folder name
        dtsConnection.ConnectionTimeout = 60
        dtsConnection.UseTrustedConnection = False
        dtsConnection.UseDSL = False

        'Add to package and return the new ConnectionID
        Me.mPackage.Connections.Add(dtsConnection)
        connID = dtsConnection.ID

        dtsConnection = Nothing
        Return connID
    End Function

#End Region

#Region " Connection TXT "
    Public Function addTextConnection(ByVal filePath As String, ByVal isDelimited As Boolean, ByVal delimiter As String, ByVal textQualifier As String, ByVal hasHeader As Boolean, ByVal columnLengths As String) As Integer
        Dim dtsConnection As DTS.Connection2
        Dim connID As Integer

        dtsConnection = Me.mPackage.Connections.New("DTSFlatFile")

        dtsConnection.ConnectionProperties.Item("Data Source").Value = filePath
        dtsConnection.ConnectionProperties.Item("Mode").Value = 1
        dtsConnection.ConnectionProperties.Item("Row Delimiter").Value = vbCrLf
        If isDelimited Then
            dtsConnection.ConnectionProperties.Item("File Format").Value = 1
            dtsConnection.ConnectionProperties.Item("Column Delimiter").Value = delimiter
            dtsConnection.ConnectionProperties.Item("Text Qualifier").Value = textQualifier
            dtsConnection.ConnectionProperties.Item("Max characters per delimited column").Value = 8000
        Else
            dtsConnection.ConnectionProperties.Item("File Format").Value = 2
            dtsConnection.ConnectionProperties.Item("Column Lengths").Value = columnLengths
            dtsConnection.ConnectionProperties.Item("Number of Column").Value = columnLengths.Split(",").Length
        End If
        dtsConnection.ConnectionProperties.Item("File Type").Value = 1
        dtsConnection.ConnectionProperties.Item("Skip Rows").Value = 0
        dtsConnection.ConnectionProperties.Item("First Row Column Name").Value = hasHeader

        dtsConnection.Name = "TXT File"

        'Auto-assign the connectionID
        dtsConnection.ID = Me.mPackage.Connections.Count + 1

        'Set some properties
        dtsConnection.Reusable = True
        dtsConnection.ConnectImmediate = False
        dtsConnection.DataSource = filePath
        dtsConnection.ConnectionTimeout = 60
        dtsConnection.UseTrustedConnection = False
        dtsConnection.UseDSL = False

        'Add to package and return the new ConnectionID
        Me.mPackage.Connections.Add(dtsConnection)
        connID = dtsConnection.ID

        dtsConnection = Nothing
        Return connID
    End Function
#End Region

#Region " Connection MDB "
    Public Function addAccessConnection(ByVal filePath As String, ByVal tableName As String) As Integer
        Dim dtsConnection As DTS.Connection2
        Dim connID As Integer

        dtsConnection = Me.mPackage.Connections.New("Microsoft.Jet.OLEDB.4.0")

        dtsConnection.ConnectionProperties.Item("Data Source").Value = filePath
        dtsConnection.ConnectionProperties.Item("Mode").Value = 1

        dtsConnection.Name = "MDB File"
        'Auto-assign the connectionID
        dtsConnection.ID = Me.mPackage.Connections.Count + 1

        'Set some properties
        dtsConnection.Reusable = True
        dtsConnection.ConnectImmediate = False
        dtsConnection.DataSource = filePath
        dtsConnection.ConnectionTimeout = 60
        dtsConnection.UseTrustedConnection = False
        dtsConnection.UseDSL = False

        'Add to package and return the new ConnectionID
        Me.mPackage.Connections.Add(dtsConnection)
        connID = dtsConnection.ID

        dtsConnection = Nothing
        Return connID
    End Function
#End Region

#Region " Connection XLS "
    Public Function addExcelConnection(ByVal filePath As String, ByVal tableName As String, ByVal hasHeader As Boolean) As Integer
        Dim dtsConnection As DTS.Connection2
        Dim connID As Integer

        dtsConnection = Me.mPackage.Connections.New("Microsoft.ACE.OLEDB.12.0")
        dtsConnection.ConnectionProperties.Item("Data Source").Value = filePath
        If hasHeader Then
            dtsConnection.ConnectionProperties.Item("Extended Properties").Value = "Excel 12.0;HDR=YES;"
        Else
            dtsConnection.ConnectionProperties.Item("Extended Properties").Value = "Excel 12.0;HDR=NO;"
        End If

        dtsConnection.Name = "XLS File"
        'Auto-assign the connectionID
        dtsConnection.ID = Me.mPackage.Connections.Count + 1

        'Set some properties
        dtsConnection.Reusable = True
        dtsConnection.ConnectImmediate = False
        dtsConnection.DataSource = filePath
        dtsConnection.ConnectionTimeout = 60
        dtsConnection.UseTrustedConnection = False
        dtsConnection.UseDSL = False

        'Add to package and return the new ConnectionID
        Me.mPackage.Connections.Add(dtsConnection)
        connID = dtsConnection.ID

        dtsConnection = Nothing
        Return connID
    End Function
#End Region

#Region " Connection XML "
    Public Function addXMLConnection(ByVal filePath As String, ByVal tableName As String) As Integer
        Dim connID As Integer

        Return connID
    End Function
#End Region


#Region " Steps "
    'Adds a step to the DTS package and sets all the properties
    Public Sub addStep(ByVal StepName As String, ByVal TaskName As String, ByVal Description As String)
        'Instantiate COMM object
        Dim dtsStep As DTS.Step2 = Me.mPackage.Steps.New

        'Step name is important because we reference it for package precedence constraints
        dtsStep.Name = StepName
        dtsStep.Description = Description

        'Set all the properties
        dtsStep.ExecutionStatus = DTS.DTSStepExecStatus.DTSStepExecStat_Waiting
        dtsStep.TaskName = TaskName
        dtsStep.CommitSuccess = False
        dtsStep.RollbackFailure = True
        dtsStep.ScriptLanguage = "VBScript"
        dtsStep.AddGlobalVariables = True
        dtsStep.RelativePriority = 3
        dtsStep.CloseConnection = False
        dtsStep.ExecuteInMainThread = True
        dtsStep.IsPackageDSORowset = False

        'Changing this property to TRUE will allow for auto-rollback when error occurs
        'HOWEVER, seems to require DTC on client machine (which we don't want)
        'So if FALSE we need to handle package rollback manually (with SPs)
        dtsStep.JoinTransactionIfPresent = False
        dtsStep.DisableStep = False
        dtsStep.FailPackageOnError = True

        Me.mPackage.Steps.Add(dtsStep)      'Add step to package
        dtsStep = Nothing
    End Sub

    'Creates a package precedence contraint
    'This means that NEXTSTEP will only execute after FIRSTSTEP has completed
    Public Sub addStepDependancy(ByVal firstStep As String, ByVal nextStep As String)
        Dim dtsStep As DTS.Step2
        Dim dtsConstraint As DTS.PrecedenceConstraint

        dtsStep = Me.mPackage.Steps.Item(nextStep)      'Reference the nextStep
        'Create a new constraint for nextStep dependant on firstStep
        dtsConstraint = dtsStep.PrecedenceConstraints.New(firstStep)
        dtsConstraint.StepName = firstStep
        dtsConstraint.PrecedenceBasis = DTS.DTSStepPrecedenceBasis.DTSStepPrecedenceBasis_ExecResult
        dtsConstraint.Value = 0
        dtsStep.PrecedenceConstraints.Add(dtsConstraint)    'Add the constraint to the package
    End Sub

#End Region

#Region " Tasks "
    'Adds a task that executes a SQL statement
    'IE, call a stored proc after package execution
    Public Sub addExecuteSQLTask(ByVal ConnectionID As Integer, ByVal TaskName As String, ByVal Description As String, ByVal SQL As String)
        Dim dtsCustomTask As DTS.ExecuteSQLTask
        Dim dtsTask As DTS.Task = Me.mPackage.Tasks.New("DTSExecuteSQLTask")

        dtsCustomTask = dtsTask.CustomTask
        dtsCustomTask.Name = TaskName
        dtsCustomTask.Description = Description
        dtsCustomTask.SQLStatement = SQL
        dtsCustomTask.ConnectionID = ConnectionID
        dtsCustomTask.CommandTimeout = 0

        Me.mPackage.Tasks.Add(dtsTask)
        dtsCustomTask = Nothing
        dtsTask = Nothing
    End Sub

    'Add a DataPumpTask to the package.  This is what acutally transforms the data
    'SQLDTSTask is a wrapper for the DTSTask COMM object
    Public Sub addDataPumpTask(ByVal task As SQLDTSTask, ByVal errorCount As Integer, ByVal exceptionFilePath As String)
        Dim dtsTask As DTS.Task
        Dim dtsCustomTask As DTS.DataPumpTask2

        'Create new task
        dtsTask = Me.mPackage.Tasks.New("DTSDataPumpTask")
        dtsTask.Name = task.Name                'Set task name
        dtsCustomTask = dtsTask.CustomTask      'Reference the custom task

        dtsCustomTask.Name = task.Name          'Set task name
        dtsCustomTask.Description = task.Description

        'Set the ConnectionID of the data source
        dtsCustomTask.SourceConnectionID = task.SourceConnectionID
        'Set the source object (table)
        dtsCustomTask.SourceObjectName = task.SourceObject

        'Set the ConnectionID of the data destination
        dtsCustomTask.DestinationConnectionID = task.DestConnectionID
        'Set the destination object (table)
        dtsCustomTask.DestinationObjectName = task.DestObject

        'Report progress every X rows
        dtsCustomTask.ProgressRowCount = 1000
        'No errors are permitted without failing package
        dtsCustomTask.MaximumErrorCount = errorCount
        dtsCustomTask.FetchBufferSize = 1
        dtsCustomTask.UseFastLoad = True
        dtsCustomTask.InsertCommitSize = 0
        dtsCustomTask.ExceptionFileName = exceptionFilePath
        dtsCustomTask.ExceptionFileColumnDelimiter = "|"
        dtsCustomTask.ExceptionFileRowDelimiter = vbCrLf
        dtsCustomTask.ExceptionFileOptions = DTS.DTSExceptionFileOptions.DTSExcepFile_SingleFile70
        dtsCustomTask.AllowIdentityInserts = False
        dtsCustomTask.FirstRow = 0
        dtsCustomTask.LastRow = 0
        dtsCustomTask.FastLoadOptions = 2
        dtsCustomTask.DataPumpOptions = 0


        'SQLDTSTask contains a collection of SQLDTSTransformation
        'SQLDTSTransformation is wrapper for DTSTransformation COMM object
        'DTSTransformation is where all the good stuff happens...

        Dim tran As SQLDTSTransformation
        'Add each transformation to the task
        For Each tran In task.Transformations
            Me.addTransformation(dtsCustomTask, tran)
        Next

        Me.mPackage.Tasks.Add(dtsTask)      'add the task to the package
        dtsTask = Nothing
        dtsCustomTask = Nothing
    End Sub

#End Region

#Region " Transformation / Source Columns / Dest Columns "
    'Adds a destination column to a transformation
    'NOTE:  Destinations are ALWAYS SQL Server tables, hence we only need to check column
    'data type not dataset type (like in source col)
    Private Sub addDestColumn(ByVal trans As DTS.Transformation2, ByVal col As Column)
        'Create the column COMM object
        Dim dtsColumn As DTS.Column = trans.DestinationColumns.New(col.ColumnName, col.Ordinal)
        dtsColumn.Name = col.ColumnName     'Set column name
        dtsColumn.Ordinal = col.Ordinal     'Set the ordinal
        dtsColumn.Size = col.Length         'Set the size
        dtsColumn.Precision = 0             'Precision is zero since we don't use floating point
        dtsColumn.NumericScale = 0          '?
        dtsColumn.Nullable = True           'Don't think it matters, would it let you insert NULL into a column that didn't allow it???? NO!

        'Set the datatype and flags properties based on what data type the column is
        Select Case col.DataType
            Case DataTypes.Varchar
                dtsColumn.DataType = 129
                dtsColumn.Flags = 104
            Case DataTypes.Int
                dtsColumn.DataType = 3
                dtsColumn.Flags = 120
            Case DataTypes.DateTime
                dtsColumn.DataType = 135
                dtsColumn.Flags = 120
        End Select

        'Add the column to the destination columns collection of the transformation
        trans.DestinationColumns.Add(dtsColumn)
        trans = Nothing
    End Sub


    'Adds a transformation to a task
    Private Sub addTransformation(ByVal task As DTS.DataPumpTask2, ByVal tran As SQLDTSTransformation)
        Dim dtsTran As DTS.Transformation2
        Dim oTransProps As DTS.Properties

        'Create the transformation COMM object
        dtsTran = task.Transformations.New("DTS.DataPumpTransformScript")

        dtsTran.Name = tran.Name    'Set the name, this shows through in error messages etc.

        'Set some mysterious properties
        dtsTran.TransformFlags = 63
        dtsTran.ForceSourceBlobsBuffered = DTS.DTSForceMode.DTSForceMode_Default
        dtsTran.ForceBlobsInMemory = False
        dtsTran.InMemoryBlobSize = 1048576
        dtsTran.TransformPhases = 4


        'Add every source column to the transformation
        Dim col As Column
        For Each col In tran.SourceColumns
            Me.addSourceColumn(dtsTran, col)
        Next

        'Add every destination column to the transformation
        For Each col In tran.DestColumns
            Me.addDestColumn(dtsTran, col)
        Next

        oTransProps = dtsTran.TransformServerProperties

        'VERY IMPORTANT...THIS IS WHERE THE ACTIVEX SCRIPT IS INSERTED
        oTransProps.Item("Text").Value = tran.GetScript
        oTransProps.Item("Language").Value = "VBScript"     'Set language to VBScript
        oTransProps.Item("FunctionEntry").Value = "Main"    'Starting function is called "Main"

        'Add this transformation to the package.
        task.Transformations.Add(dtsTran)

        dtsTran = Nothing
        oTransProps = Nothing
        task = Nothing
        tran = Nothing
    End Sub

    'Adds a source column to a task
    'Many of these settings are specific to each data set type and column type
    'We are not sure if it is REALLY necessary to set all these properties, DTS seems
    'to figure things out pretty well, HOWEVER, just in case...
    'These settings are only discovered by using MS DTS wizard and exporting the code...
    Private Sub addSourceColumn(ByRef trans As DTS.Transformation2, ByVal col As Column)
        'Create a new Column COMM object
        Dim dtsColumn As DTS.Column = trans.SourceColumns.New(col.ColumnName, col.Ordinal)
        dtsColumn.Name = col.ColumnName         'Set the column name
        dtsColumn.Ordinal = col.Ordinal         'Set the ordinal value
        dtsColumn.Size = col.Length             'Set the size of the column

        'Precision is always zero, this must be for floating point which we don't care about
        dtsColumn.Precision = 0
        dtsColumn.NumericScale = 0          'Beats me
        dtsColumn.Nullable = True           'Just set it to true...

        'Check the dataset type
        Select Case col.Parent.DataSetType

            Case DataSetTypes.DBF    'DBF Settings
                'Now check the column data type
                Select Case col.DataType
                    Case DataTypes.Varchar
                        dtsColumn.DataType = 130
                        dtsColumn.Flags = 102
                    Case DataTypes.Int
                        dtsColumn.DataType = 5
                        dtsColumn.Flags = 118
                    Case DataTypes.DateTime
                        dtsColumn.DataType = 7
                        dtsColumn.Flags = 118
                End Select
            Case DataSetTypes.Text    'TXT Settings
                'Now check the column data type
                Select Case col.DataType
                    Case DataTypes.Varchar
                        dtsColumn.DataType = 129
                        dtsColumn.Flags = 32
                    Case DataTypes.Int
                        dtsColumn.DataType = 129
                        dtsColumn.Flags = 32
                    Case DataTypes.DateTime
                        dtsColumn.DataType = 129
                        dtsColumn.Flags = 32
                End Select
            Case DataSetTypes.AccessDB   'MDB Settings
                'Now check the column data type
                Select Case col.DataType
                    Case DataTypes.Varchar
                        dtsColumn.DataType = 130
                        dtsColumn.Flags = 106
                    Case DataTypes.Int
                        dtsColumn.DataType = 3
                        dtsColumn.Flags = 90
                    Case DataTypes.DateTime
                        dtsColumn.DataType = 7
                        dtsColumn.Flags = 122
                End Select
            Case DataSetTypes.Excel   'XLS Settings
                'Now check the column data type
                Select Case col.DataType
                    Case DataTypes.Varchar
                        dtsColumn.DataType = 130
                        dtsColumn.Flags = 102
                    Case DataTypes.Int
                        dtsColumn.DataType = 5
                        dtsColumn.Flags = 118
                    Case DataTypes.DateTime
                        dtsColumn.DataType = 7
                        dtsColumn.Flags = 118
                End Select
            Case DataSetTypes.SQL
                Select Case col.DataType
                    Case DataTypes.Varchar
                        dtsColumn.DataType = 129
                        dtsColumn.Flags = 104
                    Case DataTypes.Int
                        dtsColumn.DataType = 3
                        dtsColumn.Flags = 120
                    Case DataTypes.DateTime
                        dtsColumn.DataType = 135
                        dtsColumn.Flags = 120
                End Select
        End Select


        'Now add the column to the transformation
        trans.SourceColumns.Add(dtsColumn)
    End Sub
#End Region

    Public Sub Execute(ByVal sqlServer As String, ByVal sqlUser As String, ByVal sqlPassword As String, Optional ByVal savePackage As Boolean = False)
        Dim packName As String = Me.mPackage.Name

        'Dim cpContainer As UCOMIConnectionPointContainer
        'cpContainer = CType(Me.mPackage, UCOMIConnectionPointContainer)
        'Dim cpPoint As UCOMIConnectionPoint
        'mPES = New PackageEventsSink
        'Dim guid As guid = New guid("10020605-EB1C-11CF-AE6E-00AA004A34D5")
        'cpContainer.FindConnectionPoint(guid, cpPoint)
        'Dim intCookie As Integer
        'cpPoint.Advise(mPES, intCookie)


        If Not savePackage Then
            Try
                Me.mPackage.Execute()


                'cpPoint.Unadvise(intCookie)
                'cpPoint = Nothing
                'cpContainer = Nothing
                'mPES = Nothing

            Catch ex As Exception
                Dim errorMSG As String = ""
                Dim i As Integer
                Dim errorCode As Integer = 0
                Dim source As String = ""
                Dim description As String = ""

                For i = 1 To Me.mPackage.Steps.Count
                    If Me.mPackage.Steps.Item(i).ExecutionResult = DTS.DTSStepExecResult.DTSStepExecResult_Failure Then
                        Me.mPackage.Steps.Item(i).GetExecutionErrorInfo(pErrorCode:=errorCode, pbstrsource:=source, pbstrdescription:=description)
                        errorMSG &= source & ": " & description & vbCrLf
                    End If
                Next i

                Me.mPackage.UnInitialize()
                Throw New Exception(errorMSG)
            End Try
        Else
            Me.mPackage.SaveToSQLServer(sqlServer, sqlUser, sqlPassword, DTS.DTSSQLServerStorageFlags.DTSSQLStgFlag_Default)
        End If

        Me.mPackage.UnInitialize()
        Me.mPackage = Nothing
    End Sub

    'Package progress event handler
    'Private Sub mPES_PackageProgress(ByVal eventSource As String, ByVal progressDescription As String, ByVal rowCount As Integer) Handles mPES.PackageProgress
    '    'Take out for now.  We will run DTS Packages on the server so no need to monitor progress...
    '    'RaiseEvent PackageProgress(eventSource, progressDescription, rowCount)
    'End Sub

#Region " PackageEventsSink Class "
    'Private Class PackageEventsSink
    '    Implements DTS.PackageEvents

    '    Public Event PackageProgress As PackageProgressEventHandler

    '    Overridable Overloads Sub OnError(ByVal EventSource As String, ByVal ErrorCode As Integer, ByVal Source As String, ByVal Description As String, ByVal HelpFile As String, ByVal HelpContext As Integer, ByVal IDofInterfaceWithError As String, ByRef pbCancel As Boolean) Implements DTS.PackageEvents.OnError
    '        'Console.WriteLine(" OnError in {0}; ErrorCode = {1}, Source = {2}," & " Description = {3}", EventSource, ErrorCode, Source, Description)
    '    End Sub
    '    Overridable Overloads Sub OnFinish(ByVal EventSource As String) _
    '            Implements DTS.PackageEvents.OnFinish

    '    End Sub
    '    Overridable Overloads Sub OnProgress(ByVal EventSource As String, ByVal ProgressDescription As String, ByVal PercentComplete As Integer, ByVal ProgressCountLow As Integer, ByVal ProgressCountHigh As Integer) _
    '            Implements DTS.PackageEvents.OnProgress

    '        RaiseEvent PackageProgress(EventSource, ProgressDescription, ProgressCountLow)
    '        'Console.WriteLine(" OnProgress in {0}; ProgressDescription = {1}", _
    '        '    EventSource, ProgressDescription)
    '    End Sub
    '    Overridable Overloads Sub OnQueryCancel(ByVal EventSource As String, ByRef pbCancel As Boolean) Implements DTS.PackageEvents.OnQueryCancel
    '        If EventSource.Length > 0 Then
    '            'Console.WriteLine(" OnQueryCancel in {0}; pbCancel = {1}", _
    '            '    EventSource, pbCancel.ToString)
    '        Else
    '            'Console.WriteLine(" OnQueryCancel; pbCancel = {0}", pbCancel.ToString)
    '        End If
    '        pbCancel = False
    '    End Sub
    '    Overridable Overloads Sub OnStart(ByVal EventSource As String) _
    '            Implements DTS.PackageEvents.OnStart

    '        'Console.WriteLine(" OnStart in {0}", EventSource)
    '    End Sub
    'End Class
#End Region

End Class



