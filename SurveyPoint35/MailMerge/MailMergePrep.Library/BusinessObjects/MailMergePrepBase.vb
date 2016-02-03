Imports PS.Framework.BusinessLogic
Imports System.IO
Imports System.Xml
Imports System.Xml.Serialization

#Region " Key Interface "
Public Interface IMailMergePrepBase
    Property MailMergePrepBaseID() As Integer
End Interface
#End Region
#Region " Mail Merge Prep Base Class "
''' <summary>
''' This is the controller class for the User portion of the Mail Merge Process.
''' This class will Load and Validate itself and its children ensuring that the 
''' Merged item is ready to be queued for the Service portion of the mail merge.
''' </summary>
''' <remarks></remarks>
Public Class MailMergePrepBase
    Inherits BusinessBase(Of MailMergePrepBase)
    Implements IMailMergePrepBase
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergePrepBaseID As Integer
    Private mSurveyDataFilePath As String = String.Empty
    Private mTemplateDirectoryPath As String = String.Empty
    Private mTransferFolderName As String = String.Empty
    Private mMergeName As String = String.Empty
    Private mSaveMergedWordDocs As Boolean = True
    Private mTransferPath As String = String.Empty
    Private mInstructions As String = String.Empty
    Private mSpecialInstructions As String = String.Empty
    Private mSMUser As String = String.Empty
    Private mValidated As Boolean = False
    Private mLoaded As Boolean = False
    Private mTransfered As Boolean = False
    Private mMMData As MailMergeData = Nothing
    Private mMMTemplateController As MailMergeTemplateController = Nothing
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations
    Private Const CLASSNAME As String = "MailMergePrepBase"
