Imports PS.Framework.BusinessLogic
Imports System.IO
Imports System.Xml
Imports System.Xml.Serialization

#Region " Key Interface "
Public Interface IMailMergeQueueController
    Property MailMergeQueueControllerID() As Integer
End Interface
#End Region
#Region " MailMergeQueueController Class "
Public Class MailMergeQueueController
    Inherits BusinessBase(Of MailMergeQueueController)
    Implements IMailMergeQueueController
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeQueueControllerID As Integer
    Private mMergeName As String = String.Empty
    Private mStatusMsg As String = String.Empty
    Private mtemplateID As Integer
    Private mProjectID As Integer
    Private mFaqssID As String = String.Empty
    Private mMailStep As Integer
    Private mPaperConfigID As Integer
    Private mSurveyDataDirectory As String = String.Empty
    Private mMergeDirectory As String = String.Empty
    Private mSaveMergedWordDocs As Boolean
    Private mTotalRecordNumber As Integer
    Private mRecordsPerSubJob As Integer = Config.RecordsPerSubJob
    Private mSpecialInstructions As String = String.Empty
    Private mOperator As String = String.Empty
    Private mMyMergeStatus As MergeStatuses = MergeStatuses.Unknown
    Private mDateCreated As DateTime
    Private mDateModified As DateTime
    Private mStartDate As DateTime
    Private mEndDate As Nullable(Of DateTime)
    Private mMMQueueTemplateController As MailMergeQueueTemplateController = Nothing
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations
    Private mSurveyDataTable As DataTable = Nothing
    Private mSubJobDataTables As New List(Of DataTable)
    Private mNumberOfSubJobs As Integer
    Private mValidated As Boolean = False
    Private mInstanceCreateDate As DateTime = Now
    Private Const CLASSNAME As String = "MailMergeQueueController"
#End Region
#Region " Properties "
    Public Property MailMergeQueueControllerID() As Integer Implements IMailMergeQueueController.MailMergeQueueControllerID
        Get
            Return Me.mMailMergeQueueControllerID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeQueueControllerID = value
        End Set
    End Property
    Public Property MergeName() As String
        Get
            Return Me.mMergeName
        End Get
        Set(ByVal value As String)
            If Not (Me.mMergeName = value) Then
                Me.mMergeName = value
                PropertyHasChanged("MergeName")
            End If
        End Set
    End Property
    Public Property StatusMsg() As String
        Get
            Return Me.mStatusMsg
        End Get
        Set(ByVal value As String)
            If Not (Me.mStatusMsg = value) Then
                Me.mStatusMsg = value
                PropertyHasChanged("StatusMsg")
            End If
        End Set
    End Property
    Public Property TemplateID() As Integer
        Get
            Return Me.mtemplateID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mtemplateID = value) Then
                Me.mtemplateID = value
                PropertyHasChanged("TemplateID")
            End If
        End Set
    End Property
    Public Property ProjectID() As Integer
        Get
            Return Me.mProjectID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mProjectID = value) Then
                Me.mProjectID = value
                PropertyHasChanged("ProjectID")
            End If
        End Set
    End Property
    Public Property FaqssID() As String
        Get
            Return Me.mFaqssID
        End Get
        Set(ByVal value As String)
            If Not (Me.mFaqssID = value) Then
                Me.mFaqssID = value
                PropertyHasChanged("FaqssID")
            End If
        End Set
    End Property
    Public Property MailStep() As Integer
        Get
            Return Me.mMailStep
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mMailStep = value) Then
                Me.mMailStep = value
                PropertyHasChanged("MailStep")
            End If
        End Set
    End Property
    Public Property PaperConfigID() As Integer
        Get
            Return Me.mPaperConfigID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mPaperConfigID = value) Then
                Me.mPaperConfigID = value
                PropertyHasChanged("PaperConfigID")
            End If
        End Set
    End Property
    Public Property SurveyDataDirectory() As String
        Get
            Return Me.mSurveyDataDirectory
        End Get
        Set(ByVal value As String)
            If Not (Me.mSurveyDataDirectory = value) Then
                Me.mSurveyDataDirectory = value
                PropertyHasChanged("SurveyDataDirectory")
            End If
        End Set
    End Property
    Public Property MergeDirectory() As String
        Get
            Return Me.mMergeDirectory
        End Get
        Set(ByVal value As String)
            If Not (Me.mMergeDirectory = value) Then
                Me.mMergeDirectory = value
                PropertyHasChanged("MergeDirectory")
            End If
        End Set
    End Property
    Public Property SaveMergedWordDocs() As Boolean
        Get
            Return Me.mSaveMergedWordDocs
        End Get
        Set(ByVal value As Boolean)
            If Not (Me.mSaveMergedWordDocs = value) Then
                Me.mSaveMergedWordDocs = value
                PropertyHasChanged("SaveMergedWordDocs")
            End If
        End Set
    End Property
    Public Property TotalRecordNumber() As Integer
        Get
            Return Me.mTotalRecordNumber
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mTotalRecordNumber = value) Then
                Me.mTotalRecordNumber = value
                PropertyHasChanged("TotalRecordNumber")
            End If
        End Set
    End Property
    Public Property SpecialInstructions() As String
        Get
            Return Me.mSpecialInstructions
        End Get
        Set(ByVal value As String)
            If Not (Me.mSpecialInstructions = value) Then
                Me.mSpecialInstructions = value
                PropertyHasChanged("SpecialInstructions")
            End If
        End Set
    End Property
    Public Property SMOperator() As String
        Get
            Return Me.mOperator
        End Get
        Set(ByVal value As String)
            If Not (Me.mOperator = value) Then
                Me.mOperator = value
                PropertyHasChanged("SMOperator")
            End If
        End Set
    End Property
    Public Property MyMergeStatus() As MergeStatuses
        Get
            Return Me.mMyMergeStatus
        End Get
        Set(ByVal value As MergeStatuses)
            If Not (Me.mMyMergeStatus = value) Then
                Me.mMyMergeStatus = value
                PropertyHasChanged("MyMergeStatus")
            End If
        End Set
    End Property
    Public Property DateCreated() As DateTime
        Get
            Return Me.mDateCreated
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mDateCreated = value) Then
                Me.mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property DateModified() As DateTime
        Get
            Return Me.mDateModified
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mDateModified = value) Then
                Me.mDateModified = value
                PropertyHasChanged("DateModified")
            End If
        End Set
    End Property
    Public Property StartDate() As DateTime
        Get
            Return Me.mStartDate
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mStartDate = value) Then
                Me.mStartDate = value
                PropertyHasChanged("StartDate")
            End If
        End Set
    End Property
    Public Property EndDate() As Nullable(Of DateTime)
        Get
            Return Me.mEndDate
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            Me.mEndDate = value
        End Set
    End Property
    Public ReadOnly Property Validated() As Boolean
        Get
            Return Me.mValidated
        End Get
    End Property
    Public ReadOnly Property ValidationMessages() As Validation.ObjectValidations
        Get
            Return Me.mValidationMessages
        End Get
    End Property
    'TODO:  Will want to timestamp this for future threading.
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewMailMergeQueueController() As MailMergeQueueController
        Return New MailMergeQueueController
    End Function
    Public Shared Function GetTop1PendingFromQueue() As MailMergeQueueController
        Return MailMergeQueueControllerProvider.Instance.GetTop1PendingFromQueue()
    End Function
    Public Shared Function PingMailMergeDB() As Boolean
        Try
            Return MailMergeQueueControllerProvider.Instance.PingMailMergeDB
        Catch ex As Exception
            Return False
        End Try
    End Function
