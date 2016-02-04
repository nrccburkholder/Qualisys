Imports Nrc.Framework.BusinessLogic
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports System

Public Interface IRespondentImportValidator
    Property ImportValidatorID() As Integer
End Interface

<Serializable()> _
Public Class SPETL_RespondentImportValidator
    Inherits BusinessBase(Of SPETL_RespondentImportValidator)
    Implements IRespondentImportValidator

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mImportValidatorID As Integer
    Private mLine As String
    Private mTemplateID As Integer = 0
    Private mSurveyID As Integer = 0
    Private mSurveyInstanceID As Integer = 0
    Private mClientID As Integer = 0
    Private mRespondentID As Integer = 0
    Private mFileDefID As Integer = 0
    Private mScriptID As Integer = 0
    Private mBaseInformationSet As System.Data.DataTable = Nothing
    Private mFileDefTable As System.Data.DataTable = Nothing
    Private mRespondentData As System.Data.DataTable = Nothing
    Private mRespondentProperties As System.Data.DataTable = Nothing
    Private mRespondentEventLog As System.Data.DataTable = Nothing
#End Region

#Region " Public Properties "
    Public Property ImportValidatorID() As Integer Implements IRespondentImportValidator.ImportValidatorID
        Get
            Return Me.mImportValidatorID
        End Get
        Set(ByVal value As Integer)
            Me.mImportValidatorID = value
        End Set
    End Property
    Public Property TemplateID() As Integer
        Get
            Return Me.mTemplateID
        End Get
        Set(ByVal value As Integer)
            Me.mTemplateID = value
        End Set
    End Property
    Public Property SurveyID() As Integer
        Get
            Return Me.mSurveyID
        End Get
        Set(ByVal value As Integer)
            Me.mSurveyID = value
        End Set
    End Property
    Public Property SurveyInstanceID() As Integer
        Get
            Return Me.mSurveyInstanceID
        End Get
        Set(ByVal value As Integer)
            Me.mSurveyInstanceID = value
        End Set
    End Property
    Public Property ClientID() As Integer
        Get
            Return Me.mClientID
        End Get
        Set(ByVal value As Integer)
            Me.mClientID = value
        End Set
    End Property
    Public Property RespondentID() As Integer
        Get
            Return Me.mRespondentID
        End Get
        Set(ByVal value As Integer)
            Me.mRespondentID = value
        End Set
    End Property
    Public Property FileDefID() As Integer
        Get
            Return Me.mFileDefID
        End Get
        Set(ByVal value As Integer)
            Me.mFileDefID = value
        End Set
    End Property
    Public Property ScriptID() As Integer
        Get
            Return Me.mScriptID
        End Get
        Set(ByVal value As Integer)
            Me.mScriptID = value
        End Set
    End Property
    Public ReadOnly Property BaseInformationSet() As Data.DataTable
        Get
            Return Me.mBaseInformationSet
        End Get
    End Property
    Public ReadOnly Property FileDefTable() As Data.DataTable
        Get
            Return Me.mFileDefTable
        End Get
    End Property
    Public ReadOnly Property RespondentData() As Data.DataTable
        Get
            Return Me.mRespondentData
        End Get
    End Property
    Public ReadOnly Property RespondentProperties() As Data.DataTable
        Get
            Return Me.mRespondentProperties
        End Get
    End Property
    Public ReadOnly Property RespondentEventLog() As Data.DataTable
        Get
            Return Me.mRespondentEventLog
        End Get
    End Property

#End Region

