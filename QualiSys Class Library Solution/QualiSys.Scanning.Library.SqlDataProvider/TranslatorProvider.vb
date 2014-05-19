Imports System.Data
Imports System.Data.Odbc
Imports System.IO
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class TranslatorProvider
    Inherits QualiSys.Scanning.Library.TranslatorProvider

#Region " Private ReadOnly Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " Private Members "

    ' TSB 02/06/2014
    'This enum was moved to Qualisys.Scanning.Library/Enums/TranslatorTypes.vb to make to more accessible for future possible translators
    'Private Enum TranslatorTypes
    '    CSV = 0
    '    CSVHorz = 1
    '    TABHorz = 2
    '    CSVBedside = 3
    '    TABCCAS
    'End Enum

#End Region

#Region " TranslatorCSV Methods "

    Public Overrides Function GetDataTableCSV(ByVal queueFile As QueuedTransferFile) As DataTable

        Return GetDataTableTEXT(queueFile, TranslatorTypes.CSV)

    End Function

#End Region

#Region " TranslatorCSVHorz Methods "

    Public Overrides Function GetDataTableCSVHorz(ByVal queueFile As QueuedTransferFile) As DataTable

        Return GetDataTableTEXT(queueFile, TranslatorTypes.CSVHorz)

    End Function

#End Region

#Region " TranslatorTABHorz Methods "

    Public Overrides Function GetDataTableTABHorz(ByVal queueFile As QueuedTransferFile) As DataTable

        Return GetDataTableTEXT(queueFile, TranslatorTypes.TABHorz)

    End Function

#End Region

#Region " TranslatorCSVBedside Methods "

    Public Overrides Function GetDataTableCSVBedside(ByVal queueFile As QueuedTransferFile) As DataTable

        Return GetDataTableTEXT(queueFile, TranslatorTypes.CSVBedside)

    End Function

    Public Overrides Function GetBedsideLithoCodeByMRNAdmitDate(ByVal mrn As String, ByVal admitDate As Date, ByVal studyID As Integer, ByVal surveyID As Integer) As String

        Dim lithoCode As String = String.Empty

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetBedsideLithoCodeByMRNAdmitDate, mrn, admitDate, studyID, surveyID)
            Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
                If Not rdr.Read Then
                    lithoCode = String.Empty
                Else
                    lithoCode = rdr.GetString("strLithoCode")
                End If
            End Using

            Return lithoCode
        End Using

    End Function

    Public Overrides Function GetBedsideLithoCodeByVisitNumAdmitDateVisitType(ByVal visitNum As String, ByVal admitDate As Date, ByVal visitType As String, ByVal studyID As Integer, ByVal surveyID As Integer) As String

        Dim lithoCode As String = String.Empty

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetBedsideLithoCodeByVisitNumAdmitDateVisitType, visitNum, admitDate, visitType, studyID, surveyID)
            Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
                If Not rdr.Read Then
                    lithoCode = String.Empty
                Else
                    lithoCode = rdr.GetString("strLithoCode")
                End If
            End Using

            Return lithoCode
        End Using

    End Function

    Public Overrides Function SelectTranslationModuleMappings(ByVal translationModuleID As Integer) As DataTable

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetTranslationModuleMappings, translationModuleID)
            Return QualiSysDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
        End Using

    End Function

    Public Overrides Function SelectTranslationModuleMappingRecodes(ByVal translationModuleMappingID As Integer) As DataTable

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetTranslationModuleMappingRecodes, translationModuleMappingID)
            Return QualiSysDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
        End Using

    End Function

#End Region

#Region " TranslatorVovici Methods "

    Public Overrides Function GetVoviciSurveyScaleValues(ByVal surveyId As Integer, ByVal samplesetId As Integer) As DataSet

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetVoviciSurveyScaleValues, surveyId, samplesetId)
            Return QualiSysDatabaseHelper.ExecuteDataSet(cmd)
        End Using

    End Function

#End Region

#Region "TranslatorTABCCAS Methods"

    Public Overrides Function GetAdvanisLithoCode(ByVal ccacCode As String, ByVal uniqueClientNumber As String, ByVal studyID As Integer, ByVal surveyID As Integer) As String
        Dim lithoCode As String = String.Empty

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetAdvanisLithoCode, ccacCode, uniqueClientNumber, studyID, surveyID)
            Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
                If Not rdr.Read Then
                    lithoCode = String.Empty
                Else
                    lithoCode = rdr.GetString("strLithoCode")
                End If
            End Using

            Return lithoCode
        End Using
    End Function

    Public Overrides Function GetAdvanisSurveyID(ByVal ccacCode As String, ByVal uniqueClientNumber As String, ByVal studyID As Integer) As Integer
        Dim surveyid As Integer = 0

        Using cmd As DbCommand = Db.GetStoredProcCommand(SP.GetAdvanisSurveyID, ccacCode, uniqueClientNumber, studyID)
            Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
                If Not rdr.Read Then
                    surveyid = 0
                Else
                    surveyid = rdr.GetInteger("surveyid")
                End If
            End Using

            Return surveyid
        End Using
    End Function

