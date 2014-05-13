Imports ActiveUp.Net
Imports System.Text

''' <summary>A List of Address objects used for things like the to collection of an email.</summary>
''' <CreatedBy>Jeff Fleming</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class AddressCollection
    Inherits List(Of Address)

#Region "Constructors"

    Public Sub New()

        MyBase.New()

    End Sub

#End Region


#Region "Public Properties"

    ''' <summary>Formats the list of address object values as a semi colon delimted string.</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Links() As String
        Get
            Dim link As New StringBuilder

            For Each addr As Address In Me
                If link.Length > 0 Then link.Append(";")
                link.Append(addr.Link)
            Next

            Return link.ToString
        End Get
    End Property

    ''' <summary>Formats the list of address object values as a semi colon delimted string.</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Merged() As String
        Get
            Dim merge As New StringBuilder

            For Each addr As Address In Me
                If merge.Length > 0 Then merge.Append(";")
                merge.Append(addr.Merged)
            Next

            Return merge.ToString
        End Get
    End Property

#End Region


#Region "Public Methods"

    ''' <summary>Adds to list by passing in an address object.</summary>
    ''' <param name="address"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overloads Sub Add(ByVal address As Address)

        MyBase.Add(address)

    End Sub

    ''' <summary>Adds to list by passing in an email string.</summary>
    ''' <param name="email"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overloads Sub Add(ByVal email As String)

        MyBase.Add(New Address(email))

    End Sub

    ''' <summary>Adds to list by passing in an email string an friendly email name.</summary>
    ''' <param name="email"></param>
    ''' <param name="name"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overloads Sub Add(ByVal email As String, ByVal name As String)

        MyBase.Add(New Address(email, name))

    End Sub

#End Region

End Class