#Region " Constructors "
    ''' <summary>Default used by DAL</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal line As String)
        Me.mLine = line
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewImportValidator(ByVal line As String) As SPETL_RespondentImportValidator
        Return New SPETL_RespondentImportValidator(line)
    End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mImportValidatorID
        End If
    End Function
#End Region

#Region " Validation "

#End Region

#Region " Data Access "

#End Region

#Region " Public Methods "
    Private Function GetTemplateIDFromLine(ByVal strLine As String) As Integer
        Dim retVal As Integer = 0
        Dim rx As New Regex("^.{18}([\d\s]{5})")
        'TODO:  Document what this regex does.
        If rx.IsMatch(strLine) Then
            Dim m As Match = rx.Match(strLine)
            retVal = CInt(m.Groups(1).Value)
        End If
        Return retVal
    End Function
    Public Sub SetData()                
        GetTemplateInfo()
        SetFileDef()
        GetRespondentID()
        GetBaseDataTable()
        GetRespondentData()
        GetRespondentProperties()
        GetEventLog()
        SetFileDefLineItems()
    End Sub
    Private Sub GetTemplateInfo()
        Try
            Me.mTemplateID = GetTemplateIDFromLine(Me.mLine)
            DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetTemplateInfo(Me)
            If Me.mTemplateID = 0 OrElse Me.mClientID = 0 OrElse Me.mScriptID = 0 OrElse Me.FileDefID = 0 Then
                Throw New System.Exception("Error")
            End If
        Catch ex As System.Exception
            Throw New System.Exception("Something is wrong with the Template Information (Template, Client, Script, or File Def IDs")
        End Try
    End Sub
    Private Sub SetFileDef()
        Try
            Me.mFileDefTable = DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetFileDefTable(Me.mFileDefID)
        Catch ex As System.Exception
            Throw New System.Exception("An error occurred while setting the file definition.")
        End Try
    End Sub
    Private Sub GetRespondentID()
        Try
            Dim startIndex As Integer = 0
            Dim width As Integer = 0
            For i As Integer = 0 To Me.mFileDefTable.Rows.Count - 1
                Dim myRow As Data.DataRow = Me.mFileDefTable.Rows(i)
                If InStr(UCase(CStr(myRow("ColumnName"))), "RESPONDENTID") > 0 Then
                    width = CInt(myRow("Width"))
                    Exit For
                Else
                    startIndex += CInt(myRow("Width"))
                End If
            Next
            Me.mRespondentID = CInt(Me.mLine.Substring((startIndex), width))
        Catch ex As System.Exception
            Throw New System.Exception("Was not able to retrieve the respondent ID from the file.")
        End Try
    End Sub
    Private Sub GetBaseDataTable()
        Try
            Me.mBaseInformationSet = DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetRespondentBaseInformation(Me.mFileDefID, Me.mScriptID, Me.mTemplateID, Me.mRespondentID)
        Catch ex As System.Exception
            Throw New System.Exception("An error occured retrieving the base data from the database.")
        End Try
    End Sub
    Private Sub GetRespondentData()
        Try
            Me.mRespondentData = DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetRespondentData(Me.mRespondentID)
        Catch ex As System.Exception
            Throw New System.Exception("An error occurred trying to retrieve respondent data from the database.")
        End Try
    End Sub
    Private Sub GetRespondentProperties()
        Try
            Me.mRespondentProperties = DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetRespondentProperties(Me.mRespondentID)
        Catch ex As System.Exception
            Throw New System.Exception("An error occurred trying to retrieve Respondent Properties from the database.")
        End Try
    End Sub
    Private Sub GetEventLog()
        Try
            Me.mRespondentEventLog = DataProviders.SPETL_RespondentImportValidatorProvider.Instance.GetRespondentEventLog(Me.mRespondentID)
        Catch ex As System.Exception
            Throw New System.Exception("An Error occured trying to retrieve respondent event log information from the database.")
        End Try
    End Sub
    Private Sub SetFileDefLineItems()
        Dim startIndex As Integer = 0
        Dim width As Integer = 0
        Try
            For i As Integer = 0 To Me.mFileDefTable.Rows.Count - 1
                Dim myrow As Data.DataRow = Me.mFileDefTable.Rows(i)
                width = CInt(myrow("Width"))
                myrow("FileValue") = Me.mLine.Substring(startIndex, width)
                startIndex += width
            Next
        Catch ex As System.Exception
            Throw New System.Exception("An error occurred while attempting to load the file def file values.")
        End Try
    End Sub
#End Region

End Class
