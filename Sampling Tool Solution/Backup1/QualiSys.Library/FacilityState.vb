Public Class FacilityState
    Private mName As String
    Private mAbbreviation As String

    Public ReadOnly Property Name() As String
        Get
            Return mName
        End Get
    End Property

    Public ReadOnly Property Abbreviation() As String
        Get
            Return mAbbreviation
        End Get
    End Property

    Public Sub New(ByVal name As String, ByVal abbreviation As String)
        mName = name
        mAbbreviation = abbreviation
    End Sub

    Public Shared Function getAll() As Collection(Of FacilityState)
        Dim facs As New Collection(Of FacilityState)
        facs.Add(New FacilityState("Not Applicable", "NA"))
        facs.Add(New FacilityState("American Samoa", "AS"))
        facs.Add(New FacilityState("Guam", "GU"))
        facs.Add(New FacilityState("Marshall Islands", "MH"))
        facs.Add(New FacilityState("Puerto Rico", "PR"))
        facs.Add(New FacilityState("Virgin Islands", "VI"))
        facs.Add(New FacilityState("Illinois", "IL"))
        facs.Add(New FacilityState("Indiana", "IN"))
        facs.Add(New FacilityState("Michigan", "MI"))
        facs.Add(New FacilityState("Ohio", "OH"))
        facs.Add(New FacilityState("Wisconsin", "WI"))
        facs.Add(New FacilityState("Alabama", "AL"))
        facs.Add(New FacilityState("Kentucky", "KY"))
        facs.Add(New FacilityState("Mississippi", "MS"))
        facs.Add(New FacilityState("Tennessee", "TN"))
        facs.Add(New FacilityState("New Jersey", "NJ"))
        facs.Add(New FacilityState("New York", "NY"))
        facs.Add(New FacilityState("Pennsylvania", "PA"))
        facs.Add(New FacilityState("Arizona", "AZ"))
        facs.Add(New FacilityState("Colorado", "CO"))
        facs.Add(New FacilityState("Idaho", "ID"))
        facs.Add(New FacilityState("Montana", "MT"))
        facs.Add(New FacilityState("New Mexico", "NM"))
        facs.Add(New FacilityState("Nevada", "NV"))
        facs.Add(New FacilityState("Utah", "UT"))
        facs.Add(New FacilityState("Wyoming", "WY"))
        facs.Add(New FacilityState("Connecticut", "CT"))
        facs.Add(New FacilityState("Massachusetts", "MA"))
        facs.Add(New FacilityState("Maine", "ME"))
        facs.Add(New FacilityState("New Hampshire", "NH"))
        facs.Add(New FacilityState("Rhode Island", "RI"))
        facs.Add(New FacilityState("Vermont", "VT"))
        facs.Add(New FacilityState("Alaska", "AK"))
        facs.Add(New FacilityState("California ", "CA"))
        facs.Add(New FacilityState("Hawaii", "HI"))
        facs.Add(New FacilityState("Oregon", "OR"))
        facs.Add(New FacilityState("Washington", "WA"))
        facs.Add(New FacilityState("District of Columbia", "DC"))
        facs.Add(New FacilityState("Delaware", "DE"))
        facs.Add(New FacilityState("Florida", "FL"))
        facs.Add(New FacilityState("Georgia", "GA"))
        facs.Add(New FacilityState("Maryland", "MD"))
        facs.Add(New FacilityState("North Carolina", "NC"))
        facs.Add(New FacilityState("South Carolina", "SC"))
        facs.Add(New FacilityState("Virginia", "VA"))
        facs.Add(New FacilityState("West Virginia", "WV"))
        facs.Add(New FacilityState("Iowa", "IA"))
        facs.Add(New FacilityState("Kansas", "KS"))
        facs.Add(New FacilityState("Minnesota", "MN"))
        facs.Add(New FacilityState("Missouri", "MO"))
        facs.Add(New FacilityState("North Dakota", "ND"))
        facs.Add(New FacilityState("Nebraska", "NE"))
        facs.Add(New FacilityState("South Dakota", "SD"))
        facs.Add(New FacilityState("Arkansas", "AR"))
        facs.Add(New FacilityState("Louisiana", "LA"))
        facs.Add(New FacilityState("Oklahoma", "OK"))
        facs.Add(New FacilityState("Texas", "TX"))
        Return facs
    End Function

End Class


