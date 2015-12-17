Namespace Miscellaneous

    Public Class ADO_AccessLayer

        Public Shared Function DBCommandExecuteScalar(ByVal DBCommandObject As Data.Common.DbCommand) As Object
            Return DBCommandExecuteScalar(DBCommandObject, 3, 30)
        End Function

        Public Shared Function DBCommandExecuteScalar(ByVal DBCommandObject As Data.Common.DbCommand, ByVal DBRetryCount As Integer, ByVal DBRetryInterval As Integer) As Object
            Dim iCounter As Integer

            Do While iCounter < DBRetryCount Or DBRetryCount < 0
                Try
                    Return DBCommandObject.ExecuteScalar()
                Catch ex As Exception
                    If iCounter < DBRetryCount Then
                        iCounter += 1
                        Exit Try
                    End If
                    ex.Data("ADO_AccessLayer::DBExecuteScalar::SQL") = DBCommandObject.CommandText
                    Throw
                End Try
                If DBRetryInterval > 0 Then
                    System.Threading.Thread.Sleep(New TimeSpan(0, 0, DBRetryInterval))
                End If
            Loop

            Return Nothing
        End Function

        Public Shared Function DBCommandExecuteReader(ByVal DBCommandObject As Data.Common.DbCommand) As Data.Common.DbDataReader
            Return DBCommandExecuteReader(DBCommandObject, 3, 30)
        End Function

        Public Shared Function DBCommandExecuteReader(ByVal DBCommandObject As Data.Common.DbCommand, ByVal DBRetryCount As Integer, ByVal DBRetryInterval As Integer) As Data.Common.DbDataReader

            Dim iCounter As Integer = 0

            Do While iCounter < DBRetryCount Or DBRetryCount < 0
                Try
                    Return DBCommandObject.ExecuteReader()
                Catch ex As Exception
                    If iCounter < DBRetryCount Then
                        iCounter += 1
                        Exit Try
                    End If
                    ex.Data("ADO_AccessLayer::DBCommandExecuteReader::SQL") = DBCommandObject.CommandText
                    Throw
                End Try
                If DBRetryInterval > 0 Then
                    System.Threading.Thread.Sleep(New TimeSpan(0, 0, DBRetryInterval))
                End If
            Loop

            Return Nothing
        End Function

        Public Shared Function DBCommandExecuteNonQuery(ByVal DBCommandObject As Data.Common.DbCommand) As Integer
            Return DBCommandExecuteNonQuery(DBCommandObject, 3, 30)
        End Function

        Public Shared Function DBCommandExecuteNonQuery(ByVal DBCommandObject As Data.Common.DbCommand, ByVal DBRetryCount As Integer, ByVal DBRetryInterval As Integer) As Integer
            Dim iCounter As Integer = 0

            Do While iCounter < DBRetryCount Or DBRetryCount < 0
                Try
                    Return DBCommandObject.ExecuteNonQuery()
                Catch ex As Exception
                    If iCounter < DBRetryCount Then
                        iCounter += 1
                        Exit Try
                    End If
                    ex.Data("ADO_AccessLayer::DBCommandExecuteNonQuery::SQL") = DBCommandObject.CommandText
                    Throw
                End Try
                If DBRetryInterval > 0 Then
                    System.Threading.Thread.Sleep(New TimeSpan(0, 0, DBRetryInterval))
                End If
            Loop

            Return 0

        End Function

    End Class

End Namespace