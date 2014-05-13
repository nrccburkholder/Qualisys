''' <summary>This class represents a team which is a group of NRC Associates that work together for a client/project.</summary>
''' <CreateBy>Tony,Steves,Arman</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class Team
#Region " Private Fields "
    Private mId As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mIsDirty As Boolean

#End Region

#Region " Public Properties "
    ''' <summary>Unique Identifier for a team.</summary>
    ''' <value>The Unique ID for a team.</value>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>The name for the team.</summary>
    ''' <value>The name for the team. String value</value>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>A description of the team</summary>
    ''' <value>A description of the team as a string value.</value>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Description() As String
        Get
            Return Me.mDescription
        End Get
        Set(ByVal value As String)
            If Me.mDescription <> value Then
                Me.mDescription = value
                mIsDirty = True
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Team Object Contstructor.</summary>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New()
    End Sub
#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "
    ''' <summary>This method retrieve all teams in from the database whose ID is less than 100.</summary>
    ''' <returns>Collection of Team Objects</returns>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetTwoDigitTeams() As Collection(Of Team)
        'Return Nothing
        Return DataProvider.Instance.SelectTeams()
    End Function
    
#End Region

    ''' <summary>This flag tells you if the team object has been modified.</summary>
    ''' <CreateBy>Tony,Steves,Arman</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

End Class
