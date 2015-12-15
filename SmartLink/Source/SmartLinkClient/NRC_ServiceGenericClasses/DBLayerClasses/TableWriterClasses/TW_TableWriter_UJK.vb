Option Explicit On

Namespace Miscellaneous.TableWriters
    ''' ********************************************************************'
    ''' Created by: Elibad
    ''' Created Date: 2008/06/01
    ''' *********************************************************************
    ''' <summary>
    ''' This class is the base for any UJK table writer
    ''' </summary>
    ''' <remarks>
    ''' All the SQL code is delegated to any database implementation of this class
    ''' 
    ''' Any table writer that needs this type of structure should derive from this class and implement the code necesary to write to an specific type of database.
    ''' </remarks>
    Public MustInherit Class TableWriter_UJK
        Inherits TableWriter

        ''' <summary>
        ''' Generates the SQL to retrieve an UJK value using the fields specified in the list
        ''' </summary>
        Protected MustOverride Overloads Function RetrievePK(ByVal UIDEntry As KeyValuePair(Of String, String())) As String

        Private _sUJK As String
        Private _sSourceAgencyName As String

        'Protected MustOverride Function SelectUJK_SQL() As String

        ''' <summary>
        ''' Retrieves the UJK from a different table and assings the key to the specified field in the current table
        ''' </summary>
        ''' <param name="SourceID">Key value of the record in the table in the source database</param>
        ''' <param name="TableName">Name of the table where the UJK will be retrieved</param>
        Public MustOverride Function PopulateForeignUJK(ByVal SourceID As String, ByVal TableName As String) As Boolean


        ''' <summary>
        ''' Name of the main agency the information belongs to
        ''' </summary>
        Public Property SourceAgencyName() As String
            Get
                Return _sSourceAgencyName
            End Get
            Set(ByVal value As String)
                _sSourceAgencyName = value
            End Set
        End Property

        ''' <summary>
        ''' Retrieves the Primary Key from the table if the record already exists
        ''' </summary>
        ''' ***************************************************************************************
        '''   This method checks weather the record will update table or be inserted into it.    *
        '''   It also stores the UJK if for the record to updated if it finds one.               *
        '''   Input strID: The value for the ID field (passed in through the write method)       *
        '''   Output: True  - when the idd is in the table                                       *
        '''           False - when the id is not in the table                                    *
        ''' ***************************************************************************************
        Protected Overrides Function RetrievePK() As String

            'Dim strSQL As String
            'Dim cmd As Data.Common.DbCommand
            Dim sResult As String

            Me.OpenConnection()

            'cmd = Me._DBConn.CreateCommand()

            If _colRecordUID.Count > 0 Then
                For Each UIDEntry As KeyValuePair(Of String, String()) In _colRecordUID
                    sResult = Me.RetrievePK(UIDEntry)

                    If sResult <> "" Then
                        Return sResult
                    End If
                Next
                'Else
                '    strSQL = Me.SelectUJK_SQL()

                '    If strSQL = String.Empty Then
                '        Return String.Empty
                '    End If

                '    cmd.CommandText = strSQL

                '    Return CType(Me.SQLRunner.ExecuteScalar(cmd), String)
            End If

            Return String.Empty
        End Function

        Public Sub New(ByVal TableName As String, Optional ByVal UJKFieldName As String = "")
            MyBase.New(TableName)

            If UJKFieldName = String.Empty Then
                _sPKFieldName = TableName & "_UJK"
            Else
                _sPKFieldName = UJKFieldName
            End If
        End Sub

        Protected Overrides Function GeneratePKValue() As String
            If Me.Item(Me.PKFieldName).FormatType.ToUpper.Contains("GUID") Then
                Return System.Guid.NewGuid().ToString()
            ElseIf Me.Item(Me.PKFieldName).FormatType.ToUpper.Contains("CHAR") Then
                Return UJK_Generator.GenerateUJK()
            End If

            Return ""
        End Function

    End Class
End Namespace

