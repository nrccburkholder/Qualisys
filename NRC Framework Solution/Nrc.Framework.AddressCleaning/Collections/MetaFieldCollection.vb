Imports Nrc.Framework.BusinessLogic

''' <summary>
''' This file is the definition for the CMetaFields collection class used 
''' to contain all of the metafield objects that are used to identify name 
''' and address fields available to be cleaned in a specific study.
''' </summary>
''' <remarks></remarks>
Friend Class MetaFieldCollection
    Inherits BusinessListBase(Of MetaFieldCollection, MetaField)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As MetaField = MetaField.NewMetaField
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

End Class