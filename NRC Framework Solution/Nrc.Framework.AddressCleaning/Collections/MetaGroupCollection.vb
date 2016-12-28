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


End Class