#End Region

#Region " Common Text File Methods "

    Public Overrides Function GetDataTable(ByVal queueFile As QueuedTransferFile, ByVal translatorType As TranslatorTypes) As DataTable

        Return GetDataTableTEXT(queueFile, translatorType)

    End Function


    Private Function GetDataTableTEXT(ByVal queueFile As QueuedTransferFile, ByVal translatorType As TranslatorTypes) As DataTable

        Dim fileVersion As Double

        'Make sure the file exists
        If Not queueFile.File.Exists Then
            Throw New InvalidFileException("Specified file not found.  File not processed!", queueFile.File.FullName)
        End If

        'Some formats require a preliminary schema.ini file in order to open them to determine the full schema
        CreateSchemaFileTEXT(queueFile, Nothing, translatorType, True)

        'Build the connection string
        Dim connString As String = String.Format("Driver={{Microsoft Text Driver (*.txt; *.csv)}};DBQ={0};", queueFile.File.DirectoryName)

        'Open the connection
        Dim conn As OdbcConnection
        Try
            conn = New OdbcConnection(connString)
            conn.Open()

        Catch ex As Exception
            Throw New InvalidFileException("Unable to open file using Text ODBC driver.  File not processed!", queueFile.File.FullName, ex)

        End Try

        'Determine the file version
        Select Case translatorType
            Case TranslatorTypes.CSVBedside, TranslatorTypes.TABCCAC
                fileVersion = 1.0

            Case Else
                'Populate the dataset to find version
                Using versionAdapter As OdbcDataAdapter = New OdbcDataAdapter(String.Format("SELECT TOP 2 * FROM [{0}]", queueFile.File.Name), conn)
                    Dim versionTbl As New DataTable
                    versionAdapter.Fill(versionTbl)

                    If Not Double.TryParse(Translator.GetFirstNonEmptyDataRow(versionTbl).Item("FileVersion").ToString, fileVersion) Then
                        fileVersion = 1.0
                    End If
                End Using

        End Select

        'Create the SCHEMA.INI file
        CreateSchemaFileTEXT(queueFile, conn, translatorType, False, fileVersion)

        'Populate the dataset
        Using dataAdapter As OdbcDataAdapter = New OdbcDataAdapter(String.Format("SELECT * FROM [{0}]", queueFile.File.Name), conn)
            Dim dataTbl As New DataTable
            dataAdapter.Fill(dataTbl)
            Return dataTbl
        End Using

    End Function

    Private Sub CreateSchemaFileTEXT(ByVal queueFile As QueuedTransferFile, ByVal conn As OdbcConnection, ByVal translatorType As TranslatorTypes, ByVal headerOnly As Boolean, Optional ByVal fileVersion As Double = 1.0)

        Dim columnCount As Integer = 0
        Dim columnName As String = String.Empty
        Dim formatLine As String = String.Empty
        Dim schema As DataTable = Nothing

        If Not headerOnly Then
            'Get the schema table
            Try
                Using command As OdbcCommand = New OdbcCommand(String.Format("SELECT TOP 1 * FROM [{0}]", queueFile.File.Name), conn)
                    Using dataRdr As OdbcDataReader = command.ExecuteReader
                        schema = dataRdr.GetSchemaTable

                        'The maximum number of columns this ODBC driver supports is 255. If there are more than 255 columns the driver ignores the extra columns.
                        'So we check if the count is more than 254, one less than max, this way we are sure  we did not lose any rows. 
                        If dataRdr.FieldCount() > 254 Then
                            Throw New InvalidFileException("Number of columns exceeded 254, the maximum number supported.  File not processed!", queueFile.File.FullName)
                        End If
                    End Using
                End Using
            Catch ex As InvalidFileException
                Throw ex
            Catch ex As Exception
                Throw New InvalidFileException("Unable to read file using Text ODBC driver.  File not processed!", queueFile.File.FullName, ex)
            End Try

            'Check to see if all of the fixed columns are present
            Dim message As String = String.Empty
            Dim missingColumns As String = String.Empty
            Select Case translatorType
                Case TranslatorTypes.CSV
                    If Not TranslatorCSV.DoAllFixedColumnsExist(schema, missingColumns, fileVersion) Then
                        Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), queueFile.File.FullName)
                    End If

                Case TranslatorTypes.CSVHorz
                    If Not TranslatorCSVHorz.DoAllFixedColumnsExist(schema, missingColumns, fileVersion) Then
                        Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), queueFile.File.FullName)
                    End If
                    If Not TranslatorCSVHorz.DoAllDispoColumnsExist(schema, message) Then
                        Throw New InvalidFileException(String.Format("Mismatched disposition columns found.  File not processed!{0}{1}", vbCrLf, message), queueFile.File.FullName)
                    End If

                Case TranslatorTypes.CSVBedside
                    If Not TranslatorCSVBedside.DoAllFixedColumnsExist(schema, missingColumns, fileVersion, queueFile) Then
                        Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), queueFile.File.FullName)
                    End If

                Case TranslatorTypes.TABHorz
                    If Not TranslatorTABHorz.DoAllFixedColumnsExist(schema, missingColumns, fileVersion) Then
                        Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), queueFile.File.FullName)
                    End If
                    If Not TranslatorTABHorz.DoAllDispoColumnsExist(schema, message) Then
                        Throw New InvalidFileException(String.Format("Mismatched disposition columns found.  File not processed!{0}{1}", vbCrLf, message), queueFile.File.FullName)
                    End If
                Case TranslatorTypes.TABCCAC
                    If Not TranslatorTABCCAC.DoAllFixedColumnsExist(schema, missingColumns, fileVersion, queueFile) Then
                        Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), queueFile.File.FullName)
                    End If

            End Select
        End If

        'Open the schema file
        Dim schemaFile As TextWriter
        Try
            schemaFile = File.CreateText(Path.Combine(queueFile.File.DirectoryName, "schema.ini"))

        Catch ex As Exception
            Throw New InvalidFileException("Unable to create schema.ini file.  File not processed!", queueFile.File.FullName, ex)

        End Try

        'Write the schema file
        Try
            'Write the header information
            '#65001	is code pages Identifier for utf-8	Unicode (UTF-8)
            With schemaFile
                .WriteLine("[{0}]", queueFile.File.Name)
                .WriteLine("ColNameHeader=True")
                .WriteLine("MaxScanRows=10")
                .WriteLine("CharacterSet=65001")

                'Add the file delimiter line
                Select Case translatorType
                    Case TranslatorTypes.CSV, TranslatorTypes.CSVHorz, TranslatorTypes.CSVBedside
                        .WriteLine("Format=CSVDelimited")

                    Case TranslatorTypes.TABHorz, TranslatorTypes.TABCCAC
                        With schemaFile
                            .WriteLine("Format=TabDelimited")
                        End With

                End Select
            End With

            If Not headerOnly Then
                'Write out all column information
                For Each row As DataRow In schema.Rows
                    columnCount += 1
                    columnName = row("ColumnName").ToString.ToUpper
                    Select Case translatorType
                        Case TranslatorTypes.CSV
                            formatLine = TranslatorCSV.GetSchemaFormatLine(columnName)

                        Case TranslatorTypes.CSVHorz
                            formatLine = TranslatorCSVHorz.GetSchemaFormatLine(columnName)

                        Case TranslatorTypes.CSVBedside
                            formatLine = TranslatorCSVBedside.GetSchemaFormatLine(columnName, queueFile)

                        Case TranslatorTypes.TABHorz
                            formatLine = TranslatorTABHorz.GetSchemaFormatLine(columnName)

                        Case TranslatorTypes.TABCCAC
                            formatLine = TranslatorTABCCAC.GetSchemaFormatLine(columnName, queueFile)

                    End Select

                    If formatLine.Length > 0 Then
                        'This is a valid column
                        schemaFile.WriteLine(formatLine, columnCount, columnName)
                    Else
                        'This is not a valid column for this file type
                        Throw New InvalidFileException(String.Format("Invalid column name ({0}) found.  File not processed!", columnName), queueFile.File.FullName)
                    End If
                Next
            End If

        Catch invalidFileEx As InvalidFileException
            Throw
            Exit Try

        Catch ex As Exception
            Throw New InvalidFileException("Unable to write to schema.ini file.  File not processed!", queueFile.File.FullName, ex)

        Finally
            'Close the file
            schemaFile.Flush()
            schemaFile.Close()

        End Try

    End Sub

#End Region

End Class
