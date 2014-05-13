Imports ActiveUp.Net

''' <summary>This class represents and email address that can contain either an email only and or an email with a friendly name.</summary>
''' <CreatedBy>Jeff Fleming</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class Address

#Region "Private Members"

    Private mAuAddress As Mail.Address

#End Region


#Region "Public Properties"

    ''' <summary>The Internet email address (RFC 2822 addr-spec).</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Email() As String
        Get
            Return mAuAddress.Email
        End Get
        Set(ByVal value As String)
            mAuAddress.Email = value
        End Set
    End Property

    ''' <summary>The Address owner's fullname.</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mAuAddress.Name
        End Get
        Set(ByVal value As String)
            mAuAddress.Name = value
        End Set
    End Property

    ''' <summary>Gets an HTML formatted link to the address (mailto: form).</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Link() As String
        Get
            Return mAuAddress.Link
        End Get
    End Property

    ''' <summary>Gets a string compliant with RFC2822 address specification that represents the Address with the owner's fullname.</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Merged() As String
        Get
            Return mAuAddress.Merged
        End Get
    End Property

#End Region


#Region "Friend Properties"

    ''' <summary>Gets the internal ActiveUp Address object</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Friend ReadOnly Property AuAddress() As Mail.Address
        Get
            Return mAuAddress
        End Get
    End Property

#End Region


#Region "Public Methods"

    ''' <summary>Returns a String that represents the current Object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function ToString() As String

        Return mAuAddress.ToString

    End Function

#End Region


#Region "Constructors"

    ''' <summary>Default constructor.</summary>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New()

        mAuAddress = New Mail.Address

    End Sub

    ''' <summary>Constructor to use when you only have or need the email address.</summary>
    ''' <param name="email"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal email As String)

        mAuAddress = New Mail.Address(email)

    End Sub

    ''' <summary>Constructor to use when you have an email address as well as a friendly name.</summary>
    ''' <param name="email"></param>
    ''' <param name="name"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal email As String, ByVal name As String)

        mAuAddress = New Mail.Address(email, name)

    End Sub

#End Region

End Class
