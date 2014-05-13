Public Class clsPopValue

    Private mstrSourceField As String = ""
    Private mstrPopField As String = ""
    Private mstrValue As String = ""

    Public Enum enuTruncateDialogOptions
        enuTDOFits = 1
        enuTDOTruncatePreSelected = 2
        enuTDOTruncateLithoOnlyFieldOnly = 3
        enuTDOTruncateLithoAllFieldOnly = 4
        enuTDOTruncateLithoAllFieldAll = 5
        enuTDOEdited = 6
        enuTDOStopProcessing = 7
    End Enum

    Public Sub New(ByVal strSourceField As String, ByVal strPopField As String, ByVal strValue As String)

        'Save the property values
        mstrSourceField = strSourceField
        mstrPopField = strPopField
        mstrValue = strValue.Trim

    End Sub

    Public ReadOnly Property SourceField() As String
        Get
            Return mstrSourceField
        End Get
    End Property

    Public ReadOnly Property PopField() As String
        Get
            Return mstrPopField
        End Get
    End Property

    Public ReadOnly Property Value() As String
        Get
            Return mstrValue
        End Get
    End Property

    Public ReadOnly Property SetClause() As String
        Get
            If mstrValue.Length = 0 Then
                Return mstrPopField & " = NULL"
            Else
                Return mstrPopField & " = '" & mstrValue & "'"
            End If
        End Get
    End Property

    Private ReadOnly Property MaxLength() As Integer
        Get
            Return CType(Globals.gobjMetaFields.Item(mstrPopField), clsMetaField).FieldLength
        End Get
    End Property

    Private ReadOnly Property Truncate() As Boolean
        Get
            Return CType(Globals.gobjMetaFields.Item(mstrPopField), clsMetaField).Truncate
        End Get
    End Property

    Public Function DisplayTruncateDialog(ByVal strLithoCode As String) As enuTruncateDialogOptions

        If mstrValue.Length <= MaxLength Then
            'The value fits in the field
            Return enuTruncateDialogOptions.enuTDOFits
        ElseIf Truncate Then
            'The value does not fit in the field but the user has already chosen to truncate
            mstrValue = mstrValue.Substring(0, MaxLength)
            Return enuTruncateDialogOptions.enuTDOTruncatePreSelected
        Else
            'The value does not fit so we will ask the user what to do
            Dim objTruncateForm As frmPopError = New frmPopError(strLithoCode:=strLithoCode, _
                                                                 strFieldName:=mstrPopField, _
                                                                 intFieldLength:=MaxLength, _
                                                                 strFieldValue:=mstrValue)
            If objTruncateForm.ShowDialog() = DialogResult.Abort Then
                'The user has chosen to stop processing this file
                Return enuTruncateDialogOptions.enuTDOStopProcessing
            Else
                'Let's determine what the user wants to do
                Select Case objTruncateForm.TruncateType
                    Case enuTruncateDialogOptions.enuTDOTruncateLithoOnlyFieldOnly
                        mstrValue = mstrValue.Substring(0, MaxLength)
                        Return enuTruncateDialogOptions.enuTDOTruncateLithoOnlyFieldOnly

                    Case enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldOnly
                        mstrValue = mstrValue.Substring(0, MaxLength)
                        CType(Globals.gobjMetaFields.Item(mstrPopField), clsMetaField).Truncate = True
                        Return enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldOnly

                    Case enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldAll
                        mstrValue = mstrValue.Substring(0, MaxLength)

                        'Loop through all metafields and set the Truncate property
                        Dim objMetaField As clsMetaField
                        For Each objMetaField In Globals.gobjMetaFields
                            objMetaField.Truncate = True
                        Next
                        Return enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldAll

                    Case enuTruncateDialogOptions.enuTDOEdited
                        mstrValue = objTruncateForm.txtFieldValue.Text
                        Return enuTruncateDialogOptions.enuTDOEdited

                End Select
            End If

            'Cleanup the form
            objTruncateForm.Dispose()

        End If
    End Function

End Class
