Namespace DataProvider
    Public MustInherit Class MailingProvider

#Region " Singleton Implementation "
        Private Shared mInstance As MailingProvider
        Private Const mProviderName As String = "MailingProvider"

        Public Shared ReadOnly Property Instance() As MailingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MailingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectByLitho(ByVal litho As String) As Mailing
        Public MustOverride Function SelectByBarcode(ByVal barcode As String) As Mailing
        Public MustOverride Function SelectByWac(ByVal wac As String) As Mailing
        Public MustOverride Function SelectByPopId(ByVal popId As Integer, ByVal studyId As Integer) As Collection(Of Mailing)

        Public MustOverride Sub DeleteFutureMailings(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        Public MustOverride Sub ChangeRespondentAddress(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal address1 As String, ByVal address2 As String, ByVal city As String, ByVal delpt As String, ByVal country As CountryCode, ByVal state As String, ByVal province As String, ByVal zip5 As String, ByVal zip4 As String, ByVal postalCode As String, ByVal addrStat As String, ByVal addrErr As String)
        Public MustOverride Sub RegenerateMailing(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal languageId As Integer)
        Public MustOverride Sub TakeOffCallList(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        Public MustOverride Sub LogContactRequest(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal emailText As String)
        Public MustOverride Sub LogDispositionByLitho(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property SentMailId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.SentMailId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property LithoCode(ByVal obj As Mailing) As String
                Set(ByVal value As String)
                    If obj IsNot Nothing Then
                        obj.LithoCode = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property MethodologyStepId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.MethodologyStepId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property MethodologyStepName(ByVal obj As Mailing) As String
                Set(ByVal value As String)
                    If obj IsNot Nothing Then
                        obj.MethodologyStepName = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.StudyId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property SurveyId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.SurveyId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property PopId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.PopId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property LanguageId(ByVal obj As Mailing) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.LanguageId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property ScheduledGenerationDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.ScheduledGenerationDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property GenerationDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.GenerationDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property PrintDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.PrintDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property MailDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.MailDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property NonDeliveryDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.NonDeliveryDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property ReturnDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.ReturnDate = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property ExpirationDate(ByVal obj As Mailing) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.ExpirationDate = value
                    End If
                End Set
            End Property
        End Class
    End Class
End Namespace
