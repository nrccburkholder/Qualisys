Imports Nrc.NRCAuthLib

Public Class ApplicationNavigator

#Region " ApplicationSelected Event "
    Public Class ApplicationSelectedEventArgs
        Inherits EventArgs

        Private mApplication As Application

        Public ReadOnly Property Application() As Application
            Get
                Return mApplication
            End Get
        End Property

        Public Sub New(ByVal app As Application)
            mApplication = app
        End Sub

    End Class

    Public Event ApplicationSelected As EventHandler(Of ApplicationSelectedEventArgs)
    Protected Overridable Sub OnApplicationSelected(ByVal e As ApplicationSelectedEventArgs)
        RaiseEvent ApplicationSelected(Me, e)
    End Sub
#End Region

    Private mSelectedButton As ToolStripButton

    Private Sub ApplicationNavigator_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.PopulateAppList()
    End Sub

    Private Sub PopulateAppList()
        Me.ApplicationToolStrip.Items.Clear()


        For Each app As Application In ApplicationCollection.GetAllApplications
            Dim item As New ToolStripButton(app.Name, Me.BytesToImage(app.ImageData), AddressOf ApplicationButton_Clicked)
            item.Tag = app
            item.ImageAlign = ContentAlignment.MiddleLeft
            Me.ApplicationToolStrip.Items.Add(item)
        Next

    End Sub

    Private Sub ApplicationButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)
        Dim item As ToolStripButton = TryCast(sender, ToolStripButton)

        If item IsNot Nothing Then
            If mSelectedButton IsNot Nothing Then
                mSelectedButton.Checked = False
            End If
            mSelectedButton = item
            item.Checked = True

            Dim app As Application = TryCast(item.Tag, Application)
            If app IsNot Nothing Then
                Me.OnApplicationSelected(New ApplicationSelectedEventArgs(app))
            End If
        End If
    End Sub

    Public Sub ReloadSelectedButton()
        If mSelectedButton IsNot Nothing Then
            Dim app As Application = TryCast(mSelectedButton.Tag, Application)
            If app IsNot Nothing Then
                If app.ApplicationId > 0 Then
                    'Get the updated object
                    app = Application.GetApplication(app.ApplicationId)
                    mSelectedButton.Tag = app

                    'Update the image in case it has changed
                    mSelectedButton.Image = BytesToImage(app.ImageData)

                    'Change the name if needed
                    If mSelectedButton.Text <> app.Name Then
                        mSelectedButton.Text = app.Name
                        Me.ResortButtons()
                    End If

                    'Raise the event to reload any listeners
                    Me.OnApplicationSelected(New ApplicationSelectedEventArgs(app))
                Else
                    Me.ApplicationToolStrip.Items.Remove(mSelectedButton)
                    Me.OnApplicationSelected(New ApplicationSelectedEventArgs(Nothing))
                End If
            End If
        End If
    End Sub

    Private Sub ResortButtons()
        Dim list As New SortedList(Of String, ToolStripButton)
        For Each btn As ToolStripButton In Me.ApplicationToolStrip.Items
            list.Add(btn.Text, btn)
        Next

        Me.ApplicationToolStrip.Items.Clear()

        For Each key As String In list.Keys
            Me.ApplicationToolStrip.Items.Add(list(key))
        Next
    End Sub

    Private Function BytesToImage(ByVal imgData As Byte()) As Image
        'Return NULL when there is no data
        If imgData Is Nothing OrElse imgData.Length = 0 Then
            Return Nothing
        End If

        'Put the bytes into a stream and load it into an image
        Using ms As New IO.MemoryStream(imgData)
            Return System.Drawing.Image.FromStream(ms)
        End Using

    End Function

    Private Shared Function ImageToBytes(ByVal img As Drawing.Image) As Byte()
        'Return NULL if there is not image object
        If img Is Nothing Then
            Return Nothing
        End If

        'Create a membory stream and save the image to it
        'Export the stream to a byte array
        Using ms As New IO.MemoryStream
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Png)
            Return ms.ToArray
        End Using
    End Function


    Private Sub NewApplicationButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewApplicationButton.Click
        Dim app As New Application
        app.Name = "New Application"
        app.ImageData = ImageToBytes(My.Resources.DefaultApp32)

        Dim item As New ToolStripButton(app.Name, Me.BytesToImage(app.ImageData), AddressOf ApplicationButton_Clicked)
        item.Tag = app
        item.ImageAlign = ContentAlignment.MiddleLeft
        Me.ApplicationToolStrip.Items.Add(item)

        Me.ResortButtons()

        item.PerformClick()
    End Sub
End Class
