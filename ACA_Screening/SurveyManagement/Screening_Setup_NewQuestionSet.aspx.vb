Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net.Mail
Imports TicketTracker.Data
Imports TicketTracker.Utils
Imports System.Text.RegularExpressions

Public Class Screening_Setup_NewQuestionSet
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub rptQuestions_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptQuestions.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim cnn As New SqlConnection(TTracker.strCon)
            cnn.Open()
            Dim cmd As New SqlCommand("SELECT AnswerID, Answer_Text, qs.QuestionID, qs.QuestionText, qs.QuestionSequence FROM tblTT_Screening_Answers ans INNER JOIN tblTT_Screening_Questions qs ON (ans.QuestionID = qs.QuestionID) WHERE ans.QuestionID = @QuestionID ORDER BY Answer_SequenceNumber", cnn)
            cmd.Parameters.Add("@QuestionID", SqlDbType.Int).Value = e.Item.DataItem("QuestionID")
            Dim da As New SqlDataAdapter(cmd)
            Dim ds As New DataSet()
            da.Fill(ds)
            Dim rpt As Repeater = CType(e.Item.FindControl("rptAnswers"), Repeater)
            rpt.DataSource = ds
            rpt.DataBind()
        End If
    End Sub
End Class