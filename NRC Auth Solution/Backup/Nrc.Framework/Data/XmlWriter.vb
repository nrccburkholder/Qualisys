Imports System.Xml
Imports System.Text

Namespace Data

    Public Class XmlWriter
        Inherits Nrc.Framework.Data.DataWriter

#Region " Private Members "
        Private mWriter As XmlTextWriter
        Private mRootElementName As String
        Private mRecordElementName As String
#End Region

#Region " Constructors "
        Public Sub New(ByVal reader As IDataReader, ByVal rootElementName As String, ByVal recordElementName As String)
            MyBase.New(reader)
            mRootElementName = rootElementName
            mRecordElementName = recordElementName
        End Sub

        Public Sub New(ByVal table As DataTable, ByVal rootElementName As String, ByVal recordElementName As String)
            MyBase.New(table)
            mRootElementName = rootElementName
            mRecordElementName = recordElementName
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

            mWriter = New XmlTextWriter(Me.FilePath, Encoding.UTF8)
            mWriter.Formatting = Formatting.Indented

            'Start the document
            mWriter.WriteStartDocument()

            'Write root element
            mWriter.WriteStartElement(Me.mRootElementName)
        End Sub

        Protected Overrides Sub WriteRow(ByVal reader As System.Data.IDataReader)
            'Start the record element
            mWriter.WriteStartElement(Me.mRecordElementName)
            For i As Integer = 0 To Me.Columns.Count - 1
                'Write the column name
                mWriter.WriteStartElement(Me.Columns(i).Name)

                'Write the value
                mWriter.WriteString(reader(Me.Columns(i).Ordinal).ToString.Trim)

                'End the column element
                mWriter.WriteEndElement()
            Next
            'End the record element
            mWriter.WriteEndElement()
        End Sub

        Protected Overrides Sub EndWrite(ByVal recordsWritten As Integer)
            MyBase.EndWrite(recordsWritten)

            'End the root element
            mWriter.WriteEndElement()

            'End the document
            mWriter.WriteEndDocument()

            If mWriter IsNot Nothing Then
                mWriter.Flush()
                mWriter.Close()
            End If
        End Sub

    End Class

End Namespace
