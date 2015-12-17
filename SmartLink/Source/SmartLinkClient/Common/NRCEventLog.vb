Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml.Serialization
Imports System.IO

Public Class NRCEventLog

#Region "Private Variables"

    Private Const C_MODULENAME As String = "NRCEventLog.vb"

    Public Event EventLogged()

    Private _strEventLogPath As String = String.Empty
    Private _mstrAppName As String = "NRCEventLogClass"
    Private _EventID As Integer = 0
    Private _DefaultFileName As String = My.Application.Info.DirectoryPath + "\Events.log"

#End Region

#Region "Public Structures"

    <Serializable()> Public Structure structEvent
        Public LogDB As String
        Public LogMsg As String
    End Structure

    <Serializable()> Public Structure structLoggedEvent
        Public ApplicationName As String
        Public EventID As Integer
        Public UserName As String
        Public EventTime As Date
        Public Message As String
    End Structure

#End Region

#Region "Public Properties"

    Public Property EventLogpath() As String
        Get
            Return _strEventLogPath
        End Get
        Set(ByVal value As String)
            _strEventLogPath = value
        End Set
    End Property

#End Region

    ' Default construct
    Public Sub New()

    End Sub

    ' This method presumes you have created the object and set the following properties
    '       LogToDb
    '       EventLogPath
    Public Sub LogToFile(ByVal strAppName As String, ByVal strMessage As String)

        Dim objdata As New DataSet
        Dim dr As DataRow = Nothing
        Dim datePattern As String = "M/d/yyyy hh:mm:ss tt"
        Dim sNewEventLogPath As String

        ' Ensure that the EventLogPath has been populated.  If not, set it to the default
        If EventLogpath.Length < 1 Then
            sNewEventLogPath = System.IO.Path.GetDirectoryName(_DefaultFileName) _
                & "\" & System.IO.Path.GetFileNameWithoutExtension(_DefaultFileName) & DateTime.Now.ToString("_yyyy-MM") _
                & System.IO.Path.GetExtension(_DefaultFileName)
        Else
            sNewEventLogPath = System.IO.Path.GetDirectoryName(EventLogpath) _
                & "\" & System.IO.Path.GetFileNameWithoutExtension(EventLogpath) & DateTime.Now.ToString("_yyyy-MM") _
                & System.IO.Path.GetExtension(EventLogpath)
        End If

        'Try to load the file up to 3 times
        For i As Integer = 1 To 3
            Try
                If Not My.Computer.FileSystem.FileExists(sNewEventLogPath) Then
                    CreateEventFile(sNewEventLogPath)
                End If
            Catch ex As Exception

            End Try
            Try
                objdata = New DataSet("EventLog")
                'objdata.ReadXmlSchema(".\Events.xsd")
                objdata.ReadXml(sNewEventLogPath)
                Exit For
            Catch ex As Exception
                If i >= 3 Then
                    Throw New Exception("NRCEventLog error reading log file: " + ex.Message)
                ElseIf System.IO.File.Exists(sNewEventLogPath) Then
                    Try
                        System.IO.File.Move(sNewEventLogPath, _
                        System.IO.Path.GetDirectoryName(sNewEventLogPath) _
                        & "\" & System.IO.Path.GetFileNameWithoutExtension(sNewEventLogPath) & DateTime.Now.ToString("_BA\K_yyyyMMddHHmmssffff") _
                        & System.IO.Path.GetExtension(sNewEventLogPath))
                    Catch ex2 As Exception

                    End Try
                End If
            End Try
        Next

        Try
            objdata.Tables(0).DefaultView.RowFilter = ""
            dr = objdata.Tables(0).NewRow()
        Catch ex As Exception
            Throw New Exception("NRCEventLog error creating new data row: " + ex.Message)
        End Try

        Dim int As Integer = objdata.Tables(0).Rows.Count - 1
        Dim _EventID As Int32 = Convert.ToInt32(objdata.Tables(0).Rows(int).Item("EventID"))

        Try
            _EventID += 1
            dr(0) = _EventID.ToString
            dr(1) = strAppName
            dr(2) = System.Security.Principal.WindowsIdentity.GetCurrent.Name
            dr(3) = Now.ToString(datePattern)
            dr(4) = strMessage

            objdata.Tables(0).Rows.Add(dr)

        Catch ex As Exception
            Throw New Exception("NRCEventLog error adding new data row: " + ex.Message)
        End Try

        Try
            objdata.WriteXml(sNewEventLogPath, XmlWriteMode.IgnoreSchema)
        Catch ex As Exception
            Throw New Exception("NRCEventLog error writing Error Log: " + ex.Message)
        End Try

        objdata = Nothing

    End Sub

#Region "Private Methods"
    Private Sub CreateEventFile(ByVal FileName As String)
        Dim objdata As DataSet
        Dim dr As DataRow
        Dim dt As DataTable

        ' Create the new Dataset
        objdata = New DataSet("EventLog")

        ' Create the Table and add the rows to it
        dt = New DataTable("Events")
        With dt
            .Columns.Add("EventID", Type.GetType("System.String"))
            .Columns.Add("ApplicationName", Type.GetType("System.String"))
            .Columns.Add("UserName", Type.GetType("System.String"))
            .Columns.Add("EventTime", Type.GetType("System.String"))
            .Columns.Add("Message", Type.GetType("System.String"))
        End With

        objdata.Tables.Add(dt)

        ' Create a new Data Row, populate it and add it to the table
        dr = dt.NewRow
        dr(0) = "1"
        dr(1) = "Tool Generated"
        dr(2) = "Internal"
        dr(3) = Now.ToShortDateString
        dr(4) = "Initial Record"
        objdata.Tables(0).Rows.Add(dr)

        ' Write out the Dataset to an XML File
        objdata.WriteXml(FileName, XmlWriteMode.WriteSchema)
        objdata = Nothing
    End Sub

#End Region

End Class
