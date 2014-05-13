Imports Nrc.Framework.BusinessLogic

''' <summary>
''' This file is the definition for the CMetaGroups collection class used 
''' to contain all of the metagroup objects that are used to identify name 
''' and address groups available to be cleaned in a specific study.
''' </summary>
''' <remarks></remarks>
Public Class MetaGroupCollection
    Inherits BusinessListBase(Of MetaGroupCollection, MetaGroup)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As MetaGroup = MetaGroup.NewMetaGroup
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Friend ReadOnly Properties "

    ''' <summary>
    ''' Returns the quantity of address selected for cleaning.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property AddressesSelected() As Integer
        Get
            'Determine how many addresses are selected
            Dim cnt As Integer = 0
            For Each metaGrp As MetaGroup In Me
                If metaGrp.GroupType = "A" And metaGrp.Selected Then
                    cnt += 1
                End If
            Next metaGrp

            Return cnt
        End Get
    End Property

    ''' <summary>
    ''' Returns the quantity of names selected for cleaning.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property NamesSelected() As Integer
        Get
            'Determine how many names are selected
            Dim cnt As Integer = 0
            For Each metaGrp As MetaGroup In Me
                If metaGrp.GroupType = "N" And metaGrp.Selected Then
                    cnt += 1
                End If
            Next metaGrp

            Return cnt
        End Get
    End Property

#End Region

End Class