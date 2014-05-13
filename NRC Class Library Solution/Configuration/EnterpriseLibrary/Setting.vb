Imports System.Xml.Serialization

Namespace Configuration.EnterpriseLibrary

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : Configuration.EnterpriseLibrary.Setting
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a name-value pair configuration setting
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <Serializable()> Public Class Setting

#Region " Private Members "
        Private mName As String
        Private mValue As String
#End Region

#Region " Public Properties "
        <XmlAttributeAttribute("name")> _
        Public Property Name() As String
            Get
                Return mName
            End Get
            Set(ByVal Value As String)
                mName = Value
            End Set
        End Property

        <XmlAttributeAttribute("value")> _
        Public Property Value() As String
            Get
                Return mValue
            End Get
            Set(ByVal Value As String)
                mValue = Value
            End Set
        End Property
#End Region

#Region " Constructors "
        Sub New()
        End Sub

        Sub New(ByVal name As String, ByVal value As String)
            mName = name
            mValue = value
        End Sub
#End Region

    End Class
End Namespace