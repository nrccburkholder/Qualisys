Imports System

Namespace CommentsSAEmailServer
    Public Class clsEmailFormat
        ' Properties
        Public Property FormatID As Integer
            Get
                Return Me.mintFormatID
            End Get
            Set(ByVal Value As Integer)
                Me.mintFormatID = Value
                Select Case Me.mintFormatID
                    Case 1
                        Me.mstrFormatName = "Quantity Only"
                        Exit Select
                    Case 2
                        Me.mstrFormatName = "Qty & Litho List"
                        Exit Select
                End Select
            End Set
        End Property

        Public ReadOnly Property FormatName As String
            Get
                Return Me.mstrFormatName
            End Get
        End Property


        ' Fields
        Private mintFormatID As Integer = 0
        Private mstrFormatName As String = ""
    End Class
End Namespace

