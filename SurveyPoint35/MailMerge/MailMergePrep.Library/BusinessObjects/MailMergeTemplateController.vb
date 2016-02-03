Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO

#Region " Key Interface "
Public Interface IMailMergeTemplateController
    Property MailMergeTemplateControllerID() As Integer
End Interface
#End Region
#Region " MailMergeTemplateController Class "
Public Class MailMergeTemplateController
    Inherits BusinessBase(Of MailMergeTemplateController)
    Implements IMailMergeTemplateController

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeTemplateControllerID As Integer
    Private mTemplatePath As String = String.Empty
    Private mTemplateID As Integer
    Private mNumberOfMailings As Integer
    Private mMailMergeTemplates As MailMergeTemplates
    Private mLoaded As Boolean = False
    Private mValidated As Boolean = False
    Private mPaperConfigID As Integer
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations
    Private Const CLASSNAME As String = "MailMergeTemplateController"
#End Region

#Region " Properties "
    Public Property MailMergeTemplateControllerID() As Integer Implements IMailMergeTemplateController.MailMergeTemplateControllerID
        Get
            Return Me.mMailMergeTemplateControllerID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeTemplateControllerID = value
        End Set
    End Property
    Public Property TemplatePath() As String
        Get
            Return Me.mTemplatePath
        End Get
        Set(ByVal value As String)
            If Not (Me.mTemplatePath = value) Then
                Me.mTemplatePath = value
                ReSet()
                PropertyHasChanged("TemplatePath ")
            End If
        End Set
    End Property
    Public ReadOnly Property MMTemplates() As MailMergeTemplates
        Get
            Return Me.mMailMergeTemplates
        End Get
    End Property
    Public Property TemplateID() As Integer
        Get
            Return Me.mTemplateID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mTemplateID = value) Then
                Me.mTemplateID = value
                ReSet()
                PropertyHasChanged("TemplateID")
            End If
        End Set
    End Property
    Public Property NumberOfMailings() As Integer
        Get
            Return Me.mNumberOfMailings
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mNumberOfMailings = value) Then
                Me.mNumberOfMailings = value
                PropertyHasChanged("NumberOfMailings")
            End If
        End Set
    End Property
    Public ReadOnly Property PaperConfigID() As Integer
        Get
            Return Me.mPaperConfigID
        End Get
    End Property
    Public ReadOnly Property Loaded() As Boolean
        Get
            Return Me.mLoaded
        End Get
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
#End Region

#Region " Constructors "
    Public Sub New()
        Me.mMailMergeTemplates = New MailMergeTemplates
    End Sub
    Public Sub New(ByVal templatePath As String, ByVal templateID As Integer, ByVal numOfMailings As Integer)
        Me.mTemplatePath = templatePath
        Me.mTemplateID = templateID
        Me.mNumberOfMailings = numOfMailings
        Me.mMailMergeTemplates = New MailMergeTemplates
    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeTemplateController() As MailMergeTemplateController
        Return New MailMergeTemplateController
    End Function
    Public Shared Function NewMailMergeTemplateController(ByVal templatePath As String, ByVal templateID As Integer, ByVal numOfMailings As Integer) As MailMergeTemplateController
        Return New MailMergeTemplateController(templatePath, templateID, numOfMailings)
    End Function
#End Region

#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
    End Sub
#End Region

#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub

    Public Function Validate(ByVal dataFileSchemaTable As DataTable, ByVal templateID As Integer) As Validation.ObjectValidations
        If Me.mLoaded Then
            ValidateTemplates(dataFileSchemaTable)            
            If Not Me.mValidationMessages.ErrorsExist Then
                SetPaperConfigID()
                CheckDataAndDocTemplateID(templateID)
                If Not Me.mValidationMessages.ErrorsExist Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                            "Validate", "", "Validation successfully completed."))
                    Me.mValidated = True
                End If
            End If
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "Validate", "", "The Mail Merge Template Controller object must be loaded prior to validating."))
            Me.mValidated = False
        End If
        Return Me.mValidationMessages
    End Function
#End Region

