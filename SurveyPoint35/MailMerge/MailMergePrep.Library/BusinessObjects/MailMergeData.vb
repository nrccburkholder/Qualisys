Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO
Imports System.Text

#Region " Key Interface "
Public Interface IMailMergeData
    Property MailMergeDataID() As Integer
End Interface
#End Region
#Region " MailMergeData Class "
Public Class MailMergeData
    Inherits BusinessBase(Of MailMergeData)
    Implements IMailMergeData

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeDataID As Integer
    Private mLoaded As Boolean = False
    Private mValidated As Boolean = False
    Private mHasDataError As Boolean = False
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations
    Private mSurveyDataFile As String = String.Empty
    Private mSurveyDataBaseTable As New DataTable("SurveyDataBase")
    Private mSurveyDataColumns As New List(Of String)
    Private mMMDataColumns As MailMergeDataColumns = Nothing
    Private mTemplateID As Integer
    Private mProjectID As Integer
    Private mFaqssID As String = String.Empty
    Private mNumberOfMailings As Integer
    Private mMergeName As String = String.Empty
    Private Const TEMPLATECOLNAME As String = "Property_TEMPLATEID"
    Private Const PROJECTCOLNAME As String = "Property_PROJECTID"
    Private Const NUMOFMAILINGSCOLNAME As String = "NUMBEROFMAILINGS"
    Private Const FAQSSIDCOLNAME As String = "Property_FAQSS_TEMPLATE_ID"
    Private Const CLASSNAME As String = "MailMergeData"
#End Region

#Region " Properties "
    Public Property MailMergeDataID() As Integer Implements IMailMergeData.MailMergeDataID
        Get
            Return Me.mMailMergeDataID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeDataID = value
        End Set
    End Property
    Public Property SurveyDataFile() As String
        Get
            Return Me.mSurveyDataFile
        End Get
        Set(ByVal value As String)
            If Not (Me.mSurveyDataFile = value) Then
                Me.mSurveyDataFile = value
                ReSet()
                PropertyHasChanged("SurveyDataFile")
            End If
        End Set
    End Property
    Public Property MergeName() As String
        Get
            Return Me.mMergeName
        End Get
        Set(ByVal value As String)
            If Not (Me.mMergeName = value) Then
                Me.mMergeName = value
                ReSet()
                PropertyHasChanged("MergeName")
            End If
        End Set
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
    Public ReadOnly Property HasDataError() As Boolean
        Get
            Return Me.mHasDataError
        End Get
    End Property
    Public ReadOnly Property MMDataColumns() As MailMergeDataColumns
        Get
            If Me.mMMDataColumns Is Nothing Then
                Me.mMMDataColumns = MailMergeDataColumn.GetMailMergeDataColumns()
            End If
            Return Me.mMMDataColumns
        End Get
    End Property
    Public ReadOnly Property NumberOfMailings() As Integer
        Get
            Return Me.mNumberOfMailings
        End Get
    End Property
    Public ReadOnly Property TemplateID() As Integer
        Get
            Return Me.mTemplateID
        End Get
    End Property
    Public ReadOnly Property ProjectID() As Integer
        Get
            Return Me.mProjectID
        End Get
    End Property
    Public ReadOnly Property ValidationMessages() As Validation.ObjectValidations
        Get
            Return Me.mValidationMessages
        End Get
    End Property
    Public ReadOnly Property SurveyDataBaseTable() As DataTable
        Get
            Return Me.mSurveyDataBaseTable
        End Get
    End Property
    Public ReadOnly Property TotalRecordCount() As Integer
        Get
            Dim x As Integer = 0
            If Me.mSurveyDataBaseTable IsNot Nothing Then
                x = Me.mSurveyDataBaseTable.Rows.Count
            End If
            Return x
        End Get
    End Property
    Public ReadOnly Property FaqssID() As String
        Get
            Return Me.mFaqssID
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
    Public Sub New(ByVal surveyDataFile As String, ByVal mergeName As String)
        Me.mSurveyDataFile = surveyDataFile
        Me.mMergeName = mergeName
    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeData() As MailMergeData
        Return New MailMergeData
    End Function
    Public Shared Function NewMailMergeData(ByVal surveyDataFile As String, ByVal mergeName As String) As MailMergeData
        Return New MailMergeData(surveyDataFile, mergeName)
    End Function
    Public Shared Sub SaveDataTableToCSV(ByVal dt As DataTable, ByVal filePath As String)
        Dim sr As StreamWriter = Nothing
        Try
            dt.Columns.Remove("ISVALID")
            sr = New StreamWriter(filePath)
            sr.Write(CommonMethods.DataFileToCSV(dt))
        Catch ex As Exception
            Throw ex
        Finally
            If sr IsNot Nothing Then
                sr.Close()
            End If
        End Try
    End Sub
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
    ''' <summary>
    ''' The Validate method ensures that the data file is clean, header names are
    ''' as expected by the service, and that programatic data needed by the service
    ''' is/are added to the data file.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Validate() As Validation.ObjectValidations
        If Me.mLoaded Then
            TransformColumnNames()
            AddNonSTColumns()
            PopulateSequenceAndDefaults()
            ValidateSTData()
            If Not Me.mValidationMessages.ErrorsExist Then
                AddBarcodesAndCheckSums()
            End If
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Validate", _
                            "", "Mail Merge Data Object must be loaded prior to validation."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidated = True
        End If
        Return Me.mValidationMessages
    End Function
