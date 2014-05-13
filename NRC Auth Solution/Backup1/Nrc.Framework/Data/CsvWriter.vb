Imports System.Text
Imports System.IO

Namespace Data

    Public Class CsvWriter
        Inherits DataWriter

#Region " Private Members "
        Private mWriter As System.IO.StreamWriter

#End Region

#Region " Constructors "
        Public Sub New(ByVal reader As IDataReader)
            MyBase.New(reader)
        End Sub

        Public Sub New(ByVal table As DataTable)
            MyBase.New(table)
        End Sub
#End Region

#Region " Protected Properties "
        Protected Overrides ReadOnly Property ColumnNameMaxLength() As Integer
            Get
                Return Integer.MaxValue
            End Get
        End Property

#End Region

        Protected Overrides Sub BeginWrite()
            MyBase.BeginWrite()

            mWriter = New StreamWriter(Me.FilePath, False, Encoding.Default)

            Dim header As New StringBuilder
            For i As Integer = 0 To Me.Columns.Count - 1
                If i > 0 Then
                    header.Append(",")
                End If

                header.AppendFormat("""{0}""", Me.Columns(i).Name)
            Next

            mWriter.WriteLine(header.ToString)
        End Sub

        Protected Overrides Sub WriteRow(ByVal reader As System.Data.IDataReader)
            For i As Integer = 0 To Me.Columns.Count - 1
                If i > 0 Then
                    mWriter.Write(",")
                End If

                If Me.Columns(i).DataType = "System.String" Then
                    mWriter.Write("""{0}""", reader(Me.Columns(i).Ordinal).ToString.Trim)
                Else
                    mWriter.Write(reader(Me.Columns(i).Ordinal).ToString.Trim)
                End If
            Next

            mWriter.WriteLine()
        End Sub

        Protected Overrides Sub EndWrite(ByVal recordsWritten As Integer)
            MyBase.EndWrite(recordsWritten)

            If mWriter IsNot Nothing Then
                mWriter.Flush()
                mWriter.Close()
            End If
        End Sub

    End Class

End Namespace
