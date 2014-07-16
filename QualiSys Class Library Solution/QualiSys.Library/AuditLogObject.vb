Public NotInheritable Class AuditLogObject

    Private Enum AuditLogObjectType
        None = 0
        Study = 1
        Survey = 2
        SampleUnit = 3
        BusinessRule = 4
        Criteria = 5
        Methodology = 6
        MethodologyStep = 7
        Facility = 8
        SectionMapping = 9
        SamplePeriod = 10
        SamplePeriodScheduledSample = 11
        EmailBlast = 12
        ModeSectionMapping = 13
    End Enum

    Private mObjectType As AuditLogObjectType

    Private Sub New(ByVal objectType As AuditLogObjectType)
        mObjectType = objectType
    End Sub

    Public Overrides Function ToString() As String
        Return mObjectType.ToString
    End Function

    Public Shared ReadOnly Property Study() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.Study)
        End Get
    End Property

    Public Shared ReadOnly Property Survey() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.Survey)
        End Get
    End Property

    Public Shared ReadOnly Property SampleUnit() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.SampleUnit)
        End Get
    End Property

    Public Shared ReadOnly Property BusinessRule() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.BusinessRule)
        End Get
    End Property

    Public Shared ReadOnly Property Criteria() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.Criteria)
        End Get
    End Property

    Public Shared ReadOnly Property Methodology() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.Methodology)
        End Get
    End Property

    Public Shared ReadOnly Property MethodologyStep() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.MethodologyStep)
        End Get
    End Property

    Public Shared ReadOnly Property EmailBlast() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.EmailBlast)
        End Get
    End Property

    Public Shared ReadOnly Property Facility() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.Facility)
        End Get
    End Property

    Public Shared ReadOnly Property SectionMapping() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.SectionMapping)
        End Get
    End Property

    Public Shared ReadOnly Property SamplePeriod() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.SamplePeriod)
        End Get
    End Property

    Public Shared ReadOnly Property SamplePeriodScheduledSample() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.SamplePeriodScheduledSample)
        End Get
    End Property

    Public Shared ReadOnly Property ModeSectionMapping() As AuditLogObject
        Get
            Return New AuditLogObject(AuditLogObjectType.ModeSectionMapping)
        End Get
    End Property

    Public Overrides Function Equals(ByVal obj As Object) As Boolean
        Dim logObject As AuditLogObject = TryCast(obj, AuditLogObject)
        If logObject IsNot Nothing Then
            Return (Me.mObjectType = logObject.mObjectType)
        Else
            Return False
        End If
    End Function

    Public Overrides Function GetHashCode() As Integer
        Return mObjectType
    End Function

    Public Shared Operator =(ByVal left As AuditLogObject, ByVal right As AuditLogObject) As Boolean
        If left Is Nothing Then
            Return False
        End If
        If right Is Nothing Then
            Return False
        End If

        Return left.Equals(right)
    End Operator

    Public Shared Operator <>(ByVal left As AuditLogObject, ByVal right As AuditLogObject) As Boolean
        Return (Not left = right)
    End Operator

End Class