#End Region
#Region " Properties "
    ''' <summary>
    ''' This Object identifier is not currently used for storage.  This library only
    ''' inserts Merge Queue items into the DAL.  It does not retrieve, save, or delete them.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property MailMergePrepBaseID() As Integer Implements IMailMergePrepBase.MailMergePrepBaseID
        Get
            Return Me.mMailMergePrepBaseID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergePrepBaseID = value
            'ReSet()
        End Set
    End Property
    Public Property SurveyDataFilePath() As String
        Get
            Return Me.mSurveyDataFilePath
        End Get
        Set(ByVal value As String)
            If Not (Me.mSurveyDataFilePath = value) Then
                Me.mSurveyDataFilePath = value
                ReSet()
                PropertyHasChanged("SurveyDataFilePath")
                Me.mValidated = False
            End If
        End Set
    End Property
    Public Property TemplateDirectoryPath() As String
        Get
            Return Me.mTemplateDirectoryPath
        End Get
        Set(ByVal value As String)
            If Not (Me.mTemplateDirectoryPath = value) Then
                Me.mTemplateDirectoryPath = value
                ReSet()
                PropertyHasChanged("TemplateDirectoryPath")
            End If
        End Set
    End Property
    Public Property MergeName() As String
        Get
            Return Me.mMergeName
        End Get
        Set(ByVal value As String)
            If Not (Me.mMergeName = value) Then
                Me.mMergeName = value
                ReSet()
                PropertyHasChanged("MergeName")
                Me.mValidated = False
            End If
        End Set
    End Property
    Public Property SpecialInstructions() As String
        Get
            Return Me.mSpecialInstructions
        End Get
        Set(ByVal value As String)
            If Not (Me.mSpecialInstructions = value) Then
                ReSet()
                Me.mSpecialInstructions = value
                PropertyHasChanged("SpecialInstructions")
            End If
        End Set
    End Property
    Public Property Instructions() As String
        Get
            Return Me.mInstructions
        End Get
        Set(ByVal value As String)
            If Not (Me.mInstructions = value) Then
                ReSet()
                Me.mInstructions = value
                PropertyHasChanged("Instructions")
            End If
        End Set
    End Property
    Public Property SMUser() As String
        Get
            Return Me.mSMUser
        End Get
        Set(ByVal value As String)
            If Not (Me.mSMUser = value) Then
                Me.mSMUser = value
                ReSet()
                PropertyHasChanged("SMUser")
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
                ReSet()
                PropertyHasChanged("SaveMergedWordDocs")
                Me.mValidated = False
            End If
        End Set
    End Property
    Public ReadOnly Property TransferPath() As String
        Get
            Return Me.mTransferPath
        End Get
    End Property
    Public ReadOnly Property ValidationMessages() As Validation.ObjectValidations
        Get
            Return Me.mValidationMessages
        End Get
    End Property
    Public ReadOnly Property Validated() As Boolean
        Get
            Return Me.mValidated
        End Get
    End Property
    Public ReadOnly Property Loaded() As Boolean
        Get
            Return Me.mLoaded
        End Get
    End Property
    Public ReadOnly Property Transfered() As Boolean
        Get
            Return Me.mTransfered
        End Get
    End Property
    Public ReadOnly Property MMData() As MailMergeData
        Get
            Return Me.mMMData
        End Get
    End Property
    Public ReadOnly Property TempPath() As String
        Get
            Return Config.TempPath
        End Get
    End Property
    Public ReadOnly Property TransferFolderName() As String
        Get
            Return Me.mTransferFolderName
        End Get
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.mTransferPath = Config.TransferPath
        Me.CreateNew()
    End Sub
    Public Sub New(ByVal surveyDataFilePath As String, ByVal templateDirectoryPath As String, _
                   ByVal mergeName As String, ByVal instructions As String, ByVal specialInstructions As String, _
                   ByVal currentUser As String)
        Me.mSurveyDataFilePath = surveyDataFilePath
        Me.mTemplateDirectoryPath = templateDirectoryPath
        Me.mMergeName = mergeName
        Me.mTransferPath = Config.TransferPath
        Me.mInstructions = instructions
        Me.mSpecialInstructions = specialInstructions
        Me.mSMUser = currentUser
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewMailMergePrepBase() As MailMergePrepBase
        Return New MailMergePrepBase
    End Function
    Public Shared Function NewMailMergePrepBase(ByVal surveyDataFilePath As String, ByVal templateDirectoryPath As String, _
                                                ByVal mergeName As String, ByVal instructions As String, _
                                                ByVal specialInstructions As String, ByVal currentUser As String) As MailMergePrepBase
        Return New MailMergePrepBase(surveyDataFilePath, templateDirectoryPath, mergeName, instructions, specialInstructions, currentUser)
    End Function
#End Region
#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw (New NotImplementedException("Delete method has not be implemented."))
        'MailMergePrepBaseProvider.Instance.DeleteMailMergePrepBase(Me.mMailMergePrepBaseID)
    End Sub
    Protected Overrides Sub Insert()
        Throw (New NotImplementedException("Insert method has not be implemented."))
        'Me.mMailMergePrepBaseID = MailMergePrepBaseProvider.Instance.InsertMailMergePrepBase(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw (New NotImplementedException("Update method has not be implemented."))
        'MailMergePrepBaseProvider.Instance.UpdateMailMergePrepBase(Me)
    End Sub
#End Region
#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub
    ''' <summary>
    ''' This method loads (and validates) load items for itself and it's child objects.
    ''' </summary>
    ''' <param name="validatedDT"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Load(Optional ByVal validatedDT As DataTable = Nothing) As Validation.ObjectValidations
        Try
            ValidateBaseOptions()
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mMMData = MailMergeData.NewMailMergeData(Me.SurveyDataFilePath, Me.MergeName)
                If validatedDT IsNot Nothing Then
                    Me.mValidationMessages.AddCollection(Me.mMMData.Load(validatedDT))
                Else
                    Me.mValidationMessages.AddCollection(Me.mMMData.Load())
                End If
                If Not Me.mValidationMessages.ErrorsExist Then
                    Me.mMMTemplateController = MailMergeTemplateController.NewMailMergeTemplateController(Me.TemplateDirectoryPath, Me.mMMData.TemplateID, Me.mMMData.NumberOfMailings)
                    Me.mValidationMessages.AddCollection(Me.mMMTemplateController.Load)
                    If Not Me.mValidationMessages.ErrorsExist Then
                        Me.mLoaded = True
                    End If
                End If
            End If
        Catch ex As System.Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "Load", ex.StackTrace, ex.Message))
        End Try
        Return Me.mValidationMessages
    End Function
    ''' <summary>
    ''' Once the object is loaded, it must be validated (prior to save).  This method
    ''' validates itself and calls it's child object to do so.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Validate() As Validation.ObjectValidations
        Try
            If Me.mLoaded AndAlso Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.AddCollection(Me.mMMData.Validate())
                If Not Me.mValidationMessages.ErrorsExist Then
                    Me.mValidationMessages.AddCollection(Me.mMMTemplateController.Validate(Me.mMMData.SurveyDataBaseTable, Me.mMMData.TemplateID))
                End If
            Else
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "Validate", "", "You must first load the Mail Merge Prep Base prior to Validating the object."))
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidated = True
            End If
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "Validate", ex.StackTrace, ex.Message))
        End Try
        Return Me.mValidationMessages
    End Function
    ''' <summary>
    ''' This method validates basic information required prior to loading the object.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ValidateBaseOptions()
        If Me.mSurveyDataFilePath.Length = 0 OrElse Not System.IO.File.Exists(Me.mSurveyDataFilePath) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "ValidationBaseOptions", "", "An Invalid path was given for the Survey Data File."))
        End If
        If Me.mTemplateDirectoryPath.Length = 0 OrElse Not System.IO.Directory.Exists(Me.mTemplateDirectoryPath) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "ValidationBaseOptions", "", "An Invalid path was given for the Template Directory."))
        End If
        If Me.mMergeName.Length = 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "ValidationBaseOptions", "", "A Merge Name must be given."))
        End If
        If Me.mTransferPath.Length = 0 OrElse Not System.IO.Directory.Exists(Me.mTransferPath) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "ValidationBaseOptions", "", "An Invalid path was given for the Transfer path."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), "MailMergePrepBase", "ValidationBaseOptions", "", "Base Options were successfully validated."))
        End If
    End Sub
