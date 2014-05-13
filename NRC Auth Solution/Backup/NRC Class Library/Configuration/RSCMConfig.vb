Imports System.Configuration
Imports System.Xml

Namespace Configuration

    Public Class RSCMConfig

#Region " Private Members "
        Private Shared mInstance As RSCMConfig
        Private mConnectionString As String

#End Region

#Region " Public Properties "
        Public Shared ReadOnly Property Instance() As RSCMConfig
            Get
                If mInstance Is Nothing Then
                    mInstance = DirectCast(ConfigurationSettings.GetConfig("RSCM"), RSCMConfig)
                End If

                Return mInstance
            End Get
        End Property

        Public ReadOnly Property ConnectionString() As String
            Get
                Return mConnectionString
            End Get
        End Property
#End Region

        Public Shared Function FromXML(ByVal node As XmlNode) As RSCMConfig
            Dim all As New Hashtable
            Dim host As String = System.Web.HttpContext.Current.Request.Url.Host.ToLower

            Dim config As New RSCMConfig
            For Each child As XmlNode In node.ChildNodes
                Select Case child.Name.ToLower
                    Case "connectionstring"
                        all.Add(child.Attributes("environment").Value.ToLower, GetConString(child))
                        'config.mConnectionString = GetConString(child)
                End Select
            Next

            config.mConnectionString = all(host)
            If config.mConnectionString Is Nothing OrElse config.mConnectionString.Length = 0 Then
                Throw New ApplicationException("Connection String not defined.")
            End If


            Return config
        End Function

        Private Shared Function GetConString(ByVal node As XmlNode) As String
            Dim con As Web.ConnectionString

            If node.Attributes("isEncrypted").Value.ToLower = "true" Then
                con = New Web.ConnectionString(node.Attributes("value").Value)
                Return con.DecryptedString
            Else
                Return node.Attributes("value").Value
            End If
        End Function

    End Class

End Namespace
