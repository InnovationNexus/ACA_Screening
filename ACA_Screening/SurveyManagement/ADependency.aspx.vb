Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class ADependency
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lnkBack.NavigateUrl = "~/SurveyManagement/SurveyQuestions.aspx?SurveyTypeID=" + Request.QueryString("SurveyTypeID") + "&QuestionID=" + Request.QueryString("QuestionID") + "&AnswerID=" + Request.QueryString("AnswerID")
    End Sub

    Private Sub rptPriorQuestions_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptPriorQuestions.ItemDataBound
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim drv As DataRowView = CType(e.Item.DataItem, DataRowView)
            Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
            cnn.Open()
            Dim cmd As New SqlCommand("prcScreening_LIST_AllAnswersForQuestion", cnn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("QuestionID", SqlDbType.BigInt).Value = Int32.Parse(drv.Row("ID").ToString())
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)

            Dim ddl As DropDownList = CType(e.Item.FindControl("ddlAnswers"), DropDownList)
            ddl.DataSource = ds.Tables(0)
            ddl.DataBind()
            ddl.Items.Insert(0, New ListItem("<No Dependency>", "0"))
        End If
    End Sub

    Private Sub rptExistingDependencies_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptExistingDependencies.ItemDataBound
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim drv As DataRowView = CType(e.Item.DataItem, DataRowView)
            Dim div2 As HtmlGenericControl = CType(e.Item.FindControl("divDep2"), HtmlGenericControl)
            Dim div3 As HtmlGenericControl = CType(e.Item.FindControl("divDep3"), HtmlGenericControl)
            Dim div4 As HtmlGenericControl = CType(e.Item.FindControl("divDep4"), HtmlGenericControl)
            Dim div5 As HtmlGenericControl = CType(e.Item.FindControl("divDep5"), HtmlGenericControl)
            Dim h3OR As HtmlGenericControl = CType(e.Item.FindControl("h3OR"), HtmlGenericControl)

            If e.Item.ItemIndex > 0 Then
                h3OR.Visible = True
            Else
                h3OR.Visible = False
            End If

            div2.Visible = True
            div3.Visible = True
            div4.Visible = True
            div5.Visible = True
            If IsDBNull(drv.Row("DependentOn_AnswerID_2")) Then
                div2.Visible = False
                div3.Visible = False
                div4.Visible = False
                div5.Visible = False
            ElseIf IsDBNull(drv.Row("DependentOn_AnswerID_3")) Then
                div3.Visible = False
                div4.Visible = False
                div5.Visible = False
            ElseIf IsDBNull(drv.Row("DependentOn_AnswerID_4")) Then
                div4.Visible = False
                div5.Visible = False
            ElseIf IsDBNull(drv.Row("DependentOn_AnswerID_5")) Then
                div5.Visible = False
            End If

        End If
    End Sub

    Private Sub rptExistingDependencies_ItemCommand(source As Object, e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles rptExistingDependencies.ItemCommand
        If e.CommandName = "Delete" Then
            Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
            Dim cmd As New SqlCommand("prcScreening_DELETE_AnswerDependency", cnn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("DependencyID", SqlDbType.BigInt).Value = Int32.Parse(e.CommandArgument.ToString())
            cnn.Open()
            cmd.ExecuteNonQuery()
            cnn.Close()
            rptExistingDependencies.DataBind()
        End If
    End Sub

    Private Sub btnAddDependency_Click(sender As Object, e As System.EventArgs) Handles btnAddDependency.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand("prcScreening_ADD_AnswerDependency", cnn)
        cmd.CommandType = CommandType.StoredProcedure
        With cmd.Parameters
            .Add("AnswerID", SqlDbType.BigInt).Value = Request.QueryString("AnswerID")
            .Add("DependentOn_AnswerID_1", SqlDbType.BigInt)
            .Add("DependentOn_AnswerID_2", SqlDbType.BigInt).Value = DBNull.Value
            .Add("DependentOn_AnswerID_3", SqlDbType.BigInt).Value = DBNull.Value
            .Add("DependentOn_AnswerID_4", SqlDbType.BigInt).Value = DBNull.Value
            .Add("DependentOn_AnswerID_5", SqlDbType.BigInt).Value = DBNull.Value
            .Add("OUT_DependencyID", SqlDbType.BigInt).Direction = ParameterDirection.Output
        End With

        '--- Get first 5 selected (non-zero) AnswerIDs from series of DropDownLists 
        Dim i As Int16 = 0
        Dim strPrmName As String
        Dim key As String
        Dim val As Int32
        For Each key In Request.Form
            If key.Contains("ddlAnswers") Then
                val = Int32.Parse(Request.Form.Item(key))
                If val <> 0 Then
                    i += 1
                    strPrmName = "DependentOn_AnswerID_" + i.ToString()
                    cmd.Parameters(strPrmName).Value = val
                    If i = 5 Then
                        Exit For
                    End If
                End If
            End If
        Next

        If i > 0 Then
            cnn.Open()
            cmd.ExecuteNonQuery()
            cnn.Close()
        End If

        cmd = Nothing
        cnn = Nothing

        rptExistingDependencies.DataBind()
        rptPriorQuestions.DataBind()
    End Sub

End Class