#End Region
#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw (New NotImplementedException("Delete method has not be implemented."))
        'MailMergeQueueControllerProvider.Instance.DeleteMailMergeQueueController(Me.mMailMergeQueueControllerID)
    End Sub
    Protected Overrides Sub Insert()
        Throw (New NotImplementedException("Insert method has not be implemented."))
        'Me.mMailMergeQueueControllerID = MailMergeQueueControllerProvider.Instance.InsertMailMergeQueueController(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw (New NotImplementedException("Update method has not be implemented."))
        'MailMergeQueueControllerProvider.Instance.UpdateMailMergeQueueController(Me)
    End Sub
#End Region
#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub
    Public Function Validate() As Validation.ObjectValidations
        Try
            ValidateSelf()
            If Not Me.mValidationMessages.ErrorsExist Then
                LoadData()
                If Not Me.mValidationMessages.ErrorsExist Then
                    ValidateSurveyData()
                    If Not Me.mValidationMessages.ErrorsExist Then
                        LoadTemplateController()
                    End If
                End If
            End If
            If Me.mValidationMessages.ErrorsExist Then
                Me.MyMergeStatus = MergeStatuses.Errored
            Else
                Me.mValidated = True
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "Validate", "", "Mail Merge Queue Controller has successfully validated."))
            End If
        Catch ex As System.Exception
            Me.mValidated = False
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "Validate", ex.StackTrace, ex.Message))
        End Try
        Return Me.mValidationMessages
    End Function
    Private Sub ValidateSelf()
        If Me.MailMergeQueueControllerID <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Queue Controller ID is not valid."))
        End If
        If Me.MergeName.Length <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Merge Name does not exist."))
        End If
        If Me.TemplateID <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Template ID does not exist."))
        End If
        If Me.ProjectID <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Project ID does not exist."))
        End If
        If Me.FaqssID.Length <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Faqss ID does not exist."))
        End If
        If Me.MailStep <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Mail Step does not exist."))
        End If
        If Me.PaperConfigID <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Paper Config ID does not exist."))
        End If
        If Me.MergeDirectory.Length <= 0 OrElse Not Directory.Exists(MergeDirectory) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Merge Directory does not exist."))
        End If
        If Me.TotalRecordNumber <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Total Record Number equals 0."))
        End If
        'User should be allowed to set special instructions to nothing.
        'If Me.SpecialInstructions.Length <= 0 Then
        '    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
        '                            "ValidateSelf", "", "Special Instructions do not exist."))
        'End If
        If Me.SMOperator.Length <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Operator does not exist."))
        End If
        'Note, the MM_GetTop1PendingFromQueue automatically updates the merge item to pending.
        If Me.MyMergeStatus <> MergeStatuses.Processing Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "Merge Status is not pending."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "ValidateSelf", "", "MailMergeQueueController has validated itself."))
        End If
    End Sub
    Private Sub ValidateSurveyData()
        Try
            If Me.mSurveyDataTable.Rows.Count <= 0 Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "No rows exist in survey data table."))
            End If
            If Me.mSurveyDataTable.Rows.Count <> Me.TotalRecordNumber Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Recorded rows differs from rows in survey data table."))
            End If
            For Each row As DataRow In Me.mSurveyDataTable.Rows
                If Me.TemplateID <> row("TEMPLATE_ID") Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Recorded template ID differs from rows in survey data table."))
                    Exit For
                End If
                If Me.ProjectID <> row("PROJECT_ID") Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Recorded project ID differs from rows in survey data table."))
                    Exit For
                End If
                If Me.FaqssID <> row("FAQSS_ID") Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Recorded FAQSS ID differs from rows in survey data table."))
                    Exit For
                End If
                If Me.MailStep <> row("MAILSTEP") Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Recorded mail step differs from rows in survey data table."))
                    Exit For
                End If
            Next
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSurveyData", "", "Survey Data has been deserialized and validated."))
            End If
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                    "ValidateSurveyData", ex.StackTrace, ex.Message))
        End Try
    End Sub
