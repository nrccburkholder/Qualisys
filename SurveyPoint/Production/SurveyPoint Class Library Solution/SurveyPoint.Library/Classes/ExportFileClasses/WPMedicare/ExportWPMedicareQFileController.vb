Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.Data
Imports System.IO
Imports System.Text

Public Interface IExportWPMedicareQFileControllerID
    Property ExportWPMedicareQFileControllerID() As Integer
End Interface

''' <summary>This is the primary business object for an export question file of an export group.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportWPMedicareQFileController
    Inherits BusinessBase(Of ExportWPMedicareQFileController)
    Implements IExportWPMedicareQFileControllerID

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mExportWPMedicareQFileCollection As ExportWPMedicareQFileCollection
    Private mQuestionFileExported As Boolean = False
    Private mExportGroupID As Integer
    Private mExportWPMedicareQFileControllerID As Integer
    Private mQuestionFilePath As String = String.Empty
    Private mParent As ExportWPMedicareFile
#End Region

#Region " Public Properties "

    ''' <summary>Uniquely IDs this class</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportWPMedicareQFileControllerID() As Integer Implements IExportWPMedicareQFileControllerID.ExportWPMedicareQFileControllerID
        Get
            Return Me.mExportWPMedicareQFileControllerID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportWPMedicareQFileControllerID Then
                mExportWPMedicareQFileControllerID = value
                PropertyHasChanged("ExportWPMedicareQFileControllerID")
            End If
        End Set
    End Property
    ''' <summary>Public interface to tell wheter the file has been exported.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property QuestionFileExported() As Boolean
        Get
            Return Me.mQuestionFileExported
        End Get
    End Property
    ''' <summary>The ID of the export group for whom you are exporting.</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ExportGroupID() As Integer
        Get
            Return Me.mExportGroupID
        End Get
    End Property
    Public Property QuestionFilePath() As String
        Get
            Return Me.mQuestionFilePath
        End Get
        Set(ByVal value As String)
            If Not value = Me.mQuestionFilePath Then
                value = Me.mQuestionFilePath
                PropertyHasChanged("QuestionFilePath")
            End If
        End Set
    End Property
    Public ReadOnly Property ParentExportFile() As ExportWPMedicareFile
        Get
            Return Me.mParent
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Default constructor is not allowed as you need the export ID.</summary>    
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub New(ByVal parent As ExportWPMedicareFile, ByVal exportGroupID As Integer, ByVal questionFilePath As String)
        Me.CreateNew()
        Me.mParent = parent
        Me.mExportGroupID = exportGroupID
        Me.mQuestionFilePath = questionFilePath
        LoadResultQuestionCollection()
    End Sub
    ''' <summary>Default constructor is not allowed as you need the export ID.</summary>    
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub New(ByVal parent As ExportWPMedicareFile, ByVal exportGroupID As Integer)
        Me.CreateNew()
        Me.mExportGroupID = exportGroupID
        Me.mParent = parent
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Retrieving Questions.", Nothing, "", "Question Load"))
        Me.mParent.RaiseProgressMessage(2, "Retrieving Questions", False)
        LoadResultQuestionCollection()
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Questions Loaded.", Nothing, "", "Question Load"))
        Me.mParent.RaiseProgressMessage(2, "Retrieving Questions", False)
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new question file controller</summary>
    ''' <returns>ExportResultFileController</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportWPMedicareQFileController(ByVal parent As ExportWPMedicareFile, ByVal exportGroupID As Integer) As ExportWPMedicareQFileController
        Dim qController As ExportWPMedicareQFileController = New ExportWPMedicareQFileController(parent, exportGroupID)
        Return qController
    End Function
    ''' <summary>Factory to create a new question file controller</summary>
    ''' <returns>ExportResultFileController</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportWPMedicareQFileController(ByVal parent As ExportWPMedicareFile, ByVal exportGroupID As Integer, ByVal questionFilePath As String) As ExportWPMedicareQFileController
        Dim qController As ExportWPMedicareQFileController = New ExportWPMedicareQFileController(parent, exportGroupID, questionFilePath)
        Return qController
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Set-gets the key identifier for the business object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return Me.mExportWPMedicareQFileControllerID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wires validation rules to the properties of the business object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...

    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        'ValidationRules.CheckRules()        
    End Sub

    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Question File Controller does not support saving.")
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>This method iterates through the question file collection to print the question file.</summary>    
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term>Tony Piccoli 20080818</term><description>Changed wellpoint to print a separate trailer file.</description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintFile() As Integer
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Printing Question File.", Nothing, "", "Question File Generation"))
        Me.mParent.RaiseProgressMessage(5, "Printing Question File", False)
        Me.mQuestionFileExported = False
        Dim tw As StreamWriter = Nothing
        Dim trailerTW As StreamWriter = Nothing
        Try
            tw = New StreamWriter(Me.mQuestionFilePath, False, System.Text.Encoding.ASCII)
            'tw.FormatProvider
            Dim sbTrailer As StringBuilder = New StringBuilder(1300)
            Dim blnFlag As Boolean = False            
            For Each row As ExportWPMedicareQFile In Me.mExportWPMedicareQFileCollection
                If Not blnFlag Then
                    tw.WriteLine(row.PrintHeadlerLine)
                    sbTrailer.AppendLine(row.PrintTrailerFileHeader)
                End If
                tw.WriteLine(row.PrintLine().ToString)
                If Not blnFlag Then
                    'Record count is always set manually.
                    row.TotalRecordCount = Me.mExportWPMedicareQFileCollection.Count
                    sbTrailer.Append(row.PrintTrailerLine())
                    blnFlag = True
                End If
            Next
            Dim trailerFN As String = Me.mQuestionFilePath
            trailerFN = trailerFN.Substring(0, trailerFN.LastIndexOf("."c)) & "Trailer" & trailerFN.Substring(trailerFN.LastIndexOf("."c))
            trailerTW = New StreamWriter(trailerFN, False, System.Text.Encoding.ASCII)            
            trailerTW.WriteLine(sbTrailer.ToString())

            Me.mQuestionFileExported = True
            'Notify events
            Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Question File Printed.", Nothing, "", "Question File Generation"))
            Me.mParent.RaiseProgressMessage(15, "Question File Printed", False)
            Return Me.mExportWPMedicareQFileCollection.Count
        Catch ex As Exception
            'Notify events
            Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, "Question File Error.", Nothing, ex.StackTrace, "Question File Generation"))
            Me.mParent.RaiseProgressMessage(100, "Question File Error", False)
            Me.mQuestionFileExported = False
            Throw ex
        Finally
            If Not tw Is Nothing Then
                tw.Close()
            End If
            If Not trailerTW Is Nothing Then
                trailerTW.Close()
            End If
        End Try
    End Function
#End Region

#Region " Private and Protected Methods "
    Protected Sub LoadResultQuestionCollection()
        Me.mExportWPMedicareQFileCollection = ExportWPMedicareQFileProvider.Instance.CreateQuestionFileCollection(Me, Me.mExportGroupID)
    End Sub
#End Region

End Class
