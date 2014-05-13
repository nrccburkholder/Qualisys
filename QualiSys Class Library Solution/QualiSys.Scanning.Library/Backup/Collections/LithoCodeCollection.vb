Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class LithoCodeCollection
    Inherits BusinessListBase(Of LithoCodeCollection, LithoCode)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As LithoCode = LithoCode.NewLithoCode
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    ''' <summary>This function converts the LithoCodeCollection to a datatable that has
    ''' a LithoCode column and also a colum for each answer. This is for representing
    ''' the data in a grid.</summary>
    Public Function GetBubbleDataTable(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As System.Data.DataTable

        Dim horizontalDataTable As New Data.DataTable
        Dim currentLitho As String = String.Empty
        Dim hasErrors As Boolean = False

        horizontalDataTable.Columns.Add("Litho Code", GetType(String))

        For Each litho As LithoCode In Me
            hasErrors = False
            currentLitho = litho.LithoCode
            Dim newRow As Data.DataRow = horizontalDataTable.Rows.Add(currentLitho)

            For Each result As QuestionResult In litho.QuestionResults
                'We may already have a column with that name if so use that one
                'otherwise create a new column
                If Not horizontalDataTable.Columns.Contains(result.QstnCore.ToString) Then
                    horizontalDataTable.Columns.Add(CStr(result.QstnCore), GetType(String))
                End If

                'Set the value of the answer cell to the response value
                If result.MultipleResponse Then
                    'Append a comma for the next multiple response value (create a comma separated list)
                    If newRow(result.QstnCore.ToString) Is DBNull.Value Then
                        'Take the First response as is
                        newRow(result.QstnCore.ToString) = result.ResponseVal.Trim()
                    Else
                        'the rest of multiple responses should be appended separated by commas
                        newRow(result.QstnCore.ToString) = String.Format("{0},{1}", CType(newRow(result.QstnCore.ToString), String), result.ResponseVal.Trim())
                    End If
                    If Not horizontalDataTable.Columns(result.QstnCore.ToString).ExtendedProperties.ContainsKey("MultipleResponse") Then
                        horizontalDataTable.Columns(result.QstnCore.ToString).ExtendedProperties.Add("MultipleResponse", True)
                    End If
                Else
                    newRow(result.QstnCore.ToString) = result.ResponseVal.Trim
                End If

                'If the answer has an error, set the cell error message to the error message with the ErrorID
                If result.ErrorId <> TransferErrorCodes.None Then
                    hasErrors = True
                    Dim existingError As String = String.Empty
                    If result.MultipleResponse Then
                        existingError = String.Format("{0}{1}", newRow.GetColumnError(result.QstnCore.ToString), vbCrLf)
                    End If
                    newRow.SetColumnError(result.QstnCore.ToString, String.Format("{0}{1}({2})", existingError, errorCodes.GetErrorDescriptionByErrorID(result.ErrorId), result.ResponseVal.Trim()))
                    newRow.RowError = "Bubble data associated with this litho contains errors."
                End If
            Next

            'If we need errored rows only and the row didn't have errors then remove it
            If Not hasErrors AndAlso errorsOnly Then
                horizontalDataTable.Rows.Remove(newRow)
            End If
        Next

        Return horizontalDataTable

    End Function

    Public Function GetLithoDisplayList(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As List(Of LithoCodeDisplay)

        Dim lithoList As New List(Of LithoCodeDisplay)

        For Each litho As LithoCode In Me
            If errorsOnly Then
                If litho.ErrorId <> TransferErrorCodes.None Then
                    lithoList.Add(New LithoCodeDisplay(litho, errorCodes))
                End If
            Else
                lithoList.Add(New LithoCodeDisplay(litho, errorCodes))
            End If
        Next

        Return lithoList

    End Function

    Public Function GetLithoCommentDisplayList(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As List(Of LithoCommentDisplay)

        Dim commentList As New List(Of LithoCommentDisplay)

        For Each litho As LithoCode In Me
            For Each cmnt As Comment In litho.Comments
                If errorsOnly Then
                    If cmnt.ErrorId <> TransferErrorCodes.None Then
                        commentList.Add(New LithoCommentDisplay(cmnt, litho.LithoCode, errorCodes))
                    End If
                Else
                    commentList.Add(New LithoCommentDisplay(cmnt, litho.LithoCode, errorCodes))
                End If
            Next
        Next

        Return commentList

    End Function

    Public Function GetLithoHandEntryDisplayList(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As List(Of LithoHandEntryDisplay)

        Dim handEntryList As New List(Of LithoHandEntryDisplay)

        For Each litho As LithoCode In Me
            For Each hand As HandEntry In litho.HandEntries
                If errorsOnly Then
                    If hand.ErrorId <> TransferErrorCodes.None Then
                        handEntryList.Add(New LithoHandEntryDisplay(hand, litho.LithoCode, errorCodes))
                    End If
                Else
                    handEntryList.Add(New LithoHandEntryDisplay(hand, litho.LithoCode, errorCodes))
                End If
            Next
        Next

        Return handEntryList

    End Function

    Public Function GetLithoPopMappingDisplayList(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As List(Of LithoPopMappingDisplay)

        Dim popMapList As New List(Of LithoPopMappingDisplay)

        For Each litho As LithoCode In Me
            For Each pop As PopMapping In litho.PopMappings
                If errorsOnly Then
                    If pop.ErrorId <> TransferErrorCodes.None Then
                        popMapList.Add(New LithoPopMappingDisplay(pop, litho.LithoCode, errorCodes))
                    End If
                Else
                    popMapList.Add(New LithoPopMappingDisplay(pop, litho.LithoCode, errorCodes))
                End If
            Next
        Next

        Return popMapList

    End Function

    Public Function GetLithoDispositionDisplayList(ByVal errorsOnly As Boolean, ByVal errorCodes As ErrorCodeCollection) As List(Of LithoDispositionDisplay)

        Dim dispositionList As New List(Of LithoDispositionDisplay)

        For Each litho As LithoCode In Me
            For Each dispo As Disposition In litho.Dispositions
                If errorsOnly Then
                    If dispo.ErrorId <> TransferErrorCodes.None Then
                        dispositionList.Add(New LithoDispositionDisplay(dispo, litho.LithoCode, errorCodes))
                    End If
                Else
                    dispositionList.Add(New LithoDispositionDisplay(dispo, litho.LithoCode, errorCodes))
                End If
            Next
        Next

        Return dispositionList

    End Function

    Public Function HasErrors() As Boolean

        For Each litho As LithoCode In Me
            If litho.ErrorId <> TransferErrorCodes.None Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function ErrorCount() As Integer

        Dim count As Integer = 0

        For Each litho As LithoCode In Me
            If litho.ErrorId <> TransferErrorCodes.None Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

End Class