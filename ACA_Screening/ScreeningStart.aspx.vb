Imports System.Data.SqlClient
Imports System.Web.Services

Public Class ScreeningStartPage
    Inherits System.Web.UI.Page
    Public employerCode As String
    Private conStr As String = ConfigurationManager.ConnectionStrings("ACA_ScreeningConnectionString").ToString()
    Private STypeID, ContextID As Long
    Protected EmpCode, EmpName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        '**** Survey Type tells the screening control which survey to present.
        '**** The "Context" (i.e. QuestionSetType) defines the context of the scoring for a given Scenario
        '**** A "Scenario" (i.e. QuestionSet) is defined by key answers (up to 5) to reach a conclusion about the qualification or suitability of the person being screened.

        '**** SET SurveTypeID 
        STypeID = 2
        '**** SET Context (i.e. QuestionSetTypeID)
        ContextID = 2

        EmpCode = ""
        If Not IsPostBack Then
            'divShade.Visible = False
            divQuestions.Visible = False
            divEligible.Visible = False
            divNotEligible.Visible = False


            '****    URL = ScreeningStart.aspx?EmpCode=(EmployerCode)
            Try : EmpCode = Request.QueryString("EmpCode").ToString() : Catch : EmpCode = "" : End Try
            divInvalidEmpCode.Style("display") = "none"


            '**** TEST Employer Code  
            '         EmpCode = "TT"  '123"


            If EmpCode <> "" Then
                txtEmployerCd.Text = EmpCode
                EmpName = GetEmployerName(EmpCode)
                If EmpName <> "" Then
                    txtEmpName.Text = EmpName
                    txtEmployerCd.Enabled = False
                    txtEmpName.Enabled = False
                    divShade.Style("display") = "none"     'Visible = False
                Else
                    txtEmployerCd.Enabled = True

                    '*** Invalid Employer Code from URL 
                    lblWarning.Text = "The employer code provided was invalid.&nbsp;&nbsp;Please contact your employer's HR department to obtain the correct Employer Code for you to complete this screening process."
                    divInvalidEmpCode.Style("display") = "block"
                    txtEmployerCd.Text = ""
                    txtEmpName.Text = ""
                    divShade.Style("display") = "block"  'Visible = True
                End If
            End If
        End If

        ' ***************
        '    Test Input Data
        txtEmployeeNo.Text = "Hue23"
        txtEmployerCd.Text = "TT123"
        txtFirstName.Text = "Larry"
        txtLastName.Text = "Henderson"
        txtDOB.Text = "1/1/2000"
        txtSSN.Text = "123-02-8734"
        ' ***************
        acaScreeningQuestions.ConnectionString = conStr
        acaScreeningQuestions.SurveyTypeID = STypeID
        acaScreeningQuestions.AllowNotes = False

        'txtEmployeeNo.Focus()

        'ViewState("numItems") = 4
        'acaIncomeCalc.numItems = 4

    End Sub


    Private Sub ScreeningQuestionLoaded(ByVal sender As Object, ByVal e As ScreeningQuestionLoadedEventArgs) Handles acaScreeningQuestions.ScreeningQuestionLoaded
        Dim tst As Long
        Dim qt1 As String = ""
        Dim cnn As New SqlConnection(conStr)
        Dim cmd As New SqlCommand
        Dim dr As SqlDataReader

        tst = acaScreeningQuestions.CurrentQuestionID
        cmd.Connection = cnn
        cmd.CommandText = "Select QuestionText FROM tblScreening_Questions WHERE (ID = " & tst & ")"
        cmd.CommandType = CommandType.Text
        cnn.Open()
        dr = cmd.ExecuteReader()
        If dr.Read() Then
            qt1 = dr("QuestionText")
        End If
        dr.Close()
        cnn.Close()
        cmd = Nothing
        cnn = Nothing

        If (qt1.IndexOf("income") > -1) And (qt1.IndexOf("household") > -1) Then


            divIncomeCalc.Attributes.CssStyle("display") = "block"


            divCloseBtn.Attributes.CssStyle("display") = "block"




        End If
    End Sub

    Private Sub ScreeningComplete(ByVal sender As Object, ByVal e As ScreeningCompletedEventArgs) Handles acaScreeningQuestions.ScreeningCompleted
        'Session("ScreeningLogID") = e.ScreeningID

        If (acaScreeningQuestions.Results_Scores(ContextID) = acaScreeningQuestions.Results_MaxScores(ContextID)) And (acaScreeningQuestions.Results_Scores(ContextID) > 0) Then
            divEligible.Visible = True
            divNotEligible.Visible = False
            Session("ScreeningStatus") = "Pass"
        Else
            '--- Check to see what the last question/answer provided was
            Dim cnn As New SqlConnection(conStr)
            cnn.Open()
            Dim cmd As New SqlCommand("prcScreening_GET_LastScreeningAnswerInfo_ForScreeningLogID", cnn)
            cmd.CommandType = CommandType.StoredProcedure
            With cmd.Parameters
                .Add("ScreeningID", SqlDbType.BigInt).Value = e.ScreeningID
                .Add("LastQuestionID", SqlDbType.BigInt).Direction = ParameterDirection.Output
                .Add("LastQuestionText", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output
                .Add("LastAnswerID", SqlDbType.BigInt).Direction = ParameterDirection.Output
                .Add("LastAnswerText", SqlDbType.VarChar, 200).Direction = ParameterDirection.Output
                .Add("LastAnswerValue", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output
                .Add("LastAnswerNotes", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output
            End With
            cmd.ExecuteNonQuery()
            divNotEligible.Visible = True
            divEligible.Visible = False
            Session("ScreeningStatus") = "Fail"
            If cmd.Parameters("LastQuestionText").Value.ToString().Contains("on Medicaid") Then
                lblNegativeResponse.Text = "Because you are already on Medicaid, you are likely already utilizing the most affordable coverage available to you.<br><br><span style='text-align: center'>Thank you for completing this screening.</span>"
            ElseIf cmd.Parameters("LastQuestionText").Value.ToString().Contains("employer-provided insurance") Then
                lblNegativeResponse.Text = "It appears that you have already determined a better option for healthcare coverage than those offered by your employer, so we do not need to ask you any further questions.<br><br><span style='text-align: center'>Thank you for completing this screening.</span>"
            Else
                lblNegativeResponse.Text = "It appears that your best option for health insurance coverage may be the insurance offered by your employer. It does not " & _
                    "appear that you would qualify for Medicaid in your state, although there are some less common situations for which we did " & _
                    "not screen which could still qualify you for Medicaid."
            End If
            cnn.Close()
        End If
    End Sub

    Protected Sub btnStart_Click(sender As Object, e As EventArgs) Handles btnStart.Click
        Dim rec As Long

        Session("EmployerCode") = txtEmployerCd.Text
        divShade.Style("display") = "block"
        divQuestions.Visible = True
        rec = CreateScreenedPersonRecord()
        Session("ScreenerID") = rec
        acaScreeningQuestions.ScreenerID = rec
        '--- Make sure ConnectionString, ScreenerID, and SurveyTypeID properties are set prior to calling CreateScreening() or nothing will happen.
        '--- Depending on the hosting application, you may also want to set the OtherReferenceID property before creating the screening, as well.
        Session("ScreeningLogID") = acaScreeningQuestions.CreateScreening()
    End Sub

    Protected Sub btnEligible_Click(sender As Object, e As EventArgs) Handles btnEligible.Click
        Response.Redirect("~/ScreeningSuccess.aspx")
    End Sub

    Protected Sub btnNotEligible_Click(sender As Object, e As EventArgs) Handles btnNotEligible.Click
        Response.Redirect("~/ScreeningStart.aspx")
    End Sub

    Private Function CreateScreenedPersonRecord() As Long
        Dim Rec As Integer = 0
        Dim cnn As New SqlConnection(conStr)
        Dim cmd As New SqlCommand
        Dim BDate As Date

        DateTime.TryParse(txtDOB.Text, BDate)
        With cmd
            .Connection = cnn
            .CommandText = "prcScreening_ADD_ScreenedPersonRecord"
            .CommandType = CommandType.StoredProcedure
            With .Parameters
                .Add("@FirstName", SqlDbType.VarChar, 35).Value = txtFirstName.Text
                .Add("@LastName", SqlDbType.VarChar, 35).Value = txtLastName.Text
                .Add("@SSN", SqlDbType.VarChar, 10).Value = txtSSN.Text
                .Add("@DOB", SqlDbType.DateTime).Value = BDate
                .Add("@EmployerCode", SqlDbType.VarChar, 50).Value = txtEmployerCd.Text
                .Add("@EmployeeID", SqlDbType.VarChar, 50).Value = txtEmployeeNo.Text
                .Add("@RecNo", SqlDbType.BigInt)
                cmd.Parameters("@RecNo").Direction = ParameterDirection.Output
            End With
            cnn.Open()
            .ExecuteNonQuery()
        End With
        Rec = CInt(cmd.Parameters("@RecNo").Value.ToString())
        cmd = Nothing
        cnn.Close()
        cnn = Nothing
        Return Rec
    End Function

    Public Function GetEmployerName(ByVal EmpCd As String) As String
        Dim cnn As New SqlConnection(conStr)
        Dim cmd As New SqlCommand
        Dim dr As SqlDataReader
        Dim ecd As String = ""

        With cmd
            .Connection = cnn
            .CommandText = "SELECT CompanyName FROM tblClientInfo_Clients WHERE (EmployerCode = @EmpCode)"
            .CommandType = CommandType.Text
            With .Parameters
                .Add("@EmpCode", SqlDbType.VarChar, 15).Value = EmpCd
            End With
            cnn.Open()
            dr = cmd.ExecuteReader()
            If dr.Read() Then
                ecd = CStr(dr("CompanyName"))
            End If
            dr.Close()
            cnn.Close()
            cmd = Nothing
            cnn = Nothing
        End With
        Return ecd
    End Function

    Private Sub txtEmployerCd_TextChanged(sender As Object, e As System.EventArgs) Handles txtEmployerCd.TextChanged
        Dim cd As String = GetEmployerName(txtEmployerCd.Text)
        If cd = "" Then
            '*** Show Invalid Employer Code Warning
            'divShade.Visible = True
            divShade.Style("display") = "block"
            divInvalidEmpCode.Style("display") = "block"

            '*** Invalid Employer Code from User input 
            lblWarning.Text = "You have entered an employer code that is invalid. <br /><br /><br />"
            txtEmpName.Text = ""
            txtEmployerCd.Text = ""
        Else
            'divShade.Visible = False
            divShade.Style("display") = "none"
            divInvalidEmpCode.Style("display") = "none"
            txtEmpName.Text = cd
            txtEmpName.Enabled = False
            txtEmployerCd.Enabled = False
        End If
    End Sub
End Class