#End Region
#Region " Execution Methods "
    ''' <summary>
    ''' This method takes the print files generated and copies them out to the network.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub CopyNetwork()
        Try
            Dim files() As String = Directory.GetFiles(Config.TempPrintPath)
            For Each f As String In files
                Dim fi As New FileInfo(f)
                Dim netFile As String = CommonMethods.AppendLastSlash(Config.PrintPath) & fi.Name
                fi = Nothing
                File.Copy(f, netFile)
            Next
            CleanLocal()
        Catch ex As System.Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "CopyNetwork", ex.StackTrace, ex.Message))
        End Try
    End Sub
    ''' <summary>
    ''' This application requires fulltime network IO processing.  To aliviate the chance of
    ''' a network issue causing the process to fail, you should copy all needed network files
    ''' locally, then merge the documents locally.  Once done, we can worry about putting them
    ''' back out to the network.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub CopyLocal()
        Try
            CleanLocal()
            If Not Directory.Exists(MergeDirectory) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "CopyLocal", "", "Network Merge Directory does not exist."))
            Else
                If Directory.Exists(Config.TempMergePath) = False OrElse Directory.Exists(Config.TempDocPath) = False OrElse Directory.Exists(Config.TempPrintPath) = False Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "CopyLocal", "", "Required local directories do not exist."))
                Else                    
                    Dim files() As String = Directory.GetFiles(MergeDirectory)
                    For Each f As String In files
                        Dim fi As New FileInfo(f)
                        Dim newFile As String = CommonMethods.AppendLastSlash(Config.TempMergePath) & fi.Name
                        fi = Nothing
                        File.Copy(f, newFile)
                    Next
                End If
            End If
        Catch ex As System.Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "CopyLocal", ex.StackTrace, ex.Message))
        End Try
    End Sub
    ''' <summary>
    ''' Remove any files that may exist in the local directories.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub CleanLocal()
        Dim files() As String = Directory.GetFiles(Config.TempDocPath)
        For Each f As String In files
            File.Delete(f)
        Next
        files = Directory.GetFiles(Config.TempMergePath)
        For Each f As String In files
            File.Delete(f)
        Next
        files = Directory.GetFiles(Config.TempPrintPath)
        For Each f As String In files
            File.Delete(f)
        Next
    End Sub
    Private Sub LoadData()
        If File.Exists(CommonMethods.AppendLastSlash(Config.TempMergePath) & "MergeDataFile.xml") Then
            Dim streamReader As StreamReader = Nothing
            Try
                Me.mSurveyDataTable = New DataTable("MergeDataFile")
                streamReader = New StreamReader(CommonMethods.AppendLastSlash(Config.TempMergePath) & "MergeDataFile.xml")
                Dim xmlSerial As New XmlSerializer(Me.mSurveyDataTable.GetType())
                Me.mSurveyDataTable = xmlSerial.Deserialize(streamReader)
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "LoadData", "", "Survey Data Table was successfully deserialized."))
            Catch ex As Exception
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "LoadData", ex.StackTrace, ex.Message))
            Finally
                If streamReader IsNot Nothing Then
                    streamReader.Close()
                End If
            End Try
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                    "LoadData", "", "Data file does not exist at merge Location."))
        End If
    End Sub
    ''' <summary>
    ''' NOTE, the template controller should be using the local directories, not the network directories.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub LoadTemplateController()
        Me.mMMQueueTemplateController = MailMergeQueueTemplateController.NewMailMergeQueueTemplateController(Config.TempMergePath, Me.mMergeDirectory, Me.mtemplateID, Me.mPaperConfigID, Me.mMailMergeQueueControllerID, Me.mInstanceCreateDate)
        Me.mValidationMessages.AddCollection(Me.mMMQueueTemplateController.Validate())
    End Sub
    Public Function Merge() As Validation.ObjectValidations
        Try
            If Me.mValidated Then
                'TODO: Below
                'This should be in the Mail Merge Prep
                'Otherwise would fail validation on the prep.
                'PivotSurveyData()
                SplitSurveyDataTableInfoSubJobs()
                LogSurveyDataFile()
                Me.mValidationMessages.AddCollection(mMMQueueTemplateController.PrintDocs(Me.mSubJobDataTables))
            Else
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                        "Merge", "", "Queue Controller must first be validated prior to merging."))
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                            "Merge", "", "Queue: " & Me.mMailMergeQueueControllerID & " has been successfully merged."))
            End If
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "Merge", ex.StackTrace, ex.Message))
        End Try
        Return Me.mValidationMessages
    End Function
    Public Sub CompleteMergeJob(ByVal mergeStatus As MergeStatuses)
        Try
            MailMergeQueueControllerProvider.Instance.CompleteQueueJob(Me.mMailMergeQueueControllerID, Me.mValidationMessages.Get8KString(), _
                                        mergeStatus, Now())
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "CompleteMergeJob", ex.StackTrace, ex.Message))
        End Try
    End Sub
    Private Sub SplitSurveyDataTableInfoSubJobs()
        Dim totalRecords As Integer = Me.mTotalRecordNumber
        Dim splitCount As Integer = Me.mRecordsPerSubJob
        If totalRecords <= splitCount Then
            Me.mSubJobDataTables.Add(Me.mSurveyDataTable.Copy())
        Else
            For i As Integer = 0 To Me.mSurveyDataTable.Rows.Count - 1
                If i = 0 OrElse i Mod splitCount = 0 Then
                    Me.mSubJobDataTables.Add(Me.mSurveyDataTable.Clone())
                    Me.mSubJobDataTables(Me.mSubJobDataTables.Count - 1).TableName += "_" & i
                End If
                Me.mSubJobDataTables(Me.mSubJobDataTables.Count - 1).Rows.Add(Me.mSurveyDataTable.Rows(i).ItemArray())
            Next
        End If
        Me.mNumberOfSubJobs = Me.mSubJobDataTables.Count
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                "SplitSurveyDataTableInfoSubJobs", "", "Data has been split into sub jobs."))
    End Sub
#End Region
#Region " Helper Methods "
    Private Sub LogSurveyDataFile()
        MailMergeQueueControllerProvider.Instance.InsertMMFile(Me.mMailMergeQueueControllerID, FileTypes.OrginalFile, Me.SurveyDataDirectory)
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                "LogSurveyDataFile", "", "Survey Data File has been logged."))
    End Sub
#End Region
End Class
#End Region

#Region " MailMergeQueueController Collection Class "
Public Class MailMergeQueueControllers
    Inherits BusinessListBase(Of MailMergeQueueController)

End Class
#End Region

#Region " Data Base Class "
Public MustInherit Class MailMergeQueueControllerProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeQueueControllerProvider
    Private Const mProviderName As String = "MailMergeQueueControllerProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeQueueControllerProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeQueueControllerProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetTop1PendingFromQueue() As MailMergeQueueController
    Public MustOverride Function PingMailMergeDB() As Boolean
    Public MustOverride Function InsertMMFile(ByVal queueID As Integer, ByVal fileType As FileTypes, ByVal fileName As String) As Integer
    Public MustOverride Function CompleteQueueJob(ByVal queueID As Integer, ByVal statusMsg As String, ByVal mergeStatus As MergeStatuses, ByVal endDate As Nullable(Of DateTime))
#End Region
End Class
#End Region
