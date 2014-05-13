Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports System.Windows.Forms
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Study

#Region " Private Members "

    Private mStudyID As Integer
    Private mStudyName As String
    Private mClientID As Integer
    Private mClientName As String
    Private mProjectNum As Integer

#End Region

#Region " Public Properties "

    Public Property StudyID() As Integer
        Get
            Return Me.mStudyID
        End Get
        Set(ByVal Value As Integer)
            Me.mStudyID = Value
        End Set
    End Property

    Public Property StudyName() As String
        Get
            Return Me.mStudyName
        End Get
        Set(ByVal Value As String)
            Me.mStudyName = Value
        End Set
    End Property

    Public Property ClientID() As Integer
        Get
            Return Me.mClientID
        End Get
        Set(ByVal Value As Integer)
            Me.mClientID = Value
        End Set
    End Property

    Public Property ClientName() As String
        Get
            Return Me.mClientName
        End Get
        Set(ByVal Value As String)
            Me.mClientName = Value
        End Set
    End Property

    Public Property ProjectNum() As Integer
        Get
            Return Me.mProjectNum
        End Get
        Set(ByVal Value As Integer)
            Me.mProjectNum = Value
        End Set
    End Property

#End Region

#Region " Shared Methods "

#Region " Match Field Validation "

    Public Shared Function GetMatchFields(ByVal studyID As Integer) As DataTable

        ' Data table contains: Study_id, Table_id, strTable_nm, Field_id, strField_nm, bitMatchField, bitMatchValidation.
        GetMatchFields = PackageDB.GetMatchFieldValidation(studyID)

    End Function

    Public Shared Sub SaveMatchFields(ByVal studyID As Integer, ByVal tableID As Integer, ByVal fields As String)

        Dim conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
        conn.Open()
        Dim trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)

        Try
            PackageDB.SaveMatchFieldValidation(trans, studyID, tableID, fields)
            trans.Commit()
            conn.Close()

        Catch ex As Exception
            trans.Rollback()
            conn.Close()
            Throw ex

        End Try

    End Sub

#End Region

#End Region

#Region " Constructors "

    Sub New()

    End Sub

    Sub New(ByVal clientID As Integer, ByVal clientName As String, ByVal studyID As Integer, ByVal studyName As String)

        Me.mClientID = clientID
        Me.mClientName = clientName
        Me.mStudyID = studyID
        Me.mStudyName = studyName

    End Sub

#End Region

End Class
