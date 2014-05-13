''' <summary>
''' This is the base class from which most business objects
''' will be derived.
''' </summary>
''' <remarks>
''' <para>
''' This class is the core of the CSLA .NET framework. To create
''' a business object, inherit from this class.
''' </para><para>
''' Please refer to 'Expert VB 2005 Business Objects' for
''' full details on the use of this base class to create business
''' objects.
''' </para>
''' </remarks>
''' <typeparam name="T">Type of the business object being defined.</typeparam>
<Serializable()> _
Public MustInherit Class BusinessBase(Of T As BusinessBase(Of T))
    Inherits Core.BusinessBase

#Region " Object ID Value "

    ''' <summary>
    ''' Override this method to return a unique identifying
    ''' value for this object.
    ''' </summary>
    ''' <remarks>
    ''' If you can not provide a unique identifying value, it
    ''' is best if you can generate such a unique value (even
    ''' temporarily). If you can not do that, then return 
    ''' <see langword="Nothing"/> and then manually override the
    ''' <see cref="Equals"/>, <see cref="GetHashCode"/> and
    ''' <see cref="ToString"/> methods in your business object.
    ''' </remarks>
    Protected MustOverride Function GetIdValue() As Object

#End Region

#Region " System.Object Overrides "

    ''' <summary>
    ''' Compares this object for equality with another object, using
    ''' the results of <see cref="GetIdValue"/> to determine
    ''' equality.
    ''' </summary>
    ''' <param name="obj">The object to be compared.</param>
    Public Overloads Overrides Function Equals(ByVal obj As Object) As Boolean

        If TypeOf obj Is T Then
            Dim id As Object = GetIdValue()
            If id Is Nothing Then
                Throw New ArgumentException(My.Resources.GetIdValueCantBeNull)
            End If
            Return id.Equals(DirectCast(obj, T).GetIdValue)

        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' Returns a hash code value for this object, based on
    ''' the results of <see cref="GetIdValue"/>.
    ''' </summary>
    Public Overrides Function GetHashCode() As Integer

        Dim id As Object = GetIdValue()
        If id Is Nothing Then
            Throw New ArgumentException(My.Resources.GetIdValueCantBeNull)
        End If
        Return id.GetHashCode

    End Function

    ''' <summary>
    ''' Returns a text representation of this object by
    ''' returning the <see cref="GetIdValue"/> value
    ''' in text form.
    ''' </summary>
    Public Overrides Function ToString() As String

        Dim id As Object = GetIdValue()
        If id Is Nothing Then
            Throw New ArgumentException(My.Resources.GetIdValueCantBeNull)
        End If
        Return id.ToString

    End Function

#End Region

#Region " Clone "

    ''' <summary>
    ''' Creates a clone of the object.
    ''' </summary>
    ''' <returns>
    ''' A new object containing the exact data of the original object.
    ''' </returns>
    Public Overridable Function Clone() As T

        Return DirectCast(GetClone(), T)

    End Function

#End Region

End Class