Imports System.Data.SqlClient

Public Class ScreeningSuccess
    Inherits System.Web.UI.Page

    Protected StateProv As String
    Private conStr As String = ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString()


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            divCompChart.Style("display") = "none"
            hidScreenedPersonID.Value = Session("ScreenerID")
            fvScreenedPerson.ChangeMode(FormViewMode.Edit)
            hidStateProv.Value = GetStateFromQuestionnareRecord(Session("ScreeningLogID"))
        Else
            divCompChart.Style("display") = "block"
        End If
    End Sub

    Private Function GetStateFromQuestionnareRecord(ByVal SLID As Long)
        Dim cnn As New SqlConnection(conStr)
        Dim cmd As New SqlCommand
        Dim dr As SqlDataReader
        Dim stateprov As String = ""

        cnn.Open()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.Text
        cmd.CommandText = "Select ans.Answer_Text as StateProv FROM tblScreening_Log_Answers la INNER JOIN tblScreening_Answers ans " & _
            " ON la.AnswerID = ans.ID WHERE (ans.QuestionID = 5) AND (la.screeningLogID = @ScreeningLogID)"
        With cmd.Parameters
            .Clear()
            .Add("@ScreeningLogID", SqlDbType.BigInt)
        End With
        cmd.Parameters("@ScreeningLogID").Value = SLID
        dr = cmd.ExecuteReader()
        If dr.Read() Then
            stateprov = CStr(dr("StateProv"))
        End If
        dr.Close()
        cnn.Close()
        Return stateprov
    End Function





End Class