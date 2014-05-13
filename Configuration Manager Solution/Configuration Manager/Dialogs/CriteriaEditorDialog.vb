Imports System.Windows.Forms
Imports Nrc.Qualisys.Library

Public Class CriteriaEditorDialog

#Region " Private fields "

    Private mCriteriaClone As Criteria

#End Region


#Region " Public Properties "

    Public Property Criteria() As Criteria

        Get
            Return CriteriaEditorControl.CriteriaStmt
        End Get

        Set(ByVal value As Criteria)
            'Clone the criteria object for undo purposes on a cancel
            mCriteriaClone = DirectCast(value.Clone, Criteria)

            'Add the criteria to the control
            CriteriaEditorControl.CriteriaStmt = value
        End Set

    End Property


    Public Property ShowRuleName() As Boolean

        Get
            Return CriteriaEditorControl.ShowRuleName
        End Get

        Set(ByVal value As Boolean)
            CriteriaEditorControl.ShowRuleName = value
        End Set

    End Property


    Public Property ShowCriteriaStatement() As Boolean

        Get
            Return CriteriaEditorControl.ShowCriteriaStatement
        End Get

        Set(ByVal value As Boolean)
            CriteriaEditorControl.ShowCriteriaStatement = value
        End Set

    End Property

#End Region


#Region " Control Events "

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        'Check to see if the criteria editor is valid
        If Not CriteriaEditorControl.IsValid Then Exit Sub

        'If we are here then all is well
        DialogResult = System.Windows.Forms.DialogResult.OK
        Close()

    End Sub

    Private Sub CanclButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CanclButton.Click

        'The user has canceled changes so reset the criteria object
        CriteriaEditorControl.CriteriaStmt.UndoChanges(mCriteriaClone)
        DialogResult = System.Windows.Forms.DialogResult.Cancel
        Close()

    End Sub

#End Region

End Class