#End Region
#Region " Execution Methods "
    ''' <summary>
    ''' This method only works after the object has been validated.  It will take 1 - 5 records from the
    ''' data file and create 'preview word documents out of them.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GeneratePreview() As Validation.ObjectValidations
        Dim retVal As New Validation.ObjectValidations
        If Me.Validated Then
            retVal.AddCollection(Me.mMMTemplateController.GeneratePreview(Me.mMMData.SurveyDataBaseTable, Me.mMMData.GetFullTempPath))
        End If
        Return retVal
    End Function
    ''' <summary>
    ''' This methods moves the data and doc (template) files to the LAN and inserts the Merge
    ''' Queue records letting the service know it has a merge item to do.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Transfer() As Validation.ObjectValidations
        If Me.Loaded AndAlso Me.Validated AndAlso Not Me.mValidationMessages.ErrorsExist Then
            Try
                TransferFiles()
                If Not Me.mValidationMessages.ErrorsExist Then
                    SaveTransferData()
                    If Not Me.mValidationMessages.ErrorsExist Then
                        Me.mTransfered = True
                        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                                "Transfer", "", "Survey Merge Transfer was successful."))
                    End If
                End If
            Catch ex As Exception
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "Transfer", ex.StackTrace, ex.Message))
            End Try
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "Transfer", "", "Can't transfer.  Either not loaded/validated or errors exist."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                       "Transfer", "", "Survey Merge Files have been successfully transfered."))
        End If
        Return Me.mValidationMessages
    End Function
    ''' <summary>
    ''' This method transfers the original data file, serializes the merge data file and modified original (to xml).
    ''' It also calls the template controller to move the word templates out to the LAN.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub TransferFiles()
        Dim transPath As String = Config.TransferPath
        Dim newFolderName As String = (CommonMethods.CleanFolderName(Me.MergeName))
        Dim baseFileName As String = "ModifiedOriginalData.xml"
        Dim mergeDataFile As String = "MergeDataFile.xml"
        Dim serialWriter As StreamWriter = Nothing
        Dim baseTable As DataTable = Me.MMData.GetModifiedDataTableOriginalFormat()
        baseTable.TableName = "ModifiedOriginalData"
        If newFolderName.Length > 20 Then
            newFolderName = newFolderName.Substring(0, 20)
        End If
        newFolderName = Year(Now).ToString & Month(Now).ToString & newFolderName & Guid.NewGuid().ToString()
        Me.mTransferFolderName = newFolderName
        Try
            If Not Directory.Exists(CommonMethods.AppendLastSlash(transPath) & newFolderName) Then
                Directory.CreateDirectory(CommonMethods.AppendLastSlash(transPath) & newFolderName)
            End If
            'Transfer the base data file.
            Dim fi As New FileInfo(Me.mSurveyDataFilePath)
            File.Move(Me.mSurveyDataFilePath, CommonMethods.AppendLastSlash(transPath) & CommonMethods.AppendLastSlash(newFolderName) & fi.Name)
            'Transfer the XML
            serialWriter = New StreamWriter(CommonMethods.AppendLastSlash(transPath) & CommonMethods.AppendLastSlash(newFolderName) & baseFileName)
            Dim xmlWriter As New XmlSerializer(baseTable.GetType())
            xmlWriter.Serialize(serialWriter, baseTable)
            serialWriter.Close()
            serialWriter = New StreamWriter(CommonMethods.AppendLastSlash(transPath) & CommonMethods.AppendLastSlash(newFolderName) & mergeDataFile)
            xmlWriter = New XmlSerializer(Me.MMData.SurveyDataBaseTable.GetType())
            xmlWriter.Serialize(serialWriter, Me.MMData.SurveyDataBaseTable)
            serialWriter.Close()
            serialWriter = Nothing
            Me.mValidationMessages.AddCollection(Me.mMMTemplateController.TransferFiles(CommonMethods.AppendLastSlash(transPath) & CommonMethods.AppendLastSlash(newFolderName)))
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                            "TransferFiles", "", "Files were successfully transfered."))
            End If
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                    "TransferFiles", ex.StackTrace, ex.Message))
        Finally
            If serialWriter IsNot Nothing Then
                serialWriter.Close()
            End If
        End Try
    End Sub
    ''' <summary>
    ''' This method calls the DAL to insert a merge queueue item into the database using data from 
    ''' itself and its child objects.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SaveTransferData()
        MailMergeTemplateInstruction.SetMailMeregeTemplateInstruction(Me.MMData.TemplateID, Me.mInstructions, Me.mSpecialInstructions)
        Me.MailMergePrepBaseID = MailMergePrepBaseProvider.Instance.QueueSurveyMerge(Me.MergeName, Me.MMData.TemplateID, Me.MMData.ProjectID, _
                                                            Me.MMData.FaqssID, Me.MMData.NumberOfMailings, _
                                                            Me.mMMTemplateController.PaperConfigID, Me.SurveyDataFilePath, _
                                                            CommonMethods.AppendLastSlash(Config.TransferPath) & CommonMethods.AppendLastSlash(Me.TransferFolderName), _
                                                            Me.MMData.TotalRecordCount, Me.SaveMergedWordDocs, Me.Instructions, Me.SpecialInstructions, Me.SMUser)
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                                 "SaveTransferPath", "", "Transfer Data successfully saved."))
    End Sub
