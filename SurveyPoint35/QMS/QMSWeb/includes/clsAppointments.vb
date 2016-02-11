Option Explicit On 
Option Strict On

Public Enum tblAppointments
    AppointmentDate = 0
    AppointmentTime = 1
    RespondentID = 2
    FirstName = 3
    LastName = 4
    City = 5
    State = 6
    SurveyID = 1
    ClientID = 2
    SurveyInstanceID = 3
    SurveyName = 4
    ClientName = 5
    SurveyInstanceName = 6

End Enum

Public Class clsAppointments

    Public ConnectionString As String = ""

    Private _dsEntity As DataSet

    Private _sTableName As String

    Private _sSelectSQL As String

    Private _sErrorMsg As String = ""

    Private _iSurveyInstanceID As Integer = 0

    Private _dtAppointmentDate As DateTime

    Sub New(ByVal sConnStr As String, ByVal dtAppointmentDate As DateTime, Optional ByVal iSurveyInstanceID As Integer = 0)
        ConnectionString = sConnStr
        Me._dtAppointmentDate = dtAppointmentDate
        Me._iSurveyInstanceID = iSurveyInstanceID
        Me.InitClass()

    End Sub

    Protected Sub InitClass()

        'Define table
        Me._sTableName = "Appointments"

        'SELECT SQL
        Me._sSelectSQL = "SELECT * FROM v_Appointments "

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblAppointments) As Object
        Get
            Return Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblAppointments.AppointmentDate Then
                Me._dtAppointmentDate = CDate(Value)

            ElseIf eField = tblAppointments.SurveyInstanceID Then
                Me._iSurveyInstanceID = CInt(Value)

            End If

        End Set

    End Property

    Public Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._dtAppointmentDate = CDate(IIf(Me.Details(tblAppointments.AppointmentDate) Is DBNull.Value, 0, Me.Details(tblAppointments.AppointmentDate)))

                End If
            End If
        End Set

    End Property

    Public ReadOnly Property NamedDataSet(ByVal sName As String) As DataSet
        Get

            If sName.Length > 0 Then Me._dsEntity.DataSetName = sName

            Return Me._dsEntity

        End Get

    End Property

    Public Function VerifyNamedDataSet(ByVal ds As DataSet, ByVal sName As String) As Boolean

        If ds.DataSetName.ToUpper = sName.ToUpper Then
            'signed dataset matches signature
            Me.DataSet = ds
            Return True

        End If

        Return False

    End Function

    Public ReadOnly Property ErrorMsgs() As String
        Get
            Return Me._sErrorMsg
        End Get

    End Property

    Public Sub Clear()
        Me._dtAppointmentDate = Now()
        Me._iSurveyInstanceID = 0

    End Sub

    Public Function GetDetails() As DataSet
        Dim sSQL As String

        sSQL = Me.GetSearchSQL()

        If Not IsNothing(Me._dsEntity) Then
            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                Me._dsEntity.Tables.Remove(Me._sTableName)

            End If

        End If

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
            Return Me._dsEntity

        End If

    End Function

    Protected Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()

        'build criteria
        sWHERESQL.AppendFormat("WHERE AppointmentDate = '{0:d}' AND ", Me._dtAppointmentDate)

        If Me._iSurveyInstanceID > -1 Then
            sWHERESQL.AppendFormat("SurveyInstanceID = {0} AND ", Me._iSurveyInstanceID)

        End If

        'remove last AND
        sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        Return String.Format("{0} {1}", Me._sSelectSQL, sWHERESQL.ToString)

    End Function

End Class
