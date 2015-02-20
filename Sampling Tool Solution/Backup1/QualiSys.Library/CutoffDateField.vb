Public Class CutoffDateField

    Private mCutoffDateFieldType As CutoffFieldType
    Public ReadOnly Property CutoffDateFieldType() As CutoffFieldType
        Get
            Return mCutoffDateFieldType
        End Get
    End Property

    Private mStudyTable As StudyTable
    Public ReadOnly Property StudyTable() As StudyTable
        Get
            Return mStudyTable
        End Get
    End Property

    Private mStudyTableColumn As StudyTableColumn
    Public ReadOnly Property StudyTableColumn() As StudyTableColumn
        Get
            Return mStudyTableColumn
        End Get
    End Property

    Public Overrides Function ToString() As String
        Select Case Me.mCutoffDateFieldType
            Case CutoffFieldType.NotApplicable
                Return "Not Applicable"
            Case CutoffFieldType.SampleCreate
                Return "Survey Sent Date"
            Case CutoffFieldType.ReturnDate
                Return "Survey Return Date"
            Case CutoffFieldType.CustomMetafield
                Return mStudyTable.Name & "." & mStudyTableColumn.Name
            Case Else
                Return Nothing
        End Select
    End Function

    Public Sub New(ByVal dateFieldType As CutoffFieldType)
        If (dateFieldType = CutoffFieldType.NotApplicable OrElse _
            dateFieldType = CutoffFieldType.SampleCreate OrElse _
            dateFieldType = CutoffFieldType.ReturnDate) Then
            Me.mCutoffDateFieldType = dateFieldType
        Else
            Throw New ApplicationException("This constructor only accepts date field types of ""Survey Sent Date"" and ""Survey Return Date""")
        End If
    End Sub

    Public Sub New(ByVal studyTable As StudyTable, ByVal studyTableColumn As StudyTableColumn)
        Me.mCutoffDateFieldType = CutoffFieldType.CustomMetafield
        Me.mStudyTable = studyTable
        Me.mStudyTableColumn = studyTableColumn
    End Sub

    Public Sub New(ByVal dateFieldType As CutoffFieldType, ByVal studyTable As StudyTable, ByVal studyTableColumn As StudyTableColumn)
        If (dateFieldType = CutoffFieldType.SampleCreate OrElse _
            dateFieldType = CutoffFieldType.ReturnDate) Then
            Me.mCutoffDateFieldType = dateFieldType
        Else
            Me.mCutoffDateFieldType = CutoffFieldType.CustomMetafield
            Me.mStudyTable = studyTable
            Me.mStudyTableColumn = studyTableColumn
        End If
    End Sub

End Class
