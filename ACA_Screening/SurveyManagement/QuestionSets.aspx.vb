Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net.Mail
Imports System.Text.RegularExpressions
Imports System.Configuration


Public Class QuestionSets
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lnkHome.NavigateUrl = "~/SurveyManagement/Home.aspx?ClientID=" + Session("ClientID")
    End Sub

    Private Sub rptQuestions_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptQuestions.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
            cnn.Open()
            Dim cmd As New SqlCommand("prcScreening_AnswerDetail_ForQuestion", cnn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@QuestionID", SqlDbType.Int).Value = e.Item.DataItem("QuestionID")
            cmd.Parameters.Add("@QuestionSetID", SqlDbType.Int).Value = e.Item.DataItem("QuestionSetID")
            Dim da As New SqlDataAdapter(cmd)
            Dim ds As New DataSet()
            da.Fill(ds)
            Dim rpt As Repeater = CType(e.Item.FindControl("rptAnswers"), Repeater)
            rpt.DataSource = ds
            rpt.DataBind()
        End If
    End Sub

    Private Sub btnSaveQuestion_Click(sender As Object, e As System.EventArgs) Handles btnSaveQuestion.Click
        Dim iQSID As Integer = ddlQuestionSets.SelectedValue
        Dim iQID As Integer = ddlQuestion.SelectedValue
        Dim iMaxScore As Integer = Convert.ToInt32(CType(fvQuestionDetail.FindControl("txtMaxScore"), TextBox).Text)
        Dim iAID As Integer
        Dim dPrct As Single
        Dim blnIsBest, blnIsLeast, blnIsWorst As Boolean
        Dim i As Integer
        Dim rw As GridViewRow
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        cnn.Open()
        Dim cmd As New SqlCommand()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.StoredProcedure
        '--- Update/Insert Question link to QuestionSet
        cmd.CommandText = "prcScreening_UPDATE_QuestionToSet"
        With cmd.Parameters
            .Clear()
            .Add("QuestionSetID", SqlDbType.BigInt).Value = iQSID
            .Add("QuestionID", SqlDbType.BigInt).Value = ddlQuestion.SelectedValue
            .Add("MaxScore", SqlDbType.BigInt).Value = Convert.ToInt32(CType(fvQuestionDetail.FindControl("txtMaxScore"), TextBox).Text)
        End With
        cmd.ExecuteNonQuery()


        '--- Update/Insert Answer links to QuestionSet
        cmd.CommandText = "prcScreening_UPDATE_AnswerToSet"
        With cmd.Parameters
            .Clear()
            .Add("QuestionSetID", SqlDbType.BigInt).Value = iQSID
            .Add("AnswerID", SqlDbType.BigInt)
            .Add("Answer_Prct", SqlDbType.Decimal, 3)
            .Add("IsBest", SqlDbType.Bit)
            .Add("IsLeastAcceptable", SqlDbType.Bit)
            .Add("IsWorst", SqlDbType.Bit)
        End With

        For i = 0 To gvAnswers.Rows.Count - 1
            rw = gvAnswers.Rows(i)
            If (rw.RowType = DataControlRowType.DataRow) Then
                iAID = Convert.ToInt32(CType(rw.FindControl("hidAnswerID"), HiddenField).Value)
                dPrct = Convert.ToSingle(CType(rw.FindControl("txtAnsPrct"), TextBox).Text) / 100
                blnIsBest = CType(rw.FindControl("cbIsBest"), CheckBox).Checked
                blnIsLeast = CType(rw.FindControl("cbIsLA"), CheckBox).Checked
                blnIsWorst = CType(rw.FindControl("cbIsWorst"), CheckBox).Checked

                With cmd.Parameters
                    .Item("AnswerID").Value = iAID
                    .Item("Answer_Prct").Value = dPrct
                    .Item("IsBest").Value = blnIsBest
                    .Item("IsLeastAcceptable").Value = blnIsLeast
                    .Item("IsWorst").Value = blnIsWorst
                End With
                cmd.ExecuteNonQuery()
            End If
        Next

        cnn.Close()
        cmd = Nothing
        cnn = Nothing

        If (ddlQuestion.Items.Count > (ddlQuestion.SelectedIndex + 1)) Then
            ddlQuestion.SelectedIndex += 1
        End If
        fvQuestionDetail.DataBind()
        gvAnswers.DataBind()
        rptQuestions.DataBind()
    End Sub

    Private Sub fvQuestionSetDetail_DataBound(sender As Object, e As System.EventArgs) Handles fvQuestionSetDetail.DataBound
        pnlSelectQuestionSet.Visible = True
        ddlQuestionSets.Enabled = True

        If fvQuestionSetDetail.CurrentMode = FormViewMode.Insert Then
            Dim ddl As DropDownList
            Dim i As Int16

            For i = 1 To 5
                ddl = CType(fvQuestionSetDetail.FindControl("ddlAnswerKeyQuestion" + i.ToString()), DropDownList)
                ddl.Items.Insert(0, New ListItem("<none selected>", "0"))

                ddl = CType(fvQuestionSetDetail.FindControl("ddlAnswerKey" + i.ToString()), DropDownList)
                ddl.Items.Insert(0, New ListItem("<none selected>", "0"))
            Next

            pnlSelectQuestionSet.Visible = False
        ElseIf fvQuestionSetDetail.CurrentMode = FormViewMode.Edit Then
            ddlQuestionSets.Enabled = False
        End If

    End Sub

    Private Sub fvQuestionSetDetail_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles fvQuestionSetDetail.ItemInserting
        Dim ddl As DropDownList
        Dim prm As New Web.UI.WebControls.Parameter
        Dim i As Int16
        Dim blnLastParamFound As Boolean = False
        '--- Manually add answer keys
        For i = 1 To 5
            ddl = CType(fvQuestionSetDetail.FindControl("ddlAnswerKey" + i.ToString()), DropDownList)
            prm.Name = "KeyAnswerID_" + i.ToString()
            If ddl.SelectedValue <> "0" And Not blnLastParamFound Then
                prm.DefaultValue = ddl.SelectedValue
            Else
                prm.DefaultValue = ""
                '--- Keys must be sequential.  As soon as a DropDown is encountered that does NOT have an Answer specified, keep subsequent parameters from being set.
                blnLastParamFound = True
            End If
            srcQuestionSetDetail.InsertParameters.Add(prm)
        Next
    End Sub

    Private Sub fvQuestionSetDetail_ModeChanged(sender As Object, e As System.EventArgs) Handles fvQuestionSetDetail.ModeChanged
        If fvQuestionSetDetail.CurrentMode = FormViewMode.ReadOnly Then
            Me.pnlQuestionsForSet.Visible = True
        Else
            Me.pnlQuestionsForSet.Visible = False
        End If
    End Sub
End Class