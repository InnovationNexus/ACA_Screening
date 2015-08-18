Imports System.Data.SqlClient
Imports System.Configuration

Public Class Home
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session("ClientID") = Request.QueryString("ClientID")
    End Sub

    Private Sub btnNewSurvey_Click(sender As Object, e As System.EventArgs) Handles btnNewSurvey.Click
        Me.pnlSelectSurvey.Visible = False
        Me.txtSurveyName.Text = ""
        Me.txtSurveyDescription.Text = ""
        Me.pnlNewSurvey.Visible = True
    End Sub

    Private Sub btnSaveNewSurvey_Click(sender As Object, e As System.EventArgs) Handles btnSaveNewSurvey.Click
        Dim cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString())
        Dim cmd As New SqlCommand
        cnn.Open()
        cmd.Connection = cnn
        cmd.CommandText = "INSERT INTO tblScreening_SurveyTypes (ClientID, SurveyName, SurveyDescription) VALUES (@ClientID, @SurveyName, @SurveyDescription); SELECT @OUT_SurveyTypeID = Scope_Identity();"
        cmd.CommandType = CommandType.Text
        With cmd.Parameters
            .Add("ClientID", SqlDbType.BigInt).Value = Request.QueryString("ClientID")
            .Add("SurveyName", SqlDbType.VarChar, 20).Value = Me.txtSurveyName.Text
            .Add("SurveyDescription", SqlDbType.VarChar, 2000).Value = Me.txtSurveyDescription.Text
            .Add("OUT_SurveyTypeID", SqlDbType.BigInt).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()

        ddlSurveys.DataBind()
        ddlSurveys.SelectedIndex = ddlSurveys.Items.IndexOf(ddlSurveys.Items.FindByValue(cmd.Parameters("OUT_SurveyTypeID").Value))
        lstResultTypes.DataBind()

        pnlSelectSurvey.Visible = True
        pnlNewSurvey.Visible = False

        cnn.Close()
        cmd = Nothing
        cnn = Nothing

    End Sub

    Private Sub btnManageResultTypes_Click(sender As Object, e As System.EventArgs) Handles btnManageResultTypes.Click
        Dim sURL As String = "QuestionSets.aspx?SurveyTypeID=" + ddlSurveys.SelectedValue.ToString()
        Response.Redirect(sURL)
    End Sub

    Private Sub btnManageQuestions_Click(sender As Object, e As System.EventArgs) Handles btnManageQuestions.Click
        Dim sURL As String = "SurveyQuestions.aspx?SurveyTypeID=" + ddlSurveys.SelectedValue.ToString()
        Response.Redirect(sURL)
    End Sub
End Class