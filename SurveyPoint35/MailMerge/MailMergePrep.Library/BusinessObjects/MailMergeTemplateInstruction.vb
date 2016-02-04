Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO

#Region " Key Interface "
Public Interface IMailMergeTemplateInstruction
    Property MailMergeTemplateInstructionID() As Integer
End Interface
#End Region
#Region " MailMergeTemplateInstruction Class "
Public Class MailMergeTemplateInstruction
    Inherits BusinessBase(Of MailMergeTemplateInstruction)
    Implements IMailMergeTemplateInstruction

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeTemplateInstructionID As Integer
    Private mInstructions As String = String.Empty
    Private mSpecialInstructions As String = String.Empty

#End Region

#Region " Properties "
    Public Property MailMergeTemplateInstructionID() As Integer Implements IMailMergeTemplateInstruction.MailMergeTemplateInstructionID
        Get
            Return Me.mMailMergeTemplateInstructionID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeTemplateInstructionID = value
        End Set
    End Property
    Public Property Instructions() As String
        Get
            Return Me.mInstructions
        End Get
        Set(ByVal value As String)
            If Not (Me.mInstructions = value) Then
                Me.mInstructions = value
                PropertyHasChanged("Instructions")
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
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeTemplateInstruction() As MailMergeTemplateInstruction
        Return New MailMergeTemplateInstruction
    End Function
    Public Shared Function GetMailMergeTemplateInstruction(ByVal templateID As Integer) As MailMergeTemplateInstruction
        Return MailMergeTemplateInstructionProvider.Instance.GetMailMergeTemplateInstruction(templateID)
    End Function
    Public Shared Sub SetMailMeregeTemplateInstruction(ByVal templateID As Integer, ByVal instruction As String, ByVal specialInstruction As String)
        MailMergeTemplateInstructionProvider.Instance.SetMailMeregeTemplateInstruction(templateID, instruction, specialInstruction)
    End Sub
    Public Shared Function GetTemplateIDFromDirectory(ByVal path As String) As Integer
        Dim retVal As Integer = 0
        If path.Length > 0 AndAlso Directory.Exists(path) Then
            Dim pattern As String = "MM_?????_??_?_??_??_???_??.doc"
            Dim files() As String = Directory.GetFiles(path, pattern)
            For Each strFile As String In files
                Dim fi As New FileInfo(strFile)
                Dim tempString = fi.Name.Substring(3, 5)
                If IsNumeric(tempString) Then
                    retVal = CInt(tempString)
                    Exit For
                End If
            Next
        End If
        Return retVal
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
#End Region

#Region " Execution Methods "

#End Region

#Region " Helper Methods "

#End Region
End Class
#End Region


#Region " MailMergeTemplateInstructions Collection Class "
Public Class MailMergeTemplateInstructions
    Inherits BusinessListBase(Of MailMergeTemplateInstruction)    
End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeTemplateInstructionProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeTemplateInstructionProvider
    Private Const mProviderName As String = "MailMergeTemplateInstructionProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeTemplateInstructionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeTemplateInstructionProvider)(mProviderName)
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
    Public MustOverride Function GetMailMergeTemplateInstruction(ByVal templateID As Integer) As MailMergeTemplateInstruction
    Public MustOverride Sub SetMailMeregeTemplateInstruction(ByVal templateID As Integer, ByVal instruction As String, ByVal specialInstruction As String)
#End Region
End Class
#End Region
