'Public Interface iTestPrint
'Sub GetPrints(ByRef Survey_id As Integer, ByRef Employee_id As Integer)
'End Interface

<ComClass(nrcTestPrint.ClassId, nrcTestPrint.InterfaceId, nrcTestPrint.EventsId)> _
Public Class nrcTestPrint
#Region "COM GUIDs"
    ' These  GUIDs provide the COM identity for this class 
    ' and its COM interfaces. If you change them, existing 
    ' clients will no longer be able to access the class.
    Public Const ClassId As String = "F3FAEEAC-06EE-4AA8-B750-25E159B59D55"
    Public Const InterfaceId As String = "FF6CB3C1-C420-4274-8082-7F6A21E2F00C"
    Public Const EventsId As String = "B7891B80-D83E-4B1B-9018-683C66F9D988"
#End Region

    ' A creatable COM class must have a Public Sub New() 
    ' with no parameters, otherwise, the class will not be 
    ' registered in the COM registry and cannot be created 
    ' via CreateObject.
    Public Sub New()
        MyBase.New()
    End Sub
    'Implements iTestPrint
    Public Sub GetPrints(ByRef Survey_id As Integer, ByRef Employee_id As Integer) 'Implements iTestPrint.GetPrints
        Dim strServer As String
        Dim strpw As String
        Dim struid As String
        Dim strDataBase As String
        Dim regQualiSys As Microsoft.Win32.RegistryKey
        Dim frmMain As New frmTestPrint
        frmMain.gEmployee_ID = Employee_id
        frmMain.gSurvey_ID = Survey_id

        regQualiSys = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("SOFTWARE\\QualiSys\\Connection", False)
        strServer = regQualiSys.GetValue("Server")
        strDataBase = regQualiSys.GetValue("Database")
        struid = regQualiSys.GetValue("DefaultUser")
        strpw = regQualiSys.GetValue("DefaultPWD")
        regQualiSys.Close()

        frmMain.gSurvey_ID = Survey_id

        frmMain.objConnection.ConnectionString = "server=" + strServer + ";UID=" + _
                                struid + ";PWD=" + strpw + ";DATABASE=" + strDataBase
        frmMain.objCommand.CommandTimeout = 0 'wait 15 minutes
        frmMain.objConnection.Open()
        frmMain.objCommand.Connection = frmMain.objConnection
        frmMain.objCommand.CommandText = "select Description as Description,SelCover_ID as SelCover_ID from sel_cover where PageType <> 4 and survey_id = " + CStr(Survey_id)
        frmMain.objDataAdapter.SelectCommand = frmMain.objCommand
        frmMain.objDataAdapter.Fill(frmMain.objdata, "cover")
        frmMain.objCommand.CommandText = "select Language as Language, sl.LangID as LangID from surveylanguage sl inner join languages l on sl.langid = l.langid where survey_id = " + CStr(Survey_id)
        frmMain.objDataAdapter.Fill(frmMain.objdata, "language")

        frmMain.objCommand.CommandText = "select * from Employee  where employee_id = " + CStr(Employee_id)
        frmMain.objDataAdapter.Fill(frmMain.objdata, "employee")
        If frmMain.objdata.Tables("employee").Rows.Count > 0 Then
            frmMain.txtEmail.Text = frmMain.objdata.Tables("employee").Rows(0).Item("strEmail").ToString
        End If

        frmMain.lstCover.DataSource = frmMain.objdata.Tables("cover")
        frmMain.lstCover.DisplayMember = "Description"
        frmMain.lstCover.ValueMember = "SelCover_ID"

        frmMain.lstLanguage.DataSource = frmMain.objdata.Tables("language")
        frmMain.lstLanguage.DisplayMember = "Language"
        frmMain.lstLanguage.ValueMember = "LangID"

        frmMain.ShowDialog()
    End Sub
End Class
