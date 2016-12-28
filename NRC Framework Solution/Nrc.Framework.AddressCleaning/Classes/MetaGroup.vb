Imports Nrc.Framework.BusinessLogic

Public Interface IMetaGroup

    Property GroupID() As Integer

End Interface

''' <summary>
''' This file contains the definition of the MetaGroup object used to hold 
''' all the required information about a single name or address including a 
''' collection of MetaFields that identify each that is part of this name 
''' or address.
''' </summary>
''' <remarks></remarks>
<Serializable()> _
Public Class MetaGroup
    Inherits BusinessBase(Of MetaGroup)
    Implements IMetaGroup

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mGroupID As Integer
    Private mGroupName As String = String.Empty
    Private mGroupType As String = String.Empty
    Private mQtyUpdated As Integer
    Private mQtyErrors As Integer
    Private mQtyRemaining As Integer
    Private mQtyTotal As Integer

    Private mMetaFields As MetaFieldCollection

#End Region

#Region " Public Properties "

    Public Property GroupID() As Integer Implements IMetaGroup.GroupID
        Get
            Return mGroupID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mGroupID Then
                mGroupID = value
                PropertyHasChanged("GroupID")
            End If
        End Set
    End Property

    Public Property GroupName() As String
        Get
            Return mGroupName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mGroupName Then
                mGroupName = value
                PropertyHasChanged("GroupName")
            End If
        End Set
    End Property

    Public Property GroupType() As String
        Get
            Return mGroupType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mGroupType Then
                mGroupType = value
                PropertyHasChanged("GroupType")
            End If
        End Set
    End Property


    Public Property QtyUpdated() As Integer
        Get
            Return mQtyUpdated
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyUpdated Then
                mQtyUpdated = value
                PropertyHasChanged("QtyUpdated")
            End If
        End Set
    End Property

    Public Property QtyErrors() As Integer
        Get
            Return mQtyErrors
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyErrors Then
                mQtyErrors = value
                PropertyHasChanged("QtyErrors")
            End If
        End Set
    End Property

    Public Property QtyRemaining() As Integer
        Get
            Return mQtyRemaining
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyRemaining Then
                mQtyRemaining = value
                PropertyHasChanged("QtyRemaining")
            End If
        End Set
    End Property

    Public Property QtyTotal() As Integer
        Get
            Return mQtyTotal
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyTotal Then
                mQtyTotal = value
                PropertyHasChanged("QtyTotal")
            End If
        End Set
    End Property


#End Region


#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property MetaFields() As MetaFieldCollection
        Get
            Return mMetaFields
        End Get
    End Property

    ''' <summary>
    ''' Returns the formated list of fields used in a select statement to 
    ''' get the information about this name or address from the study table.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property SelectFieldList() As String
        Get
            Dim fieldList As String = String.Empty

            'Loop through all of the meta fields in this collection
            For Each metaFld As MetaField In mMetaFields
                If fieldList.Length > 0 Then fieldList &= ", "
                fieldList &= String.Format("{0} AS {1}", metaFld.FieldName, metaFld.ParamName)
            Next metaFld

            Return fieldList
        End Get
    End Property


    Friend ReadOnly Property RecordType() As String
        Get
            If IsAddress() Then
                Return "Address"
            Else
                Return "Name"
            End If
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Friend Shared Function NewMetaGroup() As MetaGroup

        Return New MetaGroup

    End Function

    'Friend Shared Function GetByStudyID(ByVal studyID As Integer) As MetaGroupCollection

    '    Return MetaGroupProvider.SelectMetaGroupsByStudyID(studyID)

    'End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mGroupID
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        mMetaFields = New MetaFieldCollection

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub


#End Region

#Region " Public Methods "

    Public Function IsAddress() As Boolean

        IsAddress = (mGroupType = "A")

    End Function

    Public Function IsName() As Boolean

        IsName = (mGroupType = "N")

    End Function

#End Region

#Region " Private Methods "

    Private Function GetFieldValue(ByVal field As String) As String

        If field.Length = 0 Then
            Return "NULL"
        Else
            Return String.Format("'{0}'", field)
        End If

    End Function

#End Region

End Class