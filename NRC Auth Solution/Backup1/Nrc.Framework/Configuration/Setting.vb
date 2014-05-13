Imports System.Xml.Serialization

Namespace Configuration

    '''' <summary>Represents a name-value pair configuration setting</summary>
    <Serializable()> _
    Public Class Setting

#Region " Private Members "
        Private Shared mKeyData As Byte()
        Private Shared mVectorData As Byte()
        Private Shared mCryptoHelper As Nrc.Framework.Security.CryptoHelper

        Private mName As String
        Private mValue As String
        Private mIsEncrypted As Boolean
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

        <XmlAttribute("isEncrypted")> _
        Public Property IsEncrypted() As Boolean
            Get
                Return mIsEncrypted
            End Get
            Set(ByVal value As Boolean)
                mIsEncrypted = value
            End Set
        End Property

        <XmlIgnore()> _
        Public ReadOnly Property PlainValue() As String
            Get
                If mIsEncrypted Then
                    Return mCryptoHelper.DecryptString(mValue)
                Else
                    Return mValue
                End If
            End Get
        End Property

        <XmlIgnore()> _
        Public ReadOnly Property CipherValue() As String
            Get
                If mIsEncrypted Then
                    Return mValue
                Else
                    Return mCryptoHelper.EncryptString(mValue)
                End If
            End Get
        End Property

#End Region

#Region " Constructors "
        Shared Sub New()
            mKeyData = New Byte() {78, 82, 67, 32, 68, 66, 67, 111, 110, 110, 101, 99, 116, 105, 111, 110}
            mVectorData = New Byte() {78, 82, 67, 83, 81, 76, 68, 66}
            mCryptoHelper = Nrc.Framework.Security.CryptoHelper.CreateTripleDESCryptoHelper(mKeyData, mVectorData)
        End Sub

        Sub New()
        End Sub

        Sub New(ByVal name As String, ByVal value As String)
            Me.New(name, value, False)
        End Sub
        Sub New(ByVal name As String, ByVal value As String, ByVal isEncrypted As Boolean)
            mName = name
            mValue = value
            mIsEncrypted = isEncrypted
        End Sub
#End Region

    End Class
End Namespace