#End Region
#Region " Helper Methods "
    Friend Sub ReSet()
        Me.mLoaded = False
        Me.mValidated = False
        Me.mTransfered = False
        Me.mMMData.ReSet()
        Me.mMMTemplateController.ReSet()
    End Sub
#End Region
End Class
#End Region

#Region " Mail Merge Prep Base Collection Class "
Public Class MailMergePrepBases
    Inherits BusinessListBase(Of MailMergePrepBase)

End Class
#End Region

#Region " Data Base Class "
Public MustInherit Class MailMergePrepBaseProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergePrepBaseProvider
    Private Const mProviderName As String = "MailMergePrepBaseProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergePrepBaseProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergePrepBaseProvider)(mProviderName)
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
    'Public MustOverride Function GetMailMergePrepBases() As MailMergePrepBases
    'Public MustOverride Function GetMailMergePrepBase(ByVal mailMergePrepBaseID As Integer) As MailMergePrepBase
    'Public MustOverride Sub DeleteMailMergePrepBase(ByVal mailMergePrepBaseID As Integer)
    'Public MustOverride Sub UpdateMailMergePrepBase(ByVal instance As MailMergePrepBase)
    'Public MustOverride Function InsertMailMergePrepBase(ByVal instance As MailMergePrepBase) As Integer
    Public MustOverride Function QueueSurveyMerge(ByVal mergeName As String, ByVal templateID As Integer, ByVal projectID As Integer, _
                                                  ByVal faqssID As String, ByVal mailStep As Integer, ByVal paperConfigID As Integer, _
                                                  ByVal surveyDataDirectory As String, ByVal mergeDirectory As String, _
                                                  ByVal totalRecordNum As Integer, ByVal saveMergedWordDocs As Boolean, ByVal insructions As String, ByVal specialInstructions As String, _
                                                  ByVal currentUser As String) As Integer
#End Region
End Class
#End Region
