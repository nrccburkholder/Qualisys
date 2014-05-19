Imports System.Data
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification


Public MustInherit Class Translator

#Region "Public MustOverride Methods"

    Public MustOverride Function Translate(ByVal queueFile As QueuedTransferFile) As DataLoad
    Protected MustOverride Function PopulateDataSet(ByVal queueFile As QueuedTransferFile, ByVal table As DataTable) As DataSet

#End Region

#Region "Protected Methods"

    Protected Function GetEmptyDataSet() As DataSet

        Dim empty As New DataSet

        'Add the FileInfo table
        Dim table As DataTable = New DataTable("FileInfo")
        With table.Columns
            .Add("FileVersion", GetType(String))
            .Add("VendorCode", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the Survey table
        table = New DataTable("Survey")
        With table.Columns
            .Add("SurveyID", GetType(Integer))
        End With
        empty.Tables.Add(table)

        'Add the Respondent table
        table = New DataTable("Respondent")
        With table.Columns
            .Add("SurveyID", GetType(Integer))
            .Add("LithoCode", GetType(String))
            .Add("ResponseType", GetType(String))
            .Add("SurveyLang", GetType(Integer))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Survey and Respondent
        empty.Relations.Add("SurveyRespondent", empty.Tables("Survey").Columns("SurveyID"), empty.Tables("Respondent").Columns("SurveyID"), True)

        'Add the Bubble table
        table = New DataTable("Bubble")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("QstnCore", GetType(Integer))
            .Add("Value", GetType(String))
            .Add("MultipleResponse", GetType(Boolean))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and Bubble
        empty.Relations.Add("RespondentBubble", empty.Tables("Respondent").Columns("LithoCode"), empty.Tables("Bubble").Columns("LithoCode"), True)

        'Add the HandEntry table
        table = New DataTable("HandEntry")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("QstnCore", GetType(Integer))
            .Add("Item", GetType(Integer))
            .Add("Line", GetType(Integer))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and HandEntry
        empty.Relations.Add("RespondentHandEntry", empty.Tables("Respondent").Columns("LithoCode"), empty.Tables("HandEntry").Columns("LithoCode"), True)

        'Add the Comment table
        table = New DataTable("Comment")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("CmntID", GetType(Integer))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and Comment
        empty.Relations.Add("RespondentComment", empty.Tables("Respondent").Columns("LithoCode"), empty.Tables("Comment").Columns("LithoCode"), True)

        'Add the PopMapping table
        table = New DataTable("PopMapping")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("PopMappingID", GetType(Integer))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and PopMapping
        empty.Relations.Add("RespondentPopMapping", empty.Tables("Respondent").Columns("LithoCode"), empty.Tables("PopMapping").Columns("LithoCode"), True)

        'Add the Disposition table
        table = New DataTable("Disposition")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("Code", GetType(String))
            .Add("Date", GetType(Date))
            .Add("IsFinal", GetType(Boolean))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and Disposition
        empty.Relations.Add("RespondentDisposition", empty.Tables("Respondent").Columns("LithoCode"), empty.Tables("Disposition").Columns("LithoCode"), True)

        'Make sure we are enforcing the constraints
        empty.EnforceConstraints = True

        'Return the empty dataset
        Return empty

    End Function

    Protected Function PopulateDataLoad(ByVal loadSet As DataSet, ByVal queueFile As QueuedTransferFile) As DataLoad

        Dim survey As SurveyDataLoad
        Dim litho As LithoCode
        Dim badLithoCode As BadLitho
        Dim bubble As QuestionResult
        Dim cmnt As Comment
        Dim hand As HandEntry
        Dim map As PopMapping
        Dim dispo As Disposition
        Dim surveyMismatches As New List(Of Integer)
        Dim totalRecords As Integer = 0
        Dim totalDispositionRecords As Integer = 0


        'Create the DataLoad object
        Dim load As DataLoad = DataLoad.NewDataLoad
        With load
            .DateCreated = DateTime.Now
            .OrigFileName = queueFile.OriginalFileName
            .DisplayName = .OrigFileName
            .CurrentFilePath = queueFile.File.FullName
            .TranslationModuleId = queueFile.Translator.TranslationModuleId
            .VendorId = queueFile.Vendor.VendorId
            .ShowInTree = True
            .Save()
        End With

        'Validate the loaded file
        For Each surveyRow As DataRow In loadSet.Tables("Survey").Rows
            'Add the SurveyDataLoad object
            survey = SurveyDataLoad.NewSurveyDataLoad
            With survey
                .DataLoadId = load.DataLoadId
                .DateCreated = DateTime.Now
                .SurveyId = CInt(surveyRow("SurveyID"))
                .Save()
            End With
            load.Surveys.Add(survey)

            For Each respondentRow As DataRow In surveyRow.GetChildRows("SurveyRespondent")
                'Increment the counter
                totalRecords += 1

                'Add the LithoCode object
                litho = LithoCode.NewLithoCode
                With litho
                    .LithoCode = respondentRow("LithoCode").ToString
                    .ResponseType = respondentRow("ResponseType").ToString
                    If respondentRow.IsNull("SurveyLang") Then
                        .SurveyLang = Nothing
                    Else
                        .SurveyLang = CInt(respondentRow("SurveyLang"))
                    End If
                    .DateCreated = DateTime.Now
                    .GetAdditionalInfo()
                End With

                'Check to see if the LithoCode was found in QualiSys
                If Not litho.IsValidLithoCode Then
                    'We were unable to find some or all data for this litho so add it to the bad lithos
                    badLithoCode = BadLitho.NewBadLitho
                    With badLithoCode
                        .DataLoadId = load.DataLoadId
                        .BadLithoCode = litho.LithoCode
                        .DateCreated = DateTime.Now
                        .Save()
                    End With
                    load.BadLithoCodes.Add(badLithoCode)
                Else
                    If litho.SurveyId <> survey.SurveyId Then
                        'This is a SurveyID mismatch
                        litho.ErrorId = TransferErrorCodes.SurveyIdMismatch

                        'Add this SurveyID and the litho SurveyID to the list of SurveyIDs to lock
                        If Not surveyMismatches.Contains(survey.SurveyId) Then surveyMismatches.Add(survey.SurveyId)
                        If Not surveyMismatches.Contains(litho.SurveyId) Then surveyMismatches.Add(litho.SurveyId)
                    End If

                    'Add this litho to the collection
                    survey.LithoCodes.Add(litho)

                    'Process the disposition codes
                    For Each dispoRow As DataRow In respondentRow.GetChildRows("RespondentDisposition")
                        'Add the Disposition object
                        If Not String.IsNullOrEmpty(dispoRow("Code").ToString) OrElse Not IsDBNull(dispoRow("Date")) OrElse Not IsDBNull(dispoRow("IsFinal")) Then
                            'At least one of the three columns has data so lets create the disposition object
                            dispo = Disposition.NewDisposition
                            With dispo
                                .VendorDispositionCode = dispoRow("Code").ToString
                                If IsDate(dispoRow("Date")) Then
                                    .DispositionDate = CDate(dispoRow("Date"))
                                Else
                                    .DispositionDate = Date.MinValue
                                End If
                                If Not Boolean.TryParse(dispoRow("IsFinal").ToString, .IsFinal) Then
                                    .IsFinal = False
                                End If
                            End With
                            litho.Dispositions.Add(dispo)
                        End If
                    Next

                    'Process the bubble data
                    For Each bubbleRow As DataRow In respondentRow.GetChildRows("RespondentBubble")

                        Dim bubbleValue As String

                        bubbleValue = ReplaceValue(queueFile.Translator.ModuleName, bubbleRow("Value").ToString, {"-7", "-8", "-9"}, String.Empty)

                        'Add the QuestionResult object
                        bubble = QuestionResult.NewQuestionResult
                        With bubble
                            .QstnCore = CInt(bubbleRow("QstnCore"))
                            .ResponseVal = bubbleValue
                            .MultipleResponse = CBool(bubbleRow("MultipleResponse"))
                            .DateCreated = DateTime.Now
                        End With
                        litho.QuestionResults.Add(bubble)
                    Next

                    'Process the comment data
                    For Each commentRow As DataRow In respondentRow.GetChildRows("RespondentComment")
                        'Add the Comment object
                        If Not String.IsNullOrEmpty(commentRow("Value").ToString) Then

                            Dim commentValue As String

                            commentValue = ReplaceValue(queueFile.Translator.ModuleName, commentRow("Value").ToString, {"-8"}, String.Empty)

                            If Not String.IsNullOrEmpty(commentValue) Then

                                cmnt = Comment.NewComment
                                With cmnt
                                    .CmntNumber = CInt(commentRow("CmntID"))
                                    .CmntText = CleanString(commentValue, False, False)
                                End With
                                litho.Comments.Add(cmnt)
                            End If
                        End If
                    Next

                    'Process the handentry data
                    For Each handRow As DataRow In respondentRow.GetChildRows("RespondentHandEntry")
                        'Add the HandEntry object
                        If Not String.IsNullOrEmpty(handRow("Value").ToString) Then
                            Dim handValue As String

                            handValue = ReplaceValue(queueFile.Translator.ModuleName, handRow("Value").ToString, {"-7"}, String.Empty)

                            If Not String.IsNullOrEmpty(handValue) Then
                                hand = HandEntry.NewHandEntry
                                With hand
                                    .QstnCore = CInt(handRow("QstnCore"))
                                    .ItemNumber = CInt(handRow("Item"))
                                    .LineNumber = CInt(handRow("Line"))
                                    .HandEntryText = CleanString(handValue, True, False)
                                End With
                                litho.HandEntries.Add(hand)
                            End If
                        End If
                    Next

                    'Process the pop mapping data
                    For Each mapRow As DataRow In respondentRow.GetChildRows("RespondentPopMapping")
                        'Add the pop mapping object
                        If Not String.IsNullOrEmpty(mapRow("Value").ToString) Then
                            map = PopMapping.NewPopMapping
                            With map
                                .QstnCore = CInt(mapRow("PopMappingID"))
                                .PopMappingText = CleanString(mapRow("Value").ToString, True, False)
                            End With
                            litho.PopMappings.Add(map)
                        End If
                    Next

                    'Determine if this is a disposition update only
                    If litho.IsDispositionOnly(queueFile.Vendor.NoResponseChar.ToUpper, queueFile.Vendor.DontKnowResponseChar, queueFile.Vendor.RefusedResponseChar) Then
                        litho.DispositionUpdate = True
                        totalDispositionRecords += 1
                    Else
                        litho.DispositionUpdate = False
                    End If
                End If
            Next
        Next

        'Loop through all surveys
        For Each survey In load.Surveys
            'Mark every LithoCode in all Surveys that have been tagged as surveyMismatches
            For Each litho In survey.LithoCodes
                If litho.ErrorId <> TransferErrorCodes.SurveyIdMismatch AndAlso (surveyMismatches.Contains(survey.SurveyId) OrElse surveyMismatches.Contains(litho.SurveyId)) Then
                    litho.ErrorId = TransferErrorCodes.SurveyIdMismatch
                End If
            Next

            'Validate this survey's data
            survey.ValidateAndSave(QSIServiceNames.QSITransferResultsService)
        Next

        'Update the counts for the data load
        With load
            .TotalRecordsLoaded = totalRecords
            .TotalDispositionUpdateRecords = totalDispositionRecords
            .Save()
        End With

        'Return the DataLoad
        Return load

    End Function

    Protected Function ReplaceValue(ByVal moduleName As String, ByVal origVal As String, ByVal arrayOfTargetValues() As String, ByVal replWith As String) As String

        Dim returnVal As String = origVal

        ' only check to see if we need to replace if translator is TranslatorTABCCAC
        Select Case moduleName
            Case "TranslatorTABCCAC"
                If Array.IndexOf(arrayOfTargetValues, origVal.Trim()) >= 0 Then
                    returnVal = replWith
                End If
        End Select

        Return returnVal

    End Function

#End Region

#Region " Public Shared Methods "

    Public Shared Function GetFirstNonEmptyDataRow(ByVal table As DataTable) As DataRow

        Dim newRow As DataRow = Nothing

        For Each row As DataRow In table.Rows
            If Not IsDataRowEmpty(row) Then
                newRow = row
                Exit For
            End If
        Next

        Return newRow

    End Function

    Public Shared Function SendNotification(ByVal serviceName As String, ByVal errMessage As String, ByVal errEx As Exception, ByVal logOnly As Boolean) As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim fileName As String = String.Empty
        Dim exceptionText As String = String.Empty
        Dim exceptionHtml As String = String.Empty
        Dim sqlCommand As String = String.Empty
        Dim stackHtml As String = String.Empty
        Dim stackText As String = String.Empty
        Dim innerStackHtml As String = String.Empty
        Dim innerStackText As String = String.Empty
        Dim bodyText As String = String.Empty

        Try
            'Determine who the recipients are going to be
            toList.Add("TransferResultsErrors@NRCPicker.com")
            bccList.Add("Testing@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production OrElse logOnly Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Deal with InvalidFileException
            If TypeOf errEx Is InvalidFileException Then
                Dim fileEx As InvalidFileException = DirectCast(errEx, InvalidFileException)
                fileName = String.Format("{0}{1}{0}", Chr(34), fileEx.FileName)
                exceptionText = fileEx.Message & TranslatorError.GetErrorTableText(fileEx.ErrorList)
                exceptionHtml = fileEx.Message.Replace(vbCrLf, "<BR>") & TranslatorError.GetErrorTableHtml(fileEx.ErrorList)
            Else
                fileName = "N/A"
                exceptionText = errEx.Message
                exceptionHtml = errEx.Message.Replace(vbCrLf, "<BR>")
            End If

            'Build the SQL Command string
            If TypeOf errEx Is Nrc.Framework.Data.SqlCommandException Then
                sqlCommand = DirectCast(errEx, Nrc.Framework.Data.SqlCommandException).CommandText
            Else
                sqlCommand = "N/A"
            End If

            'Build the stack trace strings
            If errEx.StackTrace IsNot Nothing Then
                stackText = errEx.StackTrace

                stackHtml = errEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at")
                If (stackHtml.StartsWith("<BR>&nbsp;&nbsp;at")) Then
                    stackHtml = stackHtml.Substring("<BR>".Length)
                End If
            Else
                stackText = "N/A"
                stackHtml = "N/A"
            End If

            'Build the inner exception strings
            If errEx.InnerException IsNot Nothing Then
                Dim innerEx As Exception = errEx.InnerException
                Do While innerEx IsNot Nothing
                    'Text version

                    'HTML version
                    If innerStackText.Length > 0 Then
                        innerStackText &= vbCrLf
                        innerStackHtml &= "<BR>"
                    End If

                    If innerEx.Message IsNot Nothing OrElse innerEx.StackTrace IsNot Nothing Then
                        innerStackText &= "--------Inner Exception--------" & vbCrLf
                        innerStackHtml &= "--------Inner Exception--------" & "<BR>"

                        If innerEx.Message IsNot Nothing Then
                            innerStackText &= innerEx.Message & vbCrLf
                            innerStackHtml &= innerEx.Message.Replace(vbCrLf, "<BR>") & "<BR>"
                        End If

                        If innerEx.StackTrace IsNot Nothing Then
                            innerStackText &= innerEx.StackTrace & vbCrLf
                            innerStackHtml &= innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") & "<BR>"
                        End If
                    End If

                    'Prepare for next pass
                    innerEx = innerEx.InnerException
                Loop
            Else
                innerStackText = "N/A"
                innerStackHtml = "--------Inner Exception--------<BR>N/A<BR>-------------------------------"
            End If

            'Create the message object
            Dim msg As Message = New Message("TransferResultsServiceException", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("ServiceName", serviceName)
                    .Add("Environment", environmentName)
                    .Add("Message", errMessage)
                    .Add("DateOccurred", DateTime.Now.ToString)
                    .Add("MachineName", Environment.MachineName)
                    .Add("FileName", fileName)
                    .Add("ExceptionText", exceptionText)
                    .Add("ExceptionHtml", exceptionHtml)
                    .Add("Source", errEx.Source)
                    .Add("SQLCommand", sqlCommand)
                    .Add("StackTraceHtml", stackHtml)
                    .Add("StackTraceText", stackText)
                    .Add("InnerExceptionHtml", innerStackHtml & recipientNoteHtml)
                    .Add("InnerExceptionText", innerStackText & recipientNoteText)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            bodyText = msg.BodyText

            'Send the message
            If Not logOnly Then msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send Exception Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Original Exception{0}{0}{4}{0}{0}Source: {5}{0}{0}Stack Trace:{0}{6}{0}{0}Email Exception{0}{0}{7}", vbCrLf, ex.Message, ex.Source, ex.StackTrace, errEx.Message, errEx.Source, errEx.StackTrace, bodyText)

        End Try

    End Function

#End Region

#Region " Protected Shared Methods "

    Protected Shared Function IsQuestionColumn(ByVal columnName As String) As Boolean

        Dim qstnCore As Integer
        Dim multiResponse As Boolean

        Return IsQuestionColumn(columnName, qstnCore, multiResponse)

    End Function

    Protected Shared Function IsQuestionColumn(ByVal columnName As String, ByRef qstnCore As Integer) As Boolean

        Dim multiResponse As Boolean

        Return IsQuestionColumn(columnName, qstnCore, multiResponse)

    End Function

    Protected Shared Function IsQuestionColumn(ByVal columnName As String, ByRef qstnCore As Integer, ByRef multiResponse As Boolean) As Boolean

        If columnName.ToUpper.StartsWith("Q") Then
            'This might be a question column
            If IsNumeric(columnName.Substring(1)) Then
                'This is a single response question
                qstnCore = CInt(columnName.Substring(1))
                multiResponse = False
                Return True
            ElseIf IsNumeric(columnName.Substring(1, columnName.Length - 2)) AndAlso _
                   CStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ").IndexOf(columnName.ToUpper.Substring(columnName.Length - 1)) >= 0 Then
                'This is a multiple response question
                qstnCore = CInt(columnName.Substring(1, columnName.Length - 2))
                multiResponse = True
                Return True
            End If
        End If

        Return False

    End Function

    Protected Shared Function IsCommentColumn(ByVal columnName As String) As Boolean

        Dim cmntID As Integer

        Return IsCommentColumn(columnName, cmntID)

    End Function

    Protected Shared Function IsCommentColumn(ByVal columnName As String, ByRef cmntID As Integer) As Boolean

        If columnName.ToUpper.StartsWith("C") AndAlso IsNumeric(columnName.Substring(1)) Then
            'This is a comment column
            cmntID = CInt(columnName.Substring(1))
            Return True
        End If

        Return False

    End Function

    Protected Shared Function IsHandEntryColumn(ByVal columnName As String) As Boolean

        Dim qstnCore As Integer
        Dim itemColumn As String = String.Empty
        Dim line As Integer

        Return IsHandEntryColumn(columnName, qstnCore, itemColumn, line)

    End Function

    Protected Shared Function IsHandEntryColumn(ByVal columnName As String, ByRef qstnCore As Integer, ByRef itemColumn As String, ByRef line As Integer) As Boolean

        If columnName.ToUpper.StartsWith("H") AndAlso IsNumeric(columnName.Substring(1)) Then
            'This is a hand entry column on a single response question
            qstnCore = CInt(columnName.Substring(1))
            itemColumn = String.Format("Q{0}", columnName.Substring(1))
            line = 1
            Return True
        ElseIf columnName.ToUpper.StartsWith("H") AndAlso IsAllAlpha(columnName.Substring(columnName.Length - 1)) AndAlso IsNumeric(columnName.Substring(1, columnName.Length - 2)) Then
            'This is a hand entry column on a multiple response question
            qstnCore = CInt(columnName.Substring(1, columnName.Length - 2))
            itemColumn = String.Format("Q{0}", columnName.Substring(1))
            line = 1
            Return True
        End If

        Return False

    End Function

    Protected Shared Function IsPopMappingColumn(ByVal columnName As String) As Boolean

        Dim popMappingID As Integer

        Return IsPopMappingColumn(columnName, popMappingID)

    End Function

    Protected Shared Function IsPopMappingColumn(ByVal columnName As String, ByRef popMappingID As Integer) As Boolean

        If columnName.ToUpper.StartsWith("M") AndAlso IsNumeric(columnName.Substring(1)) Then
            'This is a pop mapping column
            popMappingID = CInt(columnName.Substring(1))
            Return True
        End If

        Return False

    End Function

    Protected Shared Function IsDataTableEmpty(ByVal table As DataTable) As Boolean

        For Each row As DataRow In table.Rows
            If Not IsDataRowEmpty(row) Then
                Return False
            End If
        Next

        Return True

    End Function

    Protected Shared Function IsDataRowEmpty(ByVal row As DataRow) As Boolean

        For Each item As Object In row.ItemArray
            If Not IsDBNull(item) AndAlso Not String.IsNullOrEmpty(item.ToString.Trim) Then
                Return False
            End If
        Next

        Return True

    End Function

    

#End Region

End Class