#End Region

#Region " Execution Methods "
#Region " Load Methods "
    ''' <summary>
    ''' This method loads the data from a text file and sets properties required prior to validation.
    ''' This object must first be loaded, then validated.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Load() As Validation.ObjectValidations
        If Me.Loaded Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Warning, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "Object has already by Loaded."))
        Else

            If Me.SurveyDataFile.Length > 0 AndAlso System.IO.File.Exists(Me.SurveyDataFile) Then
                LoadSurveyDataColumns()
                LoadSurveyDataTable()
                SetTemplateAndNumMailings()
            Else
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "An invalid data file was given to the MailMergeData Class."))
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mLoaded = True
            End If
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "The Mail Merge Data Loaded Successfully."))
        End If
        Return Me.mValidationMessages
    End Function
    Public Function Load(ByVal dt As DataTable) As Validation.ObjectValidations
        If Me.Loaded Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Warning, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "Object has already by Loaded."))
        Else
            'Base file should still exist even though you're using a DT ILO of file.
            If Me.SurveyDataFile.Length > 0 AndAlso System.IO.File.Exists(Me.SurveyDataFile) Then
                LoadSurveyDataColumns(dt)
                LoadSurveyDataTable(dt)
                SetTemplateAndNumMailings()
            Else
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "An invalid data file was given to the MailMergeData Class."))
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mLoaded = True
            End If
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "Load", "", "The Mail Merge Data Loaded Successfully."))
        End If
        Return Me.mValidationMessages
    End Function
    Private Sub LoadSurveyDataColumns()
        Dim fs As System.IO.StreamReader = Nothing
        Try
            Dim line As String = String.Empty
            fs = New System.IO.StreamReader(Me.SurveyDataFile)
            For i As Integer = 0 To 0
                If fs.Peek <> -1 Then
                    line = fs.ReadLine
                End If
            Next
            Dim cols() As String = line.Split(","c)
            For Each col As String In cols
                Me.mSurveyDataColumns.Add(CleanCSVHeaderName(col))
            Next
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "LoadSurveyDataColumns", "", "Survey Columns were successfully loaded from data file."))
        Catch ex As Exception
            Throw ex
        Finally
            If fs IsNot Nothing Then
                fs.Close()
            End If
        End Try
    End Sub
    Private Sub LoadSurveyDataColumns(ByVal dt As DataTable)
        If dt.Columns.Contains("ISVALID") Then
            dt.Columns.Remove("ISVALID")
        End If
        For Each col As DataColumn In dt.Columns
            Me.mSurveyDataColumns.Add(CleanCSVHeaderName(col.ColumnName))
        Next
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "LoadSurveyDataColumns", "", "Survey Columns were successfully loaded from data table."))
    End Sub
    Private Sub LoadSurveyDataTable(ByVal dt As DataTable)
        Me.mSurveyDataBaseTable = dt.Copy()
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "LoadSurveyDataTable", "", "Survey Data Table was loaded into memory."))
    End Sub
    Private Sub LoadSurveyDataTable()
        GenerateSchemaAndTempFile()
        Dim con As OleDb.OleDbConnection = Nothing
        Dim connStr As String
        Dim fi As New System.IO.FileInfo(Me.SurveyDataFile)
        Dim dfDirectory As String = GetFullTempPath()
        Dim dfFile As String = fi.Name
        connStr = String.Format( _
                        "Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};" + _
                        "Extended Properties=""text;HDR=YES;FMT=Delimited""", _
                        dfDirectory)
        Try
            con = New OleDb.OleDbConnection(connStr)
            con.Open()
            Dim sql As String = String.Format("SELECT * FROM [{0}] Order by [RESPONDENTID]", dfFile)
            Dim cmd As OleDb.OleDbCommand = con.CreateCommand()
            cmd.CommandType = CommandType.Text
            cmd.CommandText = sql
            Dim da As New OleDb.OleDbDataAdapter(cmd)
            da.Fill(Me.mSurveyDataBaseTable)
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "LoadSurveyDataTable", "", "Survey Data Table was loaded into memory."))
        Catch ex As Exception
            Throw ex
        Finally
            If con IsNot Nothing Then
                con.Close()
            End If
        End Try
    End Sub
    Private Sub SetTemplateAndNumMailings()
        Me.mTemplateID = CInt(Me.mSurveyDataBaseTable.Rows(0)(TEMPLATECOLNAME))
        Me.mNumberOfMailings = CInt(Me.mSurveyDataBaseTable.Rows(0)(NUMOFMAILINGSCOLNAME))
        Me.mProjectID = CInt(Me.mSurveyDataBaseTable.Rows(0)(PROJECTCOLNAME))
        Me.mFaqssID = CStr(Me.mSurveyDataBaseTable.Rows(0)(FAQSSIDCOLNAME))
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "SetTemplateAndNumMailings", "", "Template ID and Mail Step retrieved from first data record."))
    End Sub
#End Region

#Region " Validate Methods "
    ''' <summary>
    ''' Column names from ST are different than what's in existing doc templates.
    ''' Need to change them to the doc templates so the mail merge sees them.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub TransformColumnNames()
        For i As Integer = 0 To Me.mSurveyDataBaseTable.Columns.Count - 1
            Dim col As DataColumn = Me.mSurveyDataBaseTable.Columns(i)
            Select Case col.ColumnName.ToLower
                Case "respondentid"
                    col.ColumnName = "RESPONDENT_ID"
                Case "property_templateid"
                    col.ColumnName = "TEMPLATE_ID"
                Case "property_projectid"
                    col.ColumnName = "PROJECT_ID"
                Case "property_faqss_template_id"
                    col.ColumnName = "FAQSS_ID"
                Case "numberofmailings"
                    col.ColumnName = "MAILSTEP"
                Case "address1"
                    col.ColumnName = "ADDRESS"
                Case "telephoneday"
                    col.ColumnName = "PHONENUM"
                Case "property_webaccesscode"
                    col.ColumnName = "WEBACCESSCODE"
            End Select
        Next
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                "TransformColumnNames", "", "Column names have been converted from Survey Tracker column names to Document Field Names."))
    End Sub
    Private Sub RevertColumnNamesToOriginal(ByRef dt As DataTable)
        For i As Integer = 0 To dt.Columns.Count - 1
            Dim col As DataColumn = dt.Columns(i)
            Select Case col.ColumnName.ToUpper
                Case "RESPONDENT_ID"
                    col.ColumnName = "RESPONDENTID"
                Case "TEMPLATE_ID"
                    col.ColumnName = "Property_Templateid"
                Case "PROJECT_ID"
                    col.ColumnName = "Property_Projectid"
                Case "FAQSS_ID"
                    col.ColumnName = "Property_Faqss_Template_id"
                Case "MAILSTEP"
                    col.ColumnName = "NumberOfMailings"
                Case "ADDRESS"
                    col.ColumnName = "Address1"
                Case "PHONENUM"
                    col.ColumnName = "Telephoneday"
                Case "WEBACCESSCODE"
                    col.ColumnName = "Property_WebAccessCode"
            End Select
        Next
    End Sub
    Private Sub RemoveNonSTColumns(ByRef dt As DataTable)
        'Note, I don't remove the ISVALID column as that is what's used to fix data issues.
        dt.Columns.Remove("SEQNUM")
        dt.Columns.Remove("MATCHBARCODE")
        dt.Columns.Remove("PRINTPHONENUM")
        dt.Columns.Remove("PRINTPOSTALCODE")
        dt.Columns.Remove("PAGEBARCODE1")
        dt.Columns.Remove("PAGEBARCODE2")
        dt.Columns.Remove("PAGEBARCODE3")
        dt.Columns.Remove("PAGEBARCODE4")
        dt.Columns.Remove("PAGEBARCODEDATA1")
        dt.Columns.Remove("PAGEBARCODEDATA2")
        dt.Columns.Remove("PAGEBARCODEDATA3")
        dt.Columns.Remove("PAGEBARCODEDATA4")
        dt.Columns.Remove("ORDINAL")
    End Sub
    ''' <summary>
    ''' Add additional columns to base data set that will input programatically to 
    ''' validate data and handle non-data merge fields.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub AddNonSTColumns()
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("SEQNUM", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("MATCHBARCODE", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PRINTPHONENUM", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PRINTPOSTALCODE", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODE1", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODE2", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODE3", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODE4", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODEDATA1", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODEDATA2", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODEDATA3", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("PAGEBARCODEDATA4", System.Type.GetType("System.String")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("ORDINAL", System.Type.GetType("System.Int32")))
        Me.mSurveyDataBaseTable.Columns.Add(New DataColumn("ISVALID", System.Type.GetType("System.Boolean")))
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                "AddNonSTColumns", "", "Non-Survey Tracker columns have been added to survey data file."))

    End Sub
    ''' <summary>
    ''' Populate the ordinal, SEQNUM, and default the Isvalid to true.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub PopulateSequenceAndDefaults()
        Dim counter As Integer = 1
        For i As Integer = 0 To Me.mSurveyDataBaseTable.Rows.Count - 1
            Dim row As DataRow = Me.mSurveyDataBaseTable.Rows(i)
            row("SEQNUM") = SetIntegerString(counter)
            row("ORDINAL") = counter
            row("ISVALID") = True
            counter += 1
        Next
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                "PopulateSequenceAndDefaults", "", "Defaults were set for survey data file."))
    End Sub
    Private Sub ValidateSTData()
        Dim respIDs As New List(Of Integer)
        Dim faqssID As String = ""
        Dim projectID As Nullable(Of Integer)
        Dim hasCustomColumns As Boolean = False
        'We only want to run this logic if needed, so set flag here.
        For j As Integer = 0 To Me.mSurveyDataBaseTable.Columns.Count - 1
            If Me.MMDataColumns.FindTemplateColumn(Me.mSurveyDataBaseTable.Columns(j).ColumnName) Is Nothing Then
                hasCustomColumns = True
                Exit For
            End If
        Next
        For i As Integer = 0 To Me.mSurveyDataBaseTable.Rows.Count - 1
            'Validate Respondent ID.
            Dim row As DataRow = Me.mSurveyDataBaseTable.Rows(i)
            If (IsDBNull(row("RESPONDENT_ID")) OrElse row("RESPONDENT_ID") <= 0 OrElse respIDs.Contains(row("RESPONDENT_ID"))) Then
                Dim tempMsg As String = "An Invalid Respondent ID was found in the data file."
                If Not (IsDBNull(row("RESPONDENT_ID"))) AndAlso CStr(row("RESPONDENT_ID")).Length > 0 Then
                    tempMsg = CStr(row("RESPONDENT_ID")) & ": is a duplicate respondent ID."
                End If
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", tempMsg))
                row("ISVALID") = False
                mHasDataError = True
            End If
            respIDs.Add(row("RESPONDENT_ID"))            
            'Validate Template ID.
            If (IsDBNull(row("TEMPLATE_ID")) OrElse row("TEMPLATE_ID") <= 0 OrElse row("TEMPLATE_ID") > 99999 OrElse row("TEMPLATE_ID") <> Me.mTemplateID) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An Invalid Template ID was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate Project ID.
            If IsDBNull(row("PROJECT_ID")) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "A null project ID was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            Else
                If (Not projectID.HasValue) Then projectID = row("PROJECT_ID")
                If row("PROJECT_ID") <= 0 OrElse row("PROJECT_ID") > 99999 OrElse row("PROJECT_ID") <> projectID.Value Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid project ID was found in the data file."))
                    row("ISVALID") = False
                    mHasDataError = True
                End If
            End If
            'Validate FAQSS ID
            If IsDBNull(row("FAQSS_ID")) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "A null FAQSS ID was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            Else
                If (faqssID = "") Then faqssID = row("FAQSS_ID")
                If CStr(row("FAQSS_ID")).Length <> 8 OrElse row("FAQSS_ID") <> faqssID Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid FAQSS ID was found in the data file."))
                    row("ISVALID") = False
                    mHasDataError = True
                End If
            End If
            'Validate Mail Step
            If (IsDBNull(row("MAILSTEP")) OrElse row("MAILSTEP") <= 0 OrElse row("MAILSTEP") > 9 OrElse row("MAILSTEP") <> Me.NumberOfMailings) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Mail Step was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate First Name
            If (IsDBNull(row("FIRSTNAME")) OrElse CStr(row("FIRSTNAME")).Length = 0 OrElse CStr(row("FIRSTNAME")).Length > 20) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid First Name was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate Last Name
            If (IsDBNull(row("LASTNAME")) OrElse CStr(row("LASTNAME")).Length = 0 OrElse CStr(row("LASTNAME")).Length > 25) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Last Name was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'validate Address 1
            'TODO:  Must do DBNull check 1st.
            row("ADDRESS") = AppendAddress(row("ADDRESS"), row("ADDRESS2"))
            If (IsDBNull(row("ADDRESS")) OrElse CStr(row("ADDRESS")).Length = 0 OrElse CStr(row("ADDRESS")).Length > 35) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid address was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            row("ADDRESS2") = ""
            'Validate City
            If (IsDBNull(row("CITY")) OrElse CStr(row("CITY")).Length = 0 OrElse CStr(row("CITY")).Length > 20) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid City was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate State
            If (IsDBNull(row("STATE")) OrElse CStr(row("STATE")).Length <> 2) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid State was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate Postal Code
            If (IsDBNull(row("POSTALCODE")) OrElse CStr(row("POSTALCODE")).Length <> 5 OrElse Not (IsNumeric(row("POSTALCODE")))) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Postal Code was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate Postal Code Ext
            If IsDBNull(row("POSTALCODEEXT")) OrElse CStr(row("POSTALCODEEXT")).Length = 0 Then
                'Default extension in.
                row("POSTALCODEEXT") = "0000"
            ElseIf CStr(row("POSTALCODEEXT")).Length <> 4 OrElse Not (IsNumeric(row("POSTALCODEEXT"))) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Postal Code Extension was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            row("PRINTPOSTALCODE") = AppendPostalCodes(row("POSTALCODE"), row("POSTALCODEEXT"))
            'validate DOB
            If (IsDBNull(row("DOB")) OrElse Not (IsDate(row("DOB")))) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid DOB was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            Else
                row("DOB") = CDate(row("DOB")).ToShortDateString
            End If
            'Validate Gender
            If (IsDBNull(row("GENDER")) OrElse (row("GENDER") <> "M" And row("GENDER") <> "F")) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Gender was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            End If
            'Validate Telephone
            If IsDBNull(row("PHONENUM")) OrElse CStr(row("PHONENUM")).Length = 0 Then
                row("PRINTPHONENUM") = ""
            ElseIf Not (IsNumeric(row("PHONENUM"))) OrElse CStr(row("PHONENUM")).Length <> 10 Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid Phone Number was found in the data file."))
                row("ISVALID") = False
                mHasDataError = True
            Else
                row("PRINTPHONENUM") = "(" & CStr(row("PHONENUM")).Substring(0, 3) & ") " & CStr(row("PHONENUM")).Substring(3, 3) & "-" & CStr(row("PHONENUM")).Substring(6)
            End If
            If Me.mSurveyDataBaseTable.Columns.Contains("WEBACCESSCODE") Then
                If (Not (IsDBNull(row("WEBACCESSCODE")))) AndAlso CStr(row("WEBACCESSCODE")).Length <> 0 AndAlso CStr(row("WEBACCESSCODE")).Length <> 12 Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                        "ValidateSTData", "", "An invalid web access code was found in the data file."))
                    row("ISVALID") = False
                    mHasDataError = True
                End If
            End If
            'Validate that any add hoc fields are less than 1000 characters.
            If hasCustomColumns Then
                For colIndex = 0 To Me.mSurveyDataBaseTable.Columns.Count - 1
                    If MMDataColumns.FindTemplateColumn(Me.mSurveyDataBaseTable.Columns(colIndex).ColumnName) Is Nothing Then
                        If Not IsDBNull(row(colIndex)) Then
                            If CStr(row(colIndex)).Length > 1000 Then
                                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                            "ValidateSTData", "", "A custom column in the data file exceeds a length of 1000."))
                                row("ISVALID") = False
                                mHasDataError = True
                            End If
                        End If
                    End If
                Next
            End If
        Next
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                    "ValidateSTData", "", "Survey Data has been successfully validated."))
        End If
    End Sub
    Private Sub AddBarcodesAndCheckSums()
        For i As Integer = 0 To Me.mSurveyDataBaseTable.Rows.Count - 1
            Dim row As DataRow = Me.mSurveyDataBaseTable.Rows(i)
            row("PAGEBARCODE1") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 1, BarCodeTypes.BarCode)
            row("PAGEBARCODEDATA1") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 1, BarCodeTypes.Data)
            row("PAGEBARCODE2") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 2, BarCodeTypes.BarCode)
            row("PAGEBARCODEDATA2") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 2, BarCodeTypes.Data)
            row("PAGEBARCODE3") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 3, BarCodeTypes.BarCode)
            row("PAGEBARCODEDATA3") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 3, BarCodeTypes.Data)
            row("PAGEBARCODE4") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 4, BarCodeTypes.BarCode)
            row("PAGEBARCODEDATA4") = SetBarCode(CStr(row("FAQSS_ID")), CInt(row("TEMPLATE_ID")), CInt(row("RESPONDENT_ID")), 4, BarCodeTypes.Data)
            row("MATCHBARCODE") = SetMatchCode(CInt(row("RESPONDENT_ID")))
        Next
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, _
                                "AddBarcodesAndCheckSums", "", "Bar codes and match fields have been added."))
    End Sub
    Public Function GetModifiedDataTableOriginalFormat() As DataTable
        Dim dt As New DataTable
        If Me.Loaded Then
            dt = Me.mSurveyDataBaseTable.Copy()
            RevertColumnNamesToOriginal(dt)
            RemoveNonSTColumns(dt)
        End If
        Return dt
    End Function
    Public Function GetInValidSurveyDataTable() As DataTable
        Dim dt As New DataTable
        If Me.mHasDataError Then
            dt = Me.mSurveyDataBaseTable.Copy()
            RevertColumnNamesToOriginal(dt)
            RemoveNonSTColumns(dt)
        End If
        Return dt
    End Function
#End Region
#End Region

#Region " Helper Methods "

    Friend Sub ReSet()
        Me.mLoaded = False
        Me.mValidated = False
    End Sub
    Friend Function GetFullTempPath() As String
        If Me.mMergeName.Length > 0 Then
            Return Config.TempPath & "\" & CommonMethods.CleanFolderName(Me.MergeName)
        Else
            Throw New System.Exception("You can not retrieve the full temp path without first setting the merge name.")
        End If
    End Function
    Private Function SetMatchCode(ByVal respID As Integer) As String
        Static barCode As New StringBuilder
        Dim value As Integer = respID Mod (36 * 36)

        barCode.Remove(0, barCode.Length)
        barCode.Append("*" + CommonMethods.AddLeadingChar(BaseConverter.DecToB36(value), "0"c, 2) + "*")
        Return barCode.ToString
    End Function
    Private Function SetBarCode(ByVal faqssID As String, ByVal templateID As Integer, ByVal respondentID As Integer, ByVal pageNumber As Integer, ByVal bType As BarCodeTypes) As String
        Dim buffer As New StringBuilder()
        Dim barCode As New StringBuilder()
        Dim checkDigit As String
        buffer.Remove(0, buffer.Length)
        buffer.Append(String.Format("{0}{1:D5}{2:D8}{3}", _
                                    faqssID, _
                                    templateID, _
                                    respondentID, _
                                    pageNumber))
        checkDigit = BaseConverter.ComputeCheckDigit(buffer.ToString)

        barCode.Remove(0, barCode.Length)
        If bType = BarCodeTypes.BarCode Then
            barCode.Append(String.Format("*{0}{1:D5}{2:D8}{3}{4}*", _
                                    faqssID, _
                                    templateID, _
                                    respondentID, _
                                    pageNumber, _
                                    checkDigit))
        Else
            barCode.Append(String.Format("*{0} {1:D5} {2:D8} {3}{4}*", _
                                    faqssID, _
                                    templateID, _
                                    respondentID, _
                                    pageNumber, _
                                    checkDigit))
        End If
        Return barCode.ToString
    End Function
    Private Function AppendPostalCodes(ByVal zip As Object, ByVal zip4 As Object) As Object
        If IsDBNull(zip) Then
            Return zip
        Else
            If IsDBNull(zip4) Then
                Return Trim(CStr(zip))
            Else
                Return Trim(CStr(zip)) & "-" & Trim(CStr(zip4))
            End If
        End If
    End Function
    Private Function AppendAddress(ByVal adr1 As Object, ByVal adr2 As Object) As Object
        If IsDBNull(adr1) Then
            Return adr1
        Else
            If IsDBNull(adr2) OrElse CStr(adr2).Length = 0 Then
                Return Trim(CStr(adr1))
            Else
                Return Trim(CStr(adr1)) & " " & Trim(CStr(adr2))
            End If
        End If
    End Function
    Private Function SetIntegerString(ByVal val As Integer) As String
        Dim temp As String = CStr(val)
        Dim otherTemp As String = ""
        For i As Integer = temp.Length To 5 Step 1
            otherTemp += "0"
        Next
        Return otherTemp & temp
    End Function
    Private Function CleanCSVHeaderName(ByVal name As String) As String
        Dim retVal As String
        retVal = Trim$(name)
        If retVal.Substring(0, 1) = Chr(34) Then
            retVal = retVal.Substring(1)
        End If
        If retVal.Substring(retVal.Length - 1) = Chr(34) Then
            retVal = retVal.Substring(0, retVal.Length - 1)
        End If
        Return retVal
    End Function
    Private Sub CopyDataFileToTempDir()
        Dim tempPath As String = CommonMethods.AppendLastSlash(GetFullTempPath)
        If Directory.Exists(tempPath) Then
            For Each f As String In Directory.GetFiles(tempPath)
                File.Delete(f)
            Next
            Directory.Delete(tempPath)
        End If
        Directory.CreateDirectory(tempPath)
        Dim fi As New FileInfo(Me.mSurveyDataFile)
        Dim fName As String = fi.Name
        File.Copy(Me.mSurveyDataFile, tempPath & fName, True)
    End Sub
    Private Sub GenerateSchemaAndTempFile()
        Dim fi As New System.IO.FileInfo(Me.SurveyDataFile)
        Dim dfName As String = fi.Name
        CopyDataFileToTempDir()
        Dim dfDirectory As String = CommonMethods.AppendLastSlash(GetFullTempPath)
        Dim destFile As String = dfDirectory & "Schema.ini"
        Dim sw As StreamWriter = Nothing
        Try
            sw = New StreamWriter(destFile)
            sw.WriteLine("[{0}]", dfName)
            sw.WriteLine("ColNameHeader=True")
            sw.WriteLine("Format=CSVDelimited")
            sw.WriteLine("MaxScanRow=0")
            sw.WriteLine("CharacterSet=OEM")
            For i As Integer = 0 To Me.mSurveyDataColumns.Count - 1
                Dim mmCOl As MailMergeDataColumn = Me.MMDataColumns.FindColumn(Me.mSurveyDataColumns(i))
                If mmCOl IsNot Nothing Then
                    sw.WriteLine("COL" & (i + 1) & "=" & Me.mSurveyDataColumns(i) & " " & mmCOl.SchemaType)
                Else
                    sw.WriteLine("COL" & (i + 1) & "=" & Me.mSurveyDataColumns(i) & " Memo")
                End If
            Next
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Data), CLASSNAME, "GenerateSchema", "", "Schema for data file was successfully created."))
        Catch ex As Exception
            Throw ex
        Finally
            If sw IsNot Nothing Then
                sw.Close()
            End If
        End Try
    End Sub
#End Region
End Class
#End Region


#Region " Customers Collection Class "

#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeDataProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeDataProvider
    Private Const mProviderName As String = "MailMergeDataProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeDataProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeDataProvider)(mProviderName)
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

