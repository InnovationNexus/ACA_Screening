Imports System.Data.SqlClient
Imports System.Configuration

Public Class SurveyQuestions
    Inherits System.Web.UI.Page

    Protected TextClientID As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lnkHome.NavigateUrl = "~/SurveyManagement/Home.aspx?ClientID=" + Session("ClientID")

        If Not Page.IsPostBack Then
            Me.TextClientID = "noelement"
            fvQuestionDetails.DataBind()
            If Not IsNothing(fvQuestionDetails.FindControl("txtQuestionText")) Then
                Me.TextClientID = fvQuestionDetails.FindControl("txtQuestionText").ClientID
            End If
        End If
        ClientScript.RegisterOnSubmitStatement(Me.GetType(), "EscapeQuestionText", "EscapeQuestion();")
    End Sub

    Private Sub btnNewAnswer_Click(sender As Object, e As System.EventArgs) Handles btnNewAnswer.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "SELECT @OUT_NextSeq = (MAX(Answer_SequenceNumber) + 1) FROM tblScreening_Answers WHERE QuestionID = @QuestionID"
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("QuestionID", SqlDbType.BigInt).Value = lstQuestions.SelectedValue
        cmd.Parameters.Add("OUT_NextSeq", SqlDbType.BigInt).Direction = ParameterDirection.Output
        cnn.Open()
        cmd.ExecuteNonQuery()

        fvAnswerDetails.ChangeMode(FormViewMode.Insert)
        fvAnswerDetails_ModeChanged(sender, e)
        fvAnswerDetails.DataBind()
        Dim hid As HiddenField = CType(fvAnswerDetails.FindControl("hidAnswer_SequenceNumber"), HiddenField)
        If IsDBNull(cmd.Parameters("OUT_NextSeq").Value) Then
            hid.Value = 1
        Else
            hid.Value = cmd.Parameters("OUT_NextSeq").Value
        End If

    End Sub

    Private Sub btnNewQuestion_Click(sender As Object, e As System.EventArgs) Handles btnNewQuestion.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "SELECT @OUT_NextSeq = (MAX(QuestionSequence) + 1) FROM tblScreening_Questions WHERE SurveyTypeID = @SurveyTypeID"
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("SurveyTypeID", SqlDbType.BigInt).Value = Request.QueryString("SurveyTypeID")
        cmd.Parameters.Add("OUT_NextSeq", SqlDbType.BigInt).Direction = ParameterDirection.Output
        cnn.Open()
        cmd.ExecuteNonQuery()

        fvQuestionDetails.ChangeMode(FormViewMode.Insert)
        fvQuestionDetails_ModeChanged(sender, e)
        fvQuestionDetails.DataBind()
        Dim hid As HiddenField = CType(fvQuestionDetails.FindControl("hidQuestionSequence"), HiddenField)
        If IsDBNull(cmd.Parameters("OUT_NextSeq").Value) Then
            hid.Value = 1
        Else
            hid.Value = cmd.Parameters("OUT_NextSeq").Value
        End If

    End Sub

    Private Sub btnMoveAnswerUp_Click(sender As Object, e As System.EventArgs) Handles btnMoveAnswerUp.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "prcScreening_MoveAnswerSequenceDown"     '--- Actually DECREASING sequence number
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("AnswerID", SqlDbType.BigInt).Value = lstAnswers.SelectedValue
        cnn.Open()
        cmd.ExecuteNonQuery()

        lstAnswers.DataBind()
    End Sub

    Private Sub btnMoveAnswerDown_Click(sender As Object, e As System.EventArgs) Handles btnMoveAnswerDown.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "prcScreening_MoveAnswerSequenceUp"     '--- Actually INCREASING sequence number
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("AnswerID", SqlDbType.BigInt).Value = lstAnswers.SelectedValue
        cnn.Open()
        cmd.ExecuteNonQuery()

        lstAnswers.DataBind()
    End Sub

    Private Sub btnMoveQuestionDown_Click(sender As Object, e As System.EventArgs) Handles btnMoveQuestionDown.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "prcScreening_MoveQuestionSequenceUp"   '--- Actually INCREASING sequence number
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("QuestionID", SqlDbType.BigInt).Value = lstQuestions.SelectedValue
        cnn.Open()
        cmd.ExecuteNonQuery()

        lstQuestions.DataBind()
    End Sub

    Private Sub btnMoveQuestionUp_Click(sender As Object, e As System.EventArgs) Handles btnMoveQuestionUp.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cmd.Connection = cnn
        cmd.CommandText = "prcScreening_MoveQuestionSequenceDown"     '--- Actually DECREASING sequence number
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("QuestionID", SqlDbType.BigInt).Value = lstQuestions.SelectedValue
        cnn.Open()
        cmd.ExecuteNonQuery()

        lstQuestions.DataBind()
    End Sub

    Private Sub btnQuestionDependencies_Click(sender As Object, e As System.EventArgs) Handles btnQuestionDependencies.Click
        Dim sURL As String = "QDependency.aspx?SurveyTypeID=" + Request.QueryString("SurveyTypeID") + "&QuestionID=" + lstQuestions.SelectedValue.ToString()
        Response.Redirect(sURL)
    End Sub

    Private Sub btnAnswerDependencies_Click(sender As Object, e As System.EventArgs) Handles btnAnswerDependencies.Click
        Dim sURL As String = "ADependency.aspx?SurveyTypeID=" + Request.QueryString("SurveyTypeID") + "&AnswerID=" + lstAnswers.SelectedValue.ToString() + "&QuestionID=" + lstQuestions.SelectedValue.ToString()
        Response.Redirect(sURL)
    End Sub

    Private Sub fvQuestionDetails_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles fvQuestionDetails.ItemInserted
        lstQuestions.DataBind()
    End Sub

    Private Sub fvAnswerDetails_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles fvAnswerDetails.ItemInserted
        lstAnswers.DataBind()
    End Sub

    Private Sub fvAnswerDetails_ItemUpdated(sender As Object, e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles fvAnswerDetails.ItemUpdated
        lstAnswers.DataBind()
    End Sub

    Private Sub fvQuestionDetails_ItemUpdated(sender As Object, e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles fvQuestionDetails.ItemUpdated
        lstQuestions.DataBind()
    End Sub

    Private Sub lstQuestions_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lstQuestions.SelectedIndexChanged
        fvQuestionDetails.ChangeMode(FormViewMode.Edit)
        fvQuestionDetails_ModeChanged(sender, e)
        fvQuestionDetails.DataBind()
    End Sub

    Private Sub fvQuestionDetails_ModeChanged(sender As Object, e As System.EventArgs) Handles fvQuestionDetails.ModeChanged
        Select Case fvQuestionDetails.CurrentMode
            Case FormViewMode.ReadOnly
                pnlAnswers.Visible = True
                btnNewQuestion.Visible = True
                btnMoveQuestionUp.Visible = True
                btnMoveQuestionDown.Visible = True
            Case FormViewMode.Edit
                pnlAnswers.Visible = True
                btnNewQuestion.Visible = True
                btnMoveQuestionUp.Visible = True
                btnMoveQuestionDown.Visible = True
            Case FormViewMode.Insert
                pnlAnswers.Visible = False
                btnNewQuestion.Visible = False
                btnMoveQuestionUp.Visible = False
                btnMoveQuestionDown.Visible = False
        End Select
    End Sub

    Private Sub lstAnswers_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lstAnswers.SelectedIndexChanged
        fvAnswerDetails.ChangeMode(FormViewMode.Edit)
        fvAnswerDetails_ModeChanged(sender, e)
        fvAnswerDetails.DataBind()
    End Sub

    Private Sub fvAnswerDetails_ModeChanged(sender As Object, e As System.EventArgs) Handles fvAnswerDetails.ModeChanged
        Select Case fvQuestionDetails.CurrentMode
            Case FormViewMode.ReadOnly
                btnNewAnswer.Visible = True
                btnMoveAnswerUp.Visible = True
                btnMoveAnswerDown.Visible = True
            Case FormViewMode.Edit
                btnNewAnswer.Visible = True
                btnMoveAnswerUp.Visible = True
                btnMoveAnswerDown.Visible = True
            Case FormViewMode.Insert
                btnNewAnswer.Visible = False
                btnMoveAnswerUp.Visible = False
                btnMoveAnswerDown.Visible = False
        End Select
    End Sub
End Class