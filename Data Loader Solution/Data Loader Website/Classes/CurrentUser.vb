Imports Nrc.NrcAuthLib

''' <summary>Static class used to retrieve NRCAuth related objects (members, groups, priveledges,etc.)</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class CurrentUser

    Private Sub New()
    End Sub

    Public Shared ReadOnly Property IsAuthenticated() As Boolean
        Get
            Return HttpContext.Current.User.Identity.IsAuthenticated
        End Get
    End Property

    Public Shared ReadOnly Property Name() As String
        Get
            Return HttpContext.Current.User.Identity.Name
        End Get
    End Property

    Public Shared ReadOnly Property Member() As Member
        Get
            Return NRCPrincipal.Current.Member
        End Get
    End Property

    Public Shared ReadOnly Property Principal() As NRCPrincipal
        Get
            Return NRCPrincipal.Current
        End Get
    End Property

    Public Shared ReadOnly Property HasSelectedGroup() As Boolean
        Get
            If IsAuthenticated Then
                Return NRCPrincipal.Current.HasSelectedGroup
            Else
                Return False
            End If
        End Get
    End Property

    Public Shared ReadOnly Property SelectedGroup() As Group
        Get
            Return NRCPrincipal.Current.SelectedGroup
        End Get
    End Property

    Public Shared ReadOnly Property HasDataLoaderAccess() As Boolean
        Get
            Return IsAuthenticated AndAlso Member.HasAccessToApplication("Data Loader")
        End Get
    End Property

End Class