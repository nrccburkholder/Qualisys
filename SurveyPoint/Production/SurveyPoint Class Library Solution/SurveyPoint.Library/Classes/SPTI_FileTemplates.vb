Imports Nrc.Framework.BusinessLogic
Imports System.IO
Imports System.Text
Imports System.Data

Public Interface ISPTI_FileTemplate
    Property FileTemplateID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_FileTemplate
    Inherits BusinessBase(Of SPTI_FileTemplate)
    Implements ISPTI_FileTemplate

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFileTemplateID As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mIsFixedLength As Boolean
    Private mEncodingType As Integer
    Private mImportAsString As Boolean
    Private mTrimStrings As Boolean = True 'Default
    Private mDateCreated As Date
    Private mActive As Integer
    Private mArchive As Integer
    Private mColumnDefintions As SPTI_ColumnDefinitionCollection
    Private mInitNonPropRule As Boolean
    Private mDelimeterID As Integer
    Private mUseQuotedIdentifier As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>PK for a file template</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FileTemplateID() As Integer Implements ISPTI_FileTemplate.FileTemplateID
        Get
            Return mFileTemplateID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFileTemplateID Then
                mFileTemplateID = value
                PropertyHasChanged("FileTemplateID")
            End If
        End Set
    End Property
    ''' <summary>Name of the file template</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    ''' <summary>A description of the file template</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property
    ''' <summary>If true this template is for a fixed length file.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property IsFixedLength() As Boolean
        Get
            Return mIsFixedLength
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsFixedLength Then
                mIsFixedLength = value
                PropertyHasChanged("IsFixedLength")
            End If
        End Set
    End Property
    ''' <summary>The encoding type to use.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EncodingType() As Integer
        Get
            Return mEncodingType
        End Get
        Set(ByVal value As Integer)
            If Not value = mEncodingType Then
                mEncodingType = value
                PropertyHasChanged("EncodingType")
            End If
        End Set
    End Property
    ''' <summary>This allows you to record column types, but import them as if they were string.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ImportAsString() As Boolean
        Get
            Return mImportAsString
        End Get
        Set(ByVal value As Boolean)
            If Not value = mImportAsString Then
                mImportAsString = value
                PropertyHasChanged("ImportAsString")
            End If
        End Set
    End Property
    ''' <summary>Trims leading an trailing spaces from columns.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property TrimStrings() As Boolean
        Get
            Return mTrimStrings
        End Get
        Set(ByVal value As Boolean)
            If Not value = mTrimStrings Then
                mTrimStrings = value
                PropertyHasChanged("TrimStrings")
            End If
        End Set
    End Property
    ''' <summary>Date record was inserted into data store.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Active() As Integer
        Get
            Return mActive
        End Get
        Set(ByVal value As Integer)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("Active")
            End If
        End Set
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Archive() As Integer
        Get
            Return mArchive
        End Get
        Set(ByVal value As Integer)
            If Not value = mArchive Then
                mArchive = value
                PropertyHasChanged("Archive")
            End If
        End Set
    End Property
    ''' <summary>Collection of columns that make up this file template.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ColumnDefinitions() As SPTI_ColumnDefinitionCollection
        Get
            If Me.mColumnDefintions Is Nothing Then
                If Me.mFileTemplateID = 0 Then
                    Me.mColumnDefintions = New SPTI_ColumnDefinitionCollection
                Else
                    Me.mColumnDefintions = SPTI_ColumnDefinition.GetByFileTemplateID(Me.mFileTemplateID)
                End If
            End If
            Return Me.mColumnDefintions
        End Get
        Set(ByVal value As SPTI_ColumnDefinitionCollection)
            Me.mColumnDefintions = value
        End Set
    End Property
    ''' <summary>This property allows us to invoke busines rules that don't have a tie to a property.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property InitNonPropRule() As Boolean
        Get
            Return Me.mInitNonPropRule
        End Get
        Set(ByVal value As Boolean)
            Me.mInitNonPropRule = value
            PropertyHasChanged("InitNonPropRule")
        End Set
    End Property
    Public Property DelimeterID() As Integer
        Get
            Return Me.mDelimeterID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mDelimeterID = value Then
                Me.mDelimeterID = value
                PropertyHasChanged("DelimeterID")
            End If
        End Set
    End Property
    Public Property UseQuotedIdentifier() As Boolean
        Get
            Return Me.mUseQuotedIdentifier
        End Get
        Set(ByVal value As Boolean)
            If Not Me.mUseQuotedIdentifier = value Then
                Me.mUseQuotedIdentifier = value
                PropertyHasChanged("UseQuotedIdentifier")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Default Constructor.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal name As String, ByVal desc As String)
        Me.mName = name
        Me.mDescription = desc
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Create a new file template</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewSPTI_FileTemplate() As SPTI_FileTemplate
        Return New SPTI_FileTemplate
    End Function
    Public Shared Function NewSPTI_FileTemplate(ByVal name As String, ByVal desc As String) As SPTI_FileTemplate
        Return New SPTI_FileTemplate(name, desc)
    End Function
    ''' <summary>Get a file template from the data store by its id.</summary>
    ''' <param name="fileTemplateID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal fileTemplateID As Integer) As SPTI_FileTemplate
        Return DataProviders.SPTI_FileTemplatesProvider.Instance.SelectSPTI_FileTemplate(fileTemplateID)
    End Function
    ''' <summary>Get all file templates from store into a collection.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As SPTI_FileTemplateCollection
        Return DataProviders.SPTI_FileTemplatesProvider.Instance.SelectAllSPTI_FileTemplates()
    End Function
    ''' <summary>Delete the file template and its corresponding columns.</summary>
    ''' <param name="fileTemplateID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Sub DeleteTemplateIncludingChildren(ByVal fileTemplateID As Integer)
        DataProviders.SPTI_FileTemplatesProvider.Instance.DeleteTemplateIncludingChildren(fileTemplateID)
    End Sub
    ''' <summary>Check if a file template name already exists in the data store.</summary>
    ''' <param name="fileTemplateID"></param>
    ''' <param name="fileTemplateName"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CheckFileTemplateExistsByName(ByVal fileTemplateID As Integer, ByVal fileTemplateName As String) As Boolean
        Return DataProviders.SPTI_FileTemplatesProvider.Instance.CheckFileTemplateExistsByName(fileTemplateID, fileTemplateName)
    End Function
    ''' <summary>Create a new file template based on values of an existing file template.</summary>
    ''' <param name="oldFileTemplateID"></param>
    ''' <param name="newFileTemplateName"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CopyFileTemplate(ByVal oldFileTemplateID As Integer, ByVal newFileTemplateName As String) As Integer
        Return DataProviders.SPTI_FileTemplatesProvider.Instance.CopyFileTemplate(oldFileTemplateID, newFileTemplateName)
    End Function
    Public Shared Function CheckIfFileTemplateExistsInExportDefinition(ByVal fileTemplateID As Integer) As Boolean
        Return DataProviders.SPTI_FileTemplatesProvider.Instance.CheckIfFileTemplatesExistInExportDefinitions(fileTemplateID)
    End Function
