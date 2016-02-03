Option Strict Off
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Text
Imports System.Xml
Imports System.ComponentModel

Public Class ExportFileSection
    Inherits Section

#Region "Private Members"

    Private mSubSection As Section
    Private mMode As ExportConfigurationButtonEnum
    Private mValidDate As Boolean = True
    Private mConnection As SqlConnection


    Private Delegate Function GetCheckListItems(lst As ListView) As ListView.CheckedListViewItemCollection
    Private Delegate Sub SetTextCallback([text] As String, nextline As Boolean)

    Dim ClientList As New StringBuilder
    Dim Runs As ArrayList
#End Region

    Private Sub BtnExport_Click(sender As System.Object, e As System.EventArgs) Handles BtnExport.Click
        'TODO List
        '0. if the date is valid proceed
        '1. run method to get the template
        '2. run SP with the fields necessary to run the extract
        '2.1 Check if one of those field were changed before. Check eventID. Justin is going to provide those eventIDs.
        '3. Generates the file
        ' 
        'GetSelectedClients()

        Try
            If mValidDate AndAlso LstViewClients.CheckedItems.Count > 0 Then
                Dim CreateFile As DialogResult = MessageBox.Show("This process might take several minutes, are  you sure?", _
                       "Export File", _
                       MessageBoxButtons.YesNo)
                ' Dim t As New Threading.Thread(AddressOf GenerateFile)
                If CreateFile = DialogResult.Yes Then

                    '   TxtLog.Text = "Start process.." & vbCrLf
                    Threading.Thread.Sleep(3000)
                    GenerateFile()
                    '  t.Start()
                    GetLatestRuns()
                    MessageBox.Show("Process has finished", "Export File", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    ' TxtLog.Text = TxtLog.Text & "Process has finished."
                End If
            End If


        Catch ex As Exception
            MessageBox.Show(ex.Message, "Export File", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        '4 Save in the eventlog? the new event for the run?
        '5. Load the dates were run before in the combobox. If you want to regenerate the file again.

    End Sub

    Private Sub ExportFileSection_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'get the Clients
        Try
            GetConfigurations()
            GetClients()
            GetLatestRuns()
        Catch ex1 As SqlException
            MessageBox.Show(ex1.Message, "Export File", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Export File", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub
    Private Sub GetConfigurations()
        '	select * from fixedwidthexportconfigurations
        Using mConnection As New SqlConnection() With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
            mConnection.Open()
            Using DsConfigurations As New DataSet()
                'Load the clients
                Dim getConfigurationsCommand As New SqlCommand() With {.CommandType = CommandType.Text, .CommandText = "select * from fixedwidthexportconfigurations", .Connection = mConnection}
                Dim DAConfigurations As New SqlDataAdapter(getConfigurationsCommand)
                DAConfigurations.Fill(DsConfigurations)
                getConfigurationsCommand.Dispose()
                CmbConfiguration.DataSource = DsConfigurations.Tables(0)
                CmbConfiguration.ValueMember = "FixedWidthConfigurationID"
                CmbConfiguration.DisplayMember = "ConfigurationName"
            End Using
        End Using
    End Sub
    Private Sub CmbDate_SelectedIndexChanged(sender As System.Object, e As System.EventArgs) Handles CmbDate.SelectedIndexChanged
        Dim chosenDate As DateTime
        Dim DateString As String = CType(CmbDate, ComboBox).Text
        If (DateTime.TryParse(DateString, chosenDate)) AndAlso CmbDate.Text <> String.Empty Then
            CmbDate.Enabled = False
            Using mConnection As New SqlConnection() With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
                mConnection.Open()

                'Load the clients
                Using getClientsCommand As New SqlCommand() _
                    With {.CommandType = CommandType.Text, _
                          .CommandText = String.Format("select * from FixedWidthExportLatestRun where CONVERT(VARCHAR(19),[timestamp], 121)='{0}'", _
                                                      CType(CType(CType(CmbDate.DataSource, ArrayList)(CmbDate.SelectedIndex), AddValue).Display, Date).ToString("yyyy-MM-dd HH:mm:ss")), .Connection = mConnection}
                    Dim GetClients As SqlDataReader = getClientsCommand.ExecuteReader()
                    If GetClients.Read Then
                        Dim clients As String() = GetClients.GetString(2).ToString.Split(",")
                        For Each lstview As ListViewItem In LstViewClients.Items
                            For Each s As String In clients
                                If lstview.Tag = s Then
                                    lstview.Checked = True
                                End If
                            Next
                        Next
                    End If
                End Using



            End Using
        End If
    End Sub

    Private Sub CmbDate_Validating(sender As Object, e As System.ComponentModel.CancelEventArgs) Handles CmbDate.Validating
        Dim chosenDate As DateTime
        Dim DateString As String = CType(CmbDate, ComboBox).Text
        If Not (DateTime.TryParse(DateString, chosenDate)) AndAlso CmbDate.Text <> String.Empty Then
            MessageBox.Show("Entry a valid date", "Export File", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            mValidDate = False
        Else
            mValidDate = True
        End If
    End Sub
    ''' <summary>
    '''  GetClients
    ''' This method Get the clients of the active SurveyInstances
    ''' Goal: We need to collect all the clients that we need to send as parameter to the Stored Procedure called GetValuesForFixedWidthFile
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub GetClients()

        Using mConnection As New SqlConnection() With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
            mConnection.Open()
            'Load the clients
            Dim GetClientsCommand As New SqlCommand() _
            With {.CommandType = CommandType.StoredProcedure, .CommandText = "GetClientsOfActiveSurveyInstances", .Connection = mConnection}
            Dim GetClients As SqlDataReader = GetClientsCommand.ExecuteReader()
            While GetClients.Read
                Dim ListItem As New ListViewItem
                ListItem.Text = GetClients.GetString(1).Trim
                ListItem.Tag = GetClients.GetInt32(0)
                LstViewClients.Items.Add(ListItem)

            End While
            GetClientsCommand.Dispose()
        End Using
    End Sub

    Private Sub GenerateFile()
        Dim RecordCount As Integer = 0
        Dim saveFileDialog1 As New SaveFileDialog()
        Using mConnection As New SqlConnection With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}         
            mConnection.Open()
            Using GetValuesForFixedFile As New SqlCommand() With {.Connection = mConnection, .CommandText = "GetValuesForFixedWidthFile", .CommandType = CommandType.StoredProcedure}
                Dim ClientListParam As New SqlParameter() With {.ParameterName = "ClientList", .Value = GetSelectedClients()}
                Dim ConfigurationIDParam As New SqlParameter() With {.ParameterName = "fixedwidthconfigurationid", .Value = 1}
                Dim DateParam As New SqlParameter() With {.ParameterName = "Date"}
                If CmbDate.Text <> String.Empty Then
                    DateParam.Value = CType(CmbDate.Text, DateTime).ToString("yyyy-MM-dd HH:mm:ss")
                Else
                    DateParam.Value = DBNull.Value
                End If
                GetValuesForFixedFile.Parameters.Add(ClientListParam)
                GetValuesForFixedFile.Parameters.Add(ConfigurationIDParam)
                GetValuesForFixedFile.Parameters.Add(DateParam)
                GetValuesForFixedFile.CommandTimeout = 0
                Dim GetValuesForFileReader As SqlDataReader '= GetValuesForFixedFile.ExecuteReader
                Dim Filename As String = String.Format("contactiv_nrc_{0}.dat", String.Format("{0,8:yyyyMMdd}", Now))
                saveFileDialog1.Filter = "dat files (*.dat)All files (*.*)|*.*"
                saveFileDialog1.FilterIndex = 2
                saveFileDialog1.RestoreDirectory = True
                ' saveFileDialog1.FileName = Filename
                If saveFileDialog1.ShowDialog = DialogResult.OK Then
                    Using sw As StreamWriter = New StreamWriter(saveFileDialog1.FileName)
                        GetValuesForFileReader = GetValuesForFixedFile.ExecuteReader
                        While GetValuesForFileReader.Read
                            'I know.. doing this open two connections. But is that way or use a dataset and fill it. Still readers are faster. Good thing they are using USING statements
                            Using mConnection2 As New SqlConnection() With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
                                mConnection2.Open()
                                Using GetColumnsCommand As New SqlCommand() With {.Connection = mConnection2, .CommandText = "GetFixedWidthConfiguration", .CommandType = CommandType.StoredProcedure}
                                    Dim GetColumnParam As New SqlParameter() With {.ParameterName = "FixedWithConfigurationID", .Value = 1}
                                    GetColumnsCommand.Parameters.Add(GetColumnParam)
                                    Dim GetColumnsReader As SqlDataReader = GetColumnsCommand.ExecuteReader
                                    While GetColumnsReader.Read
                                        'TODO: Match the file name columns with the columns in the configuration. DONE.
                                        'TODO: add a column for format in the table.
                                        sw.Write(GetColumnsReader("ColumnFormat").ToString, GetValuesForFileReader(GetColumnsReader("ColumnName").ToString.Trim))
                                        'sw.Write(" ")
                                    End While
                                End Using
                                RecordCount = RecordCount + 1
                                sw.WriteLine()
                            End Using
                        End While
                        'Trailer Record
                        Dim format As String = "{0,-3}{1,-10}{2,-10}{3,-8:yyyyMMdd}{4,10:0000000000}"
                        sw.Write(format, "ZZZ", "NRC", "CONTACTIV", Now, RecordCount)
                    End Using
                End If

            End Using

        End Using
        If RecordCount > 0 AndAlso CmbDate.Text = String.Empty Then
            AddLatestRun()
        End If
        ' Me.SetText("Process has finished.", True)

    End Sub

    Private Function GetSelectedClients() As String
        'lst variable was used in an independent thread. No time to play with this right now.
        ' Dim lst As ListView.CheckedListViewItemCollection = getListViewItems(LstViewClients)
        ClientList.Length = 0
        For Each item As ListViewItem In LstViewClients.CheckedItems 'lst
            ClientList.Append(item.Tag.ToString & ",")
        Next
        If ClientList.Length > 0 Then
            ClientList.Remove(ClientList.ToString.Length - 1, 1)
        End If

        Return ClientList.ToString
    End Function
    ''' <summary>
    '''  No used now, but we can used in an independet thread
    ''' </summary>
    ''' <param name="lstview"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function getListViewItems(lstview As ListView) As ListView.CheckedListViewItemCollection
        Dim temp As New ListView
        temp.CheckBoxes = True
        If Not lstview.InvokeRequired Then
            For Each item As ListViewItem In lstview.Items
                temp.Items.Add(DirectCast(item.Clone(), ListViewItem))
            Next
            Return CType(temp.CheckedItems, ListView.CheckedListViewItemCollection)
        Else
            Return DirectCast(Me.Invoke(New GetCheckListItems(AddressOf getListViewItems), New Object() {lstview}), ListView.CheckedListViewItemCollection)
        End If
    End Function
    'Private Sub SetText(ByVal [text] As String, nextline As Boolean)

    '    ' InvokeRequired required compares the thread ID of the
    '    ' calling thread to the thread ID of the creating thread.
    '    ' If these threads are different, it returns true.
    '    If Me.TxtLog.InvokeRequired Then
    '        Dim d As New SetTextCallback(AddressOf SetText)
    '        Me.Invoke(d, New Object() {[text], nextline})
    '    Else

    '        If nextline Then
    '            Me.TxtLog.Text = TxtLog.Text & [text] & vbCrLf
    '        Else
    '            Me.TxtLog.Text = [text]
    '        End If
    '    End If
    'End Sub
    Private Sub AddLatestRun()
        Using mConnection As New SqlConnection With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
            mConnection.Open()
            Using AddLatestRun As New SqlCommand() With {.Connection = mConnection, .CommandText = "AddLatestRun", .CommandType = CommandType.StoredProcedure}
                Dim params As SqlParameter() = {New SqlParameter("@FixedWidthConfigurationID", 1), New SqlParameter("@ClientListIDs", ClientList.ToString)}
                AddLatestRun.Parameters.AddRange(params)
                AddLatestRun.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub GetLatestRuns()
        'CmbDate.Items.Clear()
        Dim SelectedIndex As Integer = 0
        If CmbDate.Text <> String.Empty Then
            SelectedIndex = CmbDate.SelectedIndex
        End If
        Runs = New ArrayList
        Using mConnection As New SqlConnection() With {.ConnectionString = ConfigurationManager.AppSettings("QMSConnection")}
            mConnection.Open()
            Using GetLatestRun As New SqlCommand() With {.Connection = mConnection, .CommandText = "GetLatestRun", .CommandType = CommandType.StoredProcedure}
                Dim GetRuns As SqlDataReader = GetLatestRun.ExecuteReader
                Runs.Add(New AddValue("", 0, ""))
                While GetRuns.Read
                    Runs.Add(New AddValue(CStr(GetRuns("TimeStamp")), CLng(GetRuns("ID")), CStr("ClientListIDs")))
                End While
            End Using
        End Using
        If Runs.Count > 0 Then
            CmbDate.DataSource = Runs
            CmbDate.DisplayMember = "Display"
            CmbDate.ValueMember = "Values"
        End If

        Me.Refresh()
        If SelectedIndex <> 0 Then
            CmbDate.SelectedIndex = SelectedIndex
        End If
    End Sub

    Private Sub BtnClear_Click(sender As System.Object, e As System.EventArgs) Handles BtnClear.Click
        CmbDate.Enabled = True
        CmbDate.SelectedIndex = 0
        For Each lstview As ListViewItem In LstViewClients.Items
            lstview.Checked = False
        Next

    End Sub
End Class
Public Class AddValue
    Private m_display As String
    Private m_values As Long
    Private m_clients As String

    Sub New(Display As String, value As Long, clients As String)
        m_display = Display
        m_values = value
        m_clients = clients
    End Sub
    Public Property Display As String
        Get
            Return m_display
        End Get
        Set(value As String)
            m_display = value
        End Set
    End Property
    Public Property Values As Integer
        Get
            Return m_values
        End Get
        Set(value As Integer)
            m_values = value
        End Set
    End Property
End Class