#Region " Execution Methods "
    Public Function Load() As Validation.ObjectValidations
        If Me.Loaded Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Warning, CommonMethods.VTToString(ValidationTypes.Template), "MailMergeTemplateController", "Load", "", "Object has already been loaded."))
        Else
            ValidateBaseProperties()
            If Not Me.mValidationMessages.ErrorsExist Then
                Dim pattern As String = String.Format("MM_{0:D5}_??_?_??_??_???_??.doc", Me.mTemplateID, Me.mNumberOfMailings)
                Dim files() As String = Directory.GetFiles(Me.mTemplatePath, pattern)
                Dim patternLessTemplate As String = String.Format("MM_?????_??_?_??_??_???_??.doc", Me.mNumberOfMailings)
                Dim filesLessTemplate() As String = Directory.GetFiles(Me.mTemplatePath, patternLessTemplate)
                If files.Length <> filesLessTemplate.Length Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                                    "ValidateBaseProperties", "", "Data Template ID does not match the selected Templates."))
                Else
                    For Each strFile As String In files
                        Dim fi As New FileInfo(strFile)
                        If IsNumeric(fi.Name.Substring(9, 2)) AndAlso Not (CInt(fi.Name.Substring(9, 2)) = Me.mNumberOfMailings) Then
                            'Do nothing, this is a cover letter not associated with this mail step.
                        Else
                            Dim mmTemplate As MailMergeTemplate = MailMergeTemplate.NewMailMergeTemplate(strFile)
                            Me.mValidationMessages.AddCollection(mmTemplate.Load)
                            If Me.mValidationMessages.ErrorsExist Then
                                Return Me.mValidationMessages
                            Else
                                Me.mMailMergeTemplates.Add(mmTemplate)
                            End If
                        End If                        
                    Next
                End If                
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mLoaded = True
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), "MailMergeTemplateController", "Load", "", "Templates Controller successfully loaded."))
            End If            
        End If
        Return Me.mValidationMessages
    End Function
    Public Function GeneratePreview(ByVal dt As DataTable, ByVal path As String) As Validation.ObjectValidations
        Dim validations As New Validation.ObjectValidations
        If Me.Validated Then
            For i As Integer = 0 To Me.mMailMergeTemplates.Count - 1
                validations.Add(Me.mMailMergeTemplates(i).GeneratePreview(dt, path))
            Next
        Else
            'validations.Add(New Validations(MessageTypes.Error, 
        End If
        Return validations
    End Function
    Public Sub CheckDataAndDocTemplateID(ByVal dataTemplateID As Integer)        
        For i As Integer = 0 To Me.mMailMergeTemplates.Count - 1
            If dataTemplateID <> Me.mMailMergeTemplates(i).FileTemplateID Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                            "CheckDataAndDocTemplateID", "", Me.mMailMergeTemplates(i).FileName & " does not match data template ID of " & dataTemplateID & "."))
            End If
        Next
    End Sub
    Public Sub ValidateTemplates(ByVal dt As DataTable)
        For i As Integer = 0 To Me.mMailMergeTemplates.Count - 1
            Me.mValidationMessages.AddCollection(Me.mMailMergeTemplates(i).Validate(dt))
        Next
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                "ValidateTemplates", "", "Method has completed."))
    End Sub
    Public Function TransferFiles(ByVal transferPath As String) As Validation.ObjectValidations
        If Me.Loaded AndAlso Me.Validated Then
            If Me.mMailMergeTemplates.Count > 0 Then
                Try
                    For Each template As MailMergeTemplate In Me.mMailMergeTemplates
                        If template.Loaded AndAlso template.Validated Then
                            File.Copy(template.TemplatePathAndName, CommonMethods.AppendLastSlash(transferPath) & template.FileName)
                        Else
                            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "TransferFiles", "", "A Template has not been validated."))
                        End If
                    Next
                    If Not Me.mValidationMessages.ErrorsExist Then
                        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "TransferFiles", "", "Templates were successfully transfered."))
                    End If
                Catch ex As Exception
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "TransferFiles", ex.StackTrace, ex.Message))
                End Try
            Else
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "TransferFiles", "", "No Templates currently exist."))
            End If
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "TransferFiles", "", "Template Controller is either not loaded, or not validated."))
        End If
        Return Me.mValidationMessages
    End Function
    Public Sub SetPaperConfigID()
        Dim paperConfigID As Integer = 0
        Dim paperConfigIDsMatch As Boolean = True
        For Each template As MailMergeTemplate In Me.mMailMergeTemplates
            If paperConfigID = 0 Then
                paperConfigID = template.PaperConfigID
            End If
            If paperConfigID <> template.PaperConfigID Then
                paperConfigIDsMatch = False
                Exit For
            End If
        Next
        If paperConfigIDsMatch Then
            Me.mPaperConfigID = paperConfigID
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "SetPaperConfigID", "", "Paper Config ID set in template controller."))
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "SetPaperConfigID", "", "Paper Config IDs do not match between templates."))
        End If
    End Sub
#End Region

#Region " Helper Methods "
    Friend Sub ReSet()
        Me.mLoaded = False
        Me.mValidated = False
        If Me.mMailMergeTemplates IsNot Nothing Then
            For i As Integer = 0 To Me.mMailMergeTemplates.Count - 1
                Me.mMailMergeTemplates(i).ReSet()
            Next
        End If
    End Sub
    Public Sub ValidateBaseProperties()
        If Me.mTemplatePath.Length = 0 OrElse Not Directory.Exists(Me.mTemplatePath) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), "MailMergeTemplateController", "ValidateBaseProperties", "", "An Invalid Template Path was given."))
        End If
        If Me.mTemplateID <= 0 OrElse mNumberOfMailings <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), "MailMergeTemplateController", "ValidateBaseProperties", "", "Template ID or Number Of Mailings was not set in Template Controller."))
        End If
    End Sub
#End Region
End Class
#End Region


#Region " MailMergeTemplateController Collection Class "
Public Class MailMergeTemplateControllers
    Inherits BusinessListBase(Of MailMergeTemplateController)

End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeTemplateControllerProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeTemplateControllerProvider
    Private Const mProviderName As String = "MailMergeTemplateControllerProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeTemplateControllerProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeTemplateControllerProvider)(mProviderName)
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

#End Region
End Class
#End Region
