Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO
Imports Aspose.Words

#Region " Key Interface "
Public Interface IMailMergeQueueTemplateController
    Property MailMergeQueueTemplateControllerID() As Integer
End Interface
#End Region
#Region " MailMergeQueueTemplateController Class "
Public Class MailMergeQueueTemplateController
    Inherits BusinessBase(Of MailMergeQueueTemplateController)
    Implements IMailMergeQueueTemplateController

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeQueueTemplateControllerID As Integer
    Private mMailMergeQueueID As Integer
    Private mMegeDirectory As String = String.Empty
    Private mNetworkMergeDirectory As String = String.Empty
    Private mTemplateID As Integer
    Private mPaperConfigID As Integer        
    Private mMailMergeQueueTemplates As New MailMergeQueueTemplates
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations
    Private Const CLASSNAME As String = "MailMergeQueueTemplateController"
    Private mInstanceCreateDate As DateTime = Now
#End Region

#Region " Properties "
    Public Property MailMergeQueueTemplateControllerID() As Integer Implements IMailMergeQueueTemplateController.MailMergeQueueTemplateControllerID
        Get
            Return Me.mMailMergeQueueTemplateControllerID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeQueueTemplateControllerID = value
        End Set
    End Property    
    Public ReadOnly Property ValidationMessages() As Validation.ObjectValidations
        Get
            Return Me.mValidationMessages
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
    Public Sub New(ByVal mergeDirectory As String, ByVal networkMergeDirectory As String, ByVal templateID As Integer, ByVal paperConfigID As Integer, ByVal queueID As Integer, ByVal instanceCreateDate As DateTime)
        Me.mTemplateID = templateID
        Me.mPaperConfigID = paperConfigID
        Me.mMailMergeQueueID = queueID
        Me.mMegeDirectory = mergeDirectory
        Me.mNetworkMergeDirectory = networkMergeDirectory
        Me.mInstanceCreateDate = instanceCreateDate
    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeQueueTemplateController() As MailMergeQueueTemplateController
        Return New MailMergeQueueTemplateController
    End Function
    Public Shared Function NewMailMergeQueueTemplateController(ByVal mergeDirectory As String, ByVal networkMergeDirectory As String, ByVal templateID As Integer, ByVal paperConfigID As Integer, ByVal queueID As Integer, ByVal instanceCreateDate As DateTime) As MailMergeQueueTemplateController
        Return New MailMergeQueueTemplateController(mergeDirectory, networkMergeDirectory, templateID, paperConfigID, queueID, instanceCreateDate)
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

    Public Function Validate() As Validation.ObjectValidations
        Load()
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "Validate", "", "MailMergeQueueTemplateContoller has successfully validated."))
        End If
        Return Me.mValidationMessages
    End Function
#End Region

#Region " Execution Methods "
    Public Function Load() As Validation.ObjectValidations
        Dim pattern As String = String.Format("MM_{0:D5}_??_?_??_??_???_??.doc", Me.mTemplateID)
        Dim files() As String = Directory.GetFiles(Me.mMegeDirectory, pattern)
        For Each strFile As String In files
            Dim mmTemplate As MailMergeQueueTemplate = MailMergeQueueTemplate.NewMailMergeQueueTemplate(Me.mMailMergeQueueID, strFile, Me.mNetworkMergeDirectory, Me.mTemplateID, Me.mPaperConfigID, Me.mInstanceCreateDate)
            Me.mValidationMessages.AddCollection(mmTemplate.Validate)
            If Me.mValidationMessages.ErrorsExist Then
                Return Me.mValidationMessages
            Else
                Me.mMailMergeQueueTemplates.Add(mmTemplate)
            End If
        Next
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "Load", "", "MailMergeQueueTemplateContoller has successfully loaded."))
        End If
        Return Me.mValidationMessages
    End Function
    Friend Function PrintDocs(ByVal dts As List(Of DataTable)) As Validation.ObjectValidations
        For j As Integer = 0 To Me.mMailMergeQueueTemplates.Count - 1
            Dim template As MailMergeQueueTemplate = Me.mMailMergeQueueTemplates(j)
            template.InsertTemplateMMFile()
            For i As Integer = 0 To dts.Count - 1
                Dim dt As DataTable = dts(i)
                Me.mValidationMessages.AddCollection(template.PrintDoc(dt, i))
            Next
        Next
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "PrintDocs", "", "Documents were successfully printed."))
        End If
        Return Me.mValidationMessages
    End Function
#End Region

#Region " Helper Methods "

#End Region
End Class
#End Region


#Region " MailMergeQueueTemplateController Collection Class "
Public Class MailMergeQueueTemplateControllers
    Inherits BusinessListBase(Of MailMergeQueueTemplateController)

End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeQueueTemplateControllerProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeQueueTemplateControllerProvider
    Private Const mProviderName As String = "MailMergeQueueTemplateControllerProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeQueueTemplateControllerProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeQueueTemplateControllerProvider)(mProviderName)
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