#End Region
    
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFileTemplateID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...  
        ValidationRules.AddRule(AddressOf CheckNonPropRules, "InitNonPropRule")
    End Sub
    ''' <summary>Validates itself, non property rules and its child objects returning a collection of broken rules.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateAll() As Validation.BrokenRulesCollection
        Me.InitNonPropRule = True
        If Not Me.IsValid Then
            Return Me.BrokenRulesCollection
        End If
        For Each item As SPTI_ColumnDefinition In Me.ColumnDefinitions
            If Not item.IsValid Then
                Return item.BrokenRulesCollection
            End If
        Next
        Return Nothing
    End Function
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>Crud Insert</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        FileTemplateID = DataProviders.SPTI_FileTemplatesProvider.Instance.InsertSPTI_FileTemplate(Me)
    End Sub

    ''' <summary>Crud Update</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        DataProviders.SPTI_FileTemplatesProvider.Instance.UpdateSPTI_FileTemplate(Me)
    End Sub

    ''' <summary>Crud Delete</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_FileTemplatesProvider.Instance.DeleteSPTI_FileTemplate(mFileTemplateID)
    End Sub
    ''' <summary>Save itself and any column definitins the object has.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()        
        MyBase.Save()
        If Not Me.ColumnDefinitions Is Nothing Then
            Me.ColumnDefinitions.Save()
        End If        
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>Rule for name property and checks columns defs for name uniqueness.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function CheckNonPropRules(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.Name = "" Then
            e.Description = "File Template Name can not be empty."
            Return False
        ElseIf SPTI_FileTemplate.CheckFileTemplateExistsByName(Me.FileTemplateID, Me.Name) Then
            e.Description = "File Template Name can not match a name already in the data store."
            Return False
        Else
            If Not Me.ColumnDefinitions Is Nothing Then
                Dim counter As Integer = 0
                For Each col As SPTI_ColumnDefinition In Me.ColumnDefinitions
                    For Each col1 As SPTI_ColumnDefinition In Me.ColumnDefinitions
                        If col.Name = col1.Name Then
                            counter += 1
                        End If
                    Next
                    If counter > 1 Then
                        e.Description = "Column Names must be unique."
                        Return False
                    Else
                        counter = 0
                    End If
                Next
            End If
            Return True
        End If
    End Function
    Friend Function CreateImportTable(ByVal logID As Integer) As String
        Dim tableName As String = "SPTI_Export_" & logID
        Dim fieldList As String = GetFieldsList()
        DataProviders.SPTI_FileTemplatesProvider.Instance.CreateImportTable(tableName, fieldList)
        Return tableName
    End Function
    Private Function GetOrderedIndexes() As List(Of Integer)
        Dim retVal As New List(Of Integer)
        Dim ords As New List(Of Integer)
        For i As Integer = 0 To Me.ColumnDefinitions.Count - 1
            ords.Add(Me.ColumnDefinitions(i).Ordinal)
        Next
        ords.Sort()
        For j As Integer = 0 To ords.Count - 1
            For i As Integer = 0 To Me.ColumnDefinitions.Count - 1
                If ords(j) = Me.ColumnDefinitions(i).Ordinal Then
                    retVal.Add(i)
                End If
            Next
        Next
        Return retVal
    End Function
    Private Function GetFieldsList() As String
        Dim retVal As String = ""
        'Get the columns in the correct order.
        Dim orderedIndexes As List(Of Integer) = GetOrderedIndexes()
        For i As Integer = 0 To orderedIndexes.Count - 1
            retVal += Me.ColumnDefinitions(orderedIndexes(i)).GetColumnCreateSQL(Me.ImportAsString)
            If i <> orderedIndexes.Count - 1 Then
                retVal += ","
            End If
        Next
        Return retVal
    End Function
    Private Function GetColumnList() As String
        Dim retVal As String = ""
        'Get the columns in the correct order.
        Dim orderedIndexes As List(Of Integer) = GetOrderedIndexes()
        For i As Integer = 0 To orderedIndexes.Count - 1
            retVal += Me.ColumnDefinitions(orderedIndexes(i)).GetColumnName
            If i <> orderedIndexes.Count - 1 Then
                retVal += ","
            End If
        Next
        Return retVal
    End Function
    Friend Sub ImportSourceTable(ByVal parent As SPTI_ExportDefinition, ByVal filePath As String, ByVal logID As Integer, ByVal hasHeader As Boolean)
        Dim tableName As String = "SPTI_Export_" & logID
        Dim fieldsList As String = GetColumnList()
        Dim strLine As String = String.Empty
        Dim fieldValues As String = ""
        Dim counter As Long = 0
        Dim sr As StreamReader = Nothing
        Dim orderedIndexes As List(Of Integer) = GetOrderedIndexes()
        If Me.IsFixedLength Then
            If Me.EncodingType = 1 Then 'ANSI
                sr = New StreamReader(filePath, System.Text.Encoding.ASCII)
            Else '(2) UNICODE 
                sr = New StreamReader(filePath, System.Text.Encoding.Unicode)
            End If
            Do While sr.Peek >= 0
                strLine = sr.ReadLine
                If counter > 0 Or hasHeader = False Then
                    fieldValues = GetImportFixedValueString(strLine, orderedIndexes)
                    DataProviders.SPTI_FileTemplatesProvider.Instance.InsertImportTable(logID, fieldsList, fieldValues)
                    If counter Mod 100 = 0 Then
                        parent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, counter & " Records Imported", 0, "", "Export Definition Processing"))
                    End If
                End If
                counter += 1
            Loop
            sr.Close()
        Else
            'Delimited.
            Dim headerVal As String
            Dim path As String = filePath.Substring(0, filePath.LastIndexOf("\"c))
            Dim fileName As String = filePath.Substring(filePath.LastIndexOf("\"c) + 1)
            Dim tempPath As String = Config.TempFileDirectory
            Dim tempFileName As String = ""
            Dim ds As New DataSet
            If hasHeader Then
                headerVal = "Yes"
            Else
                headerVal = "No"
            End If
            Try
                tempFileName = CreateTempFileAndSchema(path, fileName, orderedIndexes, hasHeader)
                Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
                tempPath & ";Extended Properties=""Text;HDR=" & headerVal & ";FMT=Delimited\"""
                Dim conn As New OleDb.OleDbConnection(connStr)
                Dim da As New OleDb.OleDbDataAdapter("Select * from " & tempFileName, conn)
                da.Fill(ds, "TextFile")
                For Each row As DataRow In ds.Tables(0).Rows
                    fieldValues = GetDelimitedValueString(row, ds.Tables(0), orderedIndexes)
                    DataProviders.SPTI_FileTemplatesProvider.Instance.InsertImportTable(logID, fieldsList, fieldValues)
                    counter += 1
                    If counter Mod 100 = 0 Then
                        parent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, counter & " Records Imported", 0, "", "Export Definition Processing"))
                    End If
                Next
            Catch ex As Exception
                Throw ex
            Finally
                ClearTempFileAndSchemaDirectory()
            End Try
        End If
    End Sub
    Private Function CreateTempFileAndSchema(ByVal sourceDir As String, ByVal fileName As String, ByVal orderedIndexes As List(Of Integer), ByVal hasHeader As Boolean) As String
        'Fix OleDB bug
        Dim tempFileName As String = "Temp" & Replace(fileName, " ", "")
        If Not System.IO.Directory.Exists(Config.TempFileDirectory) Then
            System.IO.Directory.CreateDirectory(Config.TempFileDirectory)
        End If
        Dim fullPath As String = sourceDir & "\" & fileName
        Dim tempPath As String = Config.TempFileDirectory & "\" & tempFileName
        System.IO.File.Copy(fullPath, tempPath)
        Dim tempFileWriter As StreamWriter = Nothing
        Dim writer As StreamWriter = Nothing
        Try
            writer = File.CreateText(Config.TempFileDirectory & "\Schema.ini")
            writer.WriteLine("[" & tempFileName & "]")
            Select Case Me.DelimeterID
                Case 1 'Tab
                    writer.WriteLine("Format=TabDelimited")
                Case 2 'Comma
                    writer.WriteLine("Format=CSVDelimited")
                Case 3 'Pipe
                    writer.WriteLine("Format=Delimited(|)")
            End Select
            If Not hasHeader Then
                writer.WriteLine("ColNameHeader=False")
            End If
            'Solve for typing issues.
            writer.WriteLine()
            For i As Integer = 0 To orderedIndexes.Count - 1
                Dim colDef As SPTI_ColumnDefinition = Me.ColumnDefinitions(orderedIndexes(i))
                Select Case colDef.DateTypeID
                    Case 1  'String
                        writer.WriteLine("Col" & (i + 1) & "=Col" & (i + 1) & " Text")
                    Case 2  'Integer
                        writer.WriteLine("Col" & (i + 1) & "=Col" & (i + 1) & " Long")
                    Case 3  'Decimal
                        writer.WriteLine("Col" & (i + 1) & "=Col" & (i + 1) & " Double")
                    Case 4  'DateTime  We want the date time types as a string so that we may parse it.
                        writer.WriteLine("Col" & (i + 1) & "=Col" & (i + 1) & " Text")
                    Case 5  'Memo
                        writer.WriteLine("Col" & (i + 1) & "=Col" & (i + 1) & " Memo")
                    Case Else
                        Throw New Exception("Column Defintion is not Typed.")
                End Select
            Next
            Return tempFileName
        Catch ex As Exception
            Throw ex
        Finally
            If Not writer Is Nothing Then
                writer.Close()
                writer = Nothing
            End If
            If Not tempFileWriter Is Nothing Then
                tempFileWriter.Close()
                tempFileWriter = Nothing
            End If
        End Try

    End Function
    Private Sub ClearTempFileAndSchemaDirectory()
        If System.IO.Directory.Exists(Config.TempFileDirectory) Then
            For Each file As String In Directory.GetFiles(Config.TempFileDirectory)
                System.IO.File.Delete(file)
            Next
        End If
    End Sub
    Private Function GetImportFixedValueString(ByVal line As String, ByVal orderedIndexes As List(Of Integer)) As String
        Dim start As Integer = 0
        Dim length As Integer = 0
        Dim valueList As New StringBuilder()
        Dim value As String = ""
        For i As Integer = 0 To orderedIndexes.Count - 1
            Dim colDef As SPTI_ColumnDefinition = Me.ColumnDefinitions(orderedIndexes(i))
            length = colDef.FixedStringLength
            System.Diagnostics.Debug.Print(CStr(line.Length))
            If i = orderedIndexes.Count - 1 Then
                value = line.Substring(start)
            Else
                value = line.Substring(start, length)
            End If

            start += length
            If Me.ImportAsString Then
                value = "'" & Replace(Trim(value), "'", "''") & "'"
            Else
                Select Case colDef.DataTypeName.ToLower
                    Case "string"
                        If colDef.FormatingRuleID > 0 Then
                            value = "'" & Replace(Trim(colDef.FormatingRule.FormatFromRule(value)), "'", "''") & "'"
                        Else
                            value = "'" & Replace(Trim(value), "'", "''") & "'"
                        End If

                    Case "integer"
                        value = CStr(CInt(Val(Trim(value))))
                    Case "decimal"
                        value = CStr(CDec(Val(Trim(value))))
                    Case "datetime"
                        'value = Trim(value)
                        value = colDef.FormatingRule.FormatFromRule(value)
                        'If colDef.FormatingRuleName.ToLower = "yyyymmdd to date" Then
                        '    value = value.Substring(4, 2) & "/" & value.Substring(6, 2) & "/" & value.Substring(0, 4)
                        'End If
                        If IsDate(value) Then
                            value = "'" & CDate(value).ToShortDateString() & "'"
                        Else
                            value = "null"
                        End If
                    Case Else
                        value = "'" & Replace(Trim(value), "'", "''") & "'"
                End Select
            End If
            If i = orderedIndexes.Count - 1 Then
                valueList.Append(value)
            Else
                valueList.Append(value & ",")
            End If
        Next
        Return valueList.ToString()
    End Function
    Private Function GetDelimitedValueString(ByVal row As DataRow, ByVal table As DataTable, ByVal orderedIndexes As List(Of Integer)) As String
        Dim retVal As New StringBuilder()                        
        For i As Integer = 0 To orderedIndexes.Count - 1
            Dim colDef As SPTI_ColumnDefinition = Me.ColumnDefinitions(orderedIndexes(i))
            Dim value As String = ""
            If IsDBNull(row(i)) Then
                value = ""
            Else
                value = CStr(row(i))
            End If
            If Me.ImportAsString Then
                value = "'" & Replace(Trim(value), "'", "''") & "'"
            Else
                Select Case colDef.DataTypeName.ToLower
                    Case "string"
                        If colDef.FormatingRuleID > 0 Then
                            value = "'" & Replace(Trim(colDef.FormatingRule.FormatFromRule(value)), "'", "''") & "'"
                        Else
                            value = "'" & Replace(Trim(value), "'", "''") & "'"
                        End If
                    Case "integer"
                        value = CStr(CInt(Val(Trim(value))))
                    Case "decimal"
                        value = CStr(CDec(Val(Trim(value))))
                    Case "datetime"
                        'value = Trim(value)
                        value = colDef.FormatingRule.FormatFromRule(value)
                        'If colDef.FormatingRuleName.ToLower = "yyyymmdd to date" Then
                        '    value = value.Substring(4, 2) & "/" & value.Substring(6, 2) & "/" & value.Substring(0, 4)
                        'End If
                        If IsDate(value) Then
                            value = "'" & CDate(value).ToShortDateString & "'"
                        Else
                            value = "null"
                        End If
                    Case Else
                        value = "'" & Replace(Trim(value), "'", "''") & "'"
                End Select
            End If
            If i = orderedIndexes.Count - 1 Then
                retVal.Append(value)
            Else
                retVal.Append(value & ",")
            End If
        Next
        Return retVal.ToString
    End Function

    Friend Sub WriteExportFile(ByVal logID As Integer, ByVal fileDef As SPTI_ExportDefintionFile)
        Dim writer As StreamWriter = Nothing
        Dim colIndexes As List(Of Integer) = GetOrderedIndexes()
        Dim fieldList As String = ""
        Dim qualifier As String = ""
        'TODO:  Clean this up.  Use an alias rather than hard coding the qualified names.
        If Not fileDef.DBDeDupRule Is Nothing Then
            qualifier = "QF."
        Else
            qualifier = "Q."
        End If
        Dim criteriaList As String = fileDef.SplitRule
        For i As Integer = 0 To colIndexes.Count - 1
            fieldList += qualifier & "[" & Me.ColumnDefinitions(colIndexes(i)).Name & "],"
        Next
        If fieldList.Length > 0 Then
            fieldList = fieldList.Substring(0, fieldList.Length - 1)
        End If
        Dim resultsTable As System.Data.DataTable = Nothing
        If Not fileDef.DBDeDupRule Is Nothing Then
            fileDef.DeDupQMS(logID, criteriaList)
            resultsTable = DataProviders.SPTI_FileTemplatesProvider.Instance.SelectQMSDeDupedExportFileData(logID, fileDef.FileID, fieldList)
        Else
            resultsTable = DataProviders.SPTI_FileTemplatesProvider.Instance.SelectExportFileData(logID, fileDef.FileID, fieldList, criteriaList)
        End If

        Try
            writer = New StreamWriter(fileDef.PathandFileName)
            For Each row As DataRow In resultsTable.Rows
                Dim line As New StringBuilder
                For i As Integer = 0 To resultsTable.Columns.Count - 1
                    If Not resultsTable.Columns(i).ColumnName = "ID" Then
                        Dim colDef As SPTI_ColumnDefinition = Me.ColumnDefinitions.GetColumnDefByName(resultsTable.Columns(i).ColumnName)
                        Dim delimeter As String = ""
                        Select Case Me.DelimeterID
                            Case 1
                                delimeter = "	"
                            Case 2
                                delimeter = ","
                            Case 3
                                delimeter = "|"
                            Case Else
                                delimeter = "," 'Default
                        End Select
                        line.Append(colDef.GetFormatedColumnValue(row(i), Me.IsFixedLength, Me.TrimStrings, delimeter))
                        If Not Me.IsFixedLength AndAlso Not i = resultsTable.Columns.Count - 1 Then
                            Select Case Me.DelimeterID
                                Case 1      'Tab
                                    line.Append(vbTab)
                                Case 2      'Comma
                                    line.Append(",")
                                Case 3      'Pipe
                                    line.Append("|")
                                Case Else   'Default to Comma
                                    line.Append(",")
                            End Select
                        End If
                    End If
                Next
                writer.WriteLine(line.ToString())
            Next
        Catch ex As Exception
            Throw ex
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub
#End Region

End Class
