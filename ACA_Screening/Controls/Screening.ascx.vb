Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net.Mail
Imports System.Text.RegularExpressions

#Region "Custom EventArgs Classes"
Public Class ScreeningCompletedEventArgs
    Inherits System.EventArgs
    Private _screeningID, _screenerID, _otherReferenceID As Long
    Private _questionSetIDs As Dictionary(Of Long, Long)
    Private _maxScores, _scores, _scorePercentages, _thresholdRed, _thresholdOrange, _thresholdYellow, _thresholdGreen As Dictionary(Of Long, Double)

#Region "Public Properties"

    Public ReadOnly Property ScreeningID As Long
        Get
            Return _screeningID
        End Get
    End Property

    Public ReadOnly Property ScreenerID As Long
        Get
            Return _screenerID
        End Get
    End Property

    Public ReadOnly Property OtherReferenceID As Long
        Get
            Return _otherReferenceID
        End Get
    End Property

    Public ReadOnly Property QuestionSetIDs As Dictionary(Of Long, Long)
        Get
            Return _questionSetIDs
        End Get
    End Property

    Public ReadOnly Property MaxScores As Dictionary(Of Long, Double)
        Get
            Return _maxScores
        End Get
    End Property

    Public ReadOnly Property Scores As Dictionary(Of Long, Double)
        Get
            Return _scores
        End Get
    End Property

    Public ReadOnly Property ScorePercentages As Dictionary(Of Long, Double)
        Get
            Return _scorePercentages
        End Get
    End Property

    Public ReadOnly Property ThresholdRed As Dictionary(Of Long, Double)
        Get
            Return _thresholdRed
        End Get
    End Property

    Public ReadOnly Property ThresholdOrange As Dictionary(Of Long, Double)
        Get
            Return _thresholdOrange
        End Get
    End Property

    Public ReadOnly Property ThresholdYellow As Dictionary(Of Long, Double)
        Get
            Return _thresholdYellow
        End Get
    End Property

    Public ReadOnly Property ThresholdGreen As Dictionary(Of Long, Double)
        Get
            Return _thresholdGreen
        End Get
    End Property

#End Region

    Sub New(ByVal screeningID As Long, ByVal screenerID As Long, ByVal otherReferenceID As Long, ByVal questionSetIDs As Dictionary(Of Long, Long), ByVal maxScores As Dictionary(Of Long, Double), ByVal scores As Dictionary(Of Long, Double), ByVal scorePercentages As Dictionary(Of Long, Double), ByVal thresholdRed As Dictionary(Of Long, Double), ByVal thresholdOrange As Dictionary(Of Long, Double), ByVal thresholdYellow As Dictionary(Of Long, Double), ByVal thresholdGreen As Dictionary(Of Long, Double))
        _screenerID = screenerID
        _screeningID = screeningID
        _otherReferenceID = otherReferenceID
        _questionSetIDs = questionSetIDs
        _maxScores = maxScores
        _scores = scores
        _scorePercentages = scorePercentages
        _thresholdRed = thresholdRed
        _thresholdOrange = thresholdOrange
        _thresholdYellow = thresholdYellow
        _thresholdGreen = thresholdGreen
    End Sub
End Class

Public Class ScreeningQuestionLoadedEventArgs
    Inherits System.EventArgs
    Private _questionID As Long
    Private _alreadyAnswered As Boolean
    Private _callingQuestionID As Long
    Private _questionSequence As Short
    Private _screeningID As Long
    Private _progressPrct As Double

#Region "Public Properties"
    Public ReadOnly Property QuestionID As Long
        Get
            Return _questionID
        End Get
    End Property

    Public ReadOnly Property AlreadyAnswered As Boolean
        Get
            Return _alreadyAnswered
        End Get
    End Property

    Public ReadOnly Property CallingQuestionID As Long
        Get
            Return _callingQuestionID
        End Get
    End Property

    Public ReadOnly Property QuestionSequence As Short
        Get
            Return _questionSequence
        End Get
    End Property

    Public ReadOnly Property ScreeningID As Long
        Get
            Return _screeningID
        End Get
    End Property

    Public ReadOnly Property ProgressPrct As Double
        Get
            Return _progressPrct
        End Get
    End Property
#End Region

    Sub New(questionID As Long, questionSequence As Short, screeningID As Long, alreadyAnswered As Boolean, callingQuestionID As Long, progressPrct As Double)
        _questionID = questionID
        _questionSequence = questionSequence
        _screeningID = screeningID
        _alreadyAnswered = alreadyAnswered
        _callingQuestionID = callingQuestionID
        _progressPrct = progressPrct
    End Sub
End Class
#End Region

Public Class ScreeningWizard
    Inherits System.Web.UI.UserControl

#Region "Event Definitions"
    'Public Delegate Sub ScreeningCompletedEventHandler(e As ScreeningCompletedEventArgs)
    'Public Delegate Sub ScreeningQuestionLoadedEventHandler(e As ScreeningQuestionLoadedEventArgs)
    '--- keeping it simple and using predefined Delegate type (EventHandler(Of <type>))
    Public Event ScreeningCompleted As EventHandler(Of ScreeningCompletedEventArgs)
    Public Event ScreeningQuestionLoaded As EventHandler(Of ScreeningQuestionLoadedEventArgs)
#End Region

#Region "Public Properties"
    Public Property UserID As String
        Get
            Dim o As Object = ViewState("UserID")
            If IsNothing(o) Then
                Return ""
            Else
                Return CStr(o)
            End If
        End Get
        Set(value As String)
            ViewState("UserID") = value
        End Set
    End Property
    Public Property ScreeningID As Long
        Get
            Dim o As Object = ViewState("ScreeningID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("ScreeningID") = value
            srcAnswers.SelectParameters("QuestionID").DefaultValue = Me.CurrentQuestionID
            srcAnswers.SelectParameters("ScreeningLogID").DefaultValue = value
        End Set
    End Property
    Public Property ScreenerID As Long
        Get
            Dim o As Object = ViewState("ScreenerID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("ScreenerID") = value
        End Set
    End Property
    Public Property ConnectionString As String
        Get
            Dim o As Object = ViewState("ConnectionString")
            If IsNothing(o) Then
                Return ""
            Else
                Return CStr(o)
            End If
        End Get
        Set(value As String)
            ViewState("ConnectionString") = value
            srcQuestion.ConnectionString = value
            srcAnswers.ConnectionString = value
        End Set
    End Property
    Public Property SurveyTypeID As Long   '--- Identifies survey type - must be provided by parent page.
        Get
            Dim o As Object = ViewState("SurveyTypeID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("SurveyTypeID") = value
        End Set
    End Property
    Public Property CurrentQuestionID As Long
        Get
            Dim o As Object = ViewState("CurrentQuestionID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("CurrentQuestionID") = value
            srcQuestion.SelectParameters("QuestionID").DefaultValue = value
            srcAnswers.SelectParameters("QuestionID").DefaultValue = value
            srcAnswers.SelectParameters("ScreeningLogID").DefaultValue = Me.ScreeningID
        End Set
    End Property
    Public Property CurrentQuestionSequence As Short
        Get
            Dim o As Object = ViewState("CurrentQuestionSequence")
            If IsNothing(o) Then
                Return 0
            Else
                Return CShort(o)
            End If
        End Get
        Set(value As Short)
            ViewState("CurrentQuestionSequence") = value
        End Set
    End Property
    Public Property QuestionsAnswered As Short
        Get
            Dim o As Object = ViewState("QuestionsAnswered")
            If IsNothing(o) Then
                Return 0
            Else
                Return CShort(o)
            End If
        End Get
        Set(value As Short)
            ViewState("QuestionsAnswered") = value
        End Set
    End Property
    Public Property TotalQuestions As Short
        Get
            Dim o As Object = ViewState("TotalQuestions")
            If IsNothing(o) Then
                Return 0
            Else
                Return CShort(o)
            End If
        End Get
        Set(value As Short)
            ViewState("TotalQuestions") = value
        End Set
    End Property
    Public Property ProgressPercentage As Double
        Get
            Dim o As Object = ViewState("ProgressPercentage")
            If IsNothing(o) Then
                Return 0.0
            Else
                Return CDbl(o)
            End If
        End Get
        Set(value As Double)
            ViewState("ProgressPercentage") = value
        End Set
    End Property
    Public Property CallingQuestionID As Long
        Get
            Dim o As Object = ViewState("CallingQuestionID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("CallingQuestionID") = value
        End Set
    End Property
    Public Property OtherReferenceID As Long
        Get
            Dim o As Object = ViewState("OtherReferenceID")
            If IsNothing(o) Then
                Return 0
            Else
                Return CLng(o)
            End If
        End Get
        Set(value As Long)
            ViewState("OtherReferenceID") = value
        End Set
    End Property
    Public Property AllowNotes As Boolean
        Get
            Dim o As Object = ViewState("AllowNotes")
            If IsNothing(o) Then
                Return False
            Else
                Return CBool(o)
            End If
        End Get
        Set(value As Boolean)
            ViewState("AllowNotes") = value
        End Set
    End Property
    Public Property AlreadyAnswered As Boolean
        Get
            Dim o As Object = ViewState("AlreadyAnswered")
            If IsNothing(o) Then
                Return False
            Else
                Return CBool(o)
            End If
        End Get
        Set(value As Boolean)
            ViewState("AlreadyAnswered") = value
        End Set
    End Property
    Public Property ShowProgress As Boolean
        Get
            Dim o As Object = ViewState("ShowProgress")
            If IsNothing(o) Then
                Return False
            Else
                Return CBool(o)
            End If
        End Get
        Set(value As Boolean)
            ViewState("ShowProgress") = value
        End Set
    End Property
    Public Property ShowResults As Boolean
        Get
            Dim o As Object = ViewState("ShowResults")
            If IsNothing(o) Then
                Return False
            Else
                Return CBool(o)
            End If
        End Get
        Set(value As Boolean)
            ViewState("ShowResults") = value
        End Set
    End Property

    '--- These properties do NOT maintain values across postback
    '<QSetTypeID, QuestionSetIDs>
    Public Property Results_QuestionSetIDs As New Dictionary(Of Long, Long)
    '<QSetTypeID, MaxScore>
    Public Property Results_MaxScores As New Dictionary(Of Long, Double)
    '<QSetTypeID, Score>
    Public Property Results_Scores As New Dictionary(Of Long, Double)
    '<QSetTypeID, ScorePercent>
    Public Property Results_ScorePercentages As New Dictionary(Of Long, Double)
    '<QSetTypeID, RedZoneLimit>
    Public Property Results_RedZoneLimit As New Dictionary(Of Long, Double)
    '<QSetTypeID, OrangeZoneLimit>
    Public Property Results_OrangeZoneLimit As New Dictionary(Of Long, Double)
    '<QSetTypeID, YellowZoneLimit>
    Public Property Results_YellowZoneLimit As New Dictionary(Of Long, Double)
    '<QSetTypeID, GreenZoneLimit>
    Public Property Results_GreenZoneLimit As New Dictionary(Of Long, Double)
#End Region

#Region "Page & Control Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Me.ConnectionString <> "" Then
            Me.srcQuestion.ConnectionString = Me.ConnectionString
            Me.srcAnswers.ConnectionString = Me.ConnectionString
        End If
    End Sub

    Private Sub fvQuestion_DataBound(sender As Object, e As System.EventArgs) Handles fvQuestion.DataBound
        Dim src As SqlDataSource = srcAnswers

        '--- Find pnlNotesContainer
        Dim pnlNotes = CType(fvQuestion.FindControl("pnlNotesContainer"), Panel)
        '--- Set to visible if AllowNotes is true and the panel is found
        If Not IsNothing(pnlNotes) Then
            pnlNotes.Visible = AllowNotes
            'pnlNotes.Style("visibility") = "visible"
        End If


        Dim pnl As Panel = CType(fvQuestion.FindControl("pnlAnswers"), Panel)
        If Not IsNothing(pnl) Then
            '--- Check to see if Panel already has a control named "ctrlAnswer"
            If IsNothing(pnl.FindControl("ctrlAnswer")) Then
                '--- Check current question to determine how the answers should be presented (i.e. QuestionType)
                Dim row As DataRowView = CType(fvQuestion.DataItem(), DataRowView)
                '--- Create appropriate control(s) and add to the formview answer panel
                Select Case row("QuestionType").ToString()
                    Case "DropDownList"
                        Dim ddl As New DropDownList
                        ddl.ID = "ctrlAnswer"
                        ddl.DataSource = src
                        ddl.DataTextField = "Answer_Text"
                        ddl.DataValueField = "AnswerID"
                        pnl.Controls.Add(ddl)
                        ddl.DataBind()
                    Case Else
                        Dim rbl As New RadioButtonList
                        rbl.DataSource = src
                        rbl.ID = "ctrlAnswer"
                        rbl.DataTextField = "Answer_Text"
                        rbl.DataValueField = "AnswerID"
                        pnl.Controls.Add(rbl)
                        rbl.DataBind()
                End Select
            End If

            SetExistingAnswer()
        End If
    End Sub

    Private Sub btnPrevious1_Click(sender As Object, e As System.EventArgs) Handles btnPrevious1.ServerClick
        '--- Save selected answer
        SaveSelectedAnswer()
        '--- Get Next question
        GetPreviousQuestion()
    End Sub

    Private Sub btnNext1_Click(sender As Object, e As System.EventArgs) Handles btnNext1.ServerClick
        '--- Save selected answer
        SaveSelectedAnswer()
        '--- Get Previous question
        GetNextQuestion()
    End Sub
#End Region

#Region "Public Methods"
    Public Function CreateScreening() As Int32
        '--- ToDo: Test ConnectionString property in try-catch before continuing

        If Me.ScreeningID = 0 And Me.ScreenerID <> 0 And Me.SurveyTypeID <> 0 Then
            Dim cnn As New SqlConnection(Me.ConnectionString)
            cnn.Open()
            Dim cmd As New SqlCommand()
            cmd.Connection = cnn
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "prcScreening_ADD_ScreeningLog"
            With cmd.Parameters
                .Add("@ScreenerID", SqlDbType.BigInt).Value = Me.ScreenerID
                .Add("@Rep_UserID", SqlDbType.VarChar, 50).Value = Me.UserID
                .Add("@OtherReferenceID", SqlDbType.BigInt).Value = Me.OtherReferenceID
                .Add("@StartTime_DT", SqlDbType.DateTime).Value = Date.Now()
                .Add("@OUT_ScreeningLogID", SqlDbType.BigInt).Direction = ParameterDirection.Output
            End With
            cmd.ExecuteNonQuery()
            Me.ScreeningID = cmd.Parameters("@OUT_ScreeningLogID").Value
            '--- Get first question and bind controls
            GetNextQuestion()

            cnn.Close()
        End If

        Return Me.ScreeningID
    End Function
#End Region

#Region "Private Methods"
    Private Sub GetNextQuestion()
        Dim cnn As New SqlConnection(Me.ConnectionString)
        cnn.Open()
        Dim cmd As New SqlCommand()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "prcScreening_GET_NextQuestionID"
        With cmd.Parameters
            .Add("@CurrentQuestionID", SqlDbType.BigInt).Value = Me.CurrentQuestionID
            .Add("@ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@SurveyTypeID", SqlDbType.BigInt).Value = Me.SurveyTypeID
            .Add("@OUT_NextQuestionID", SqlDbType.BigInt).Direction = ParameterDirection.Output
            .Add("@OUT_NextQuestionSequence", SqlDbType.Int).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()

        If (cmd.Parameters("@OUT_NextQuestionID").Value <> 0) Then
            Me.CurrentQuestionID = cmd.Parameters("@OUT_NextQuestionID").Value
            Me.CurrentQuestionSequence = cmd.Parameters("@OUT_NextQuestionSequence").Value
        Else
            '--- Display results panel if question just answered was the last question.
            cnn.Close()

            CalculateResults()
            UpdateProgress(True)

            Me.CurrentQuestionID = 0
            Me.CurrentQuestionSequence = 0
            RaiseEvent ScreeningCompleted(Me, New ScreeningCompletedEventArgs(Me.ScreeningID, Me.ScreenerID, Me.OtherReferenceID, Me.Results_QuestionSetIDs, Me.Results_MaxScores, Me.Results_Scores, Me.Results_ScorePercentages, Me.Results_RedZoneLimit, Me.Results_OrangeZoneLimit, Me.Results_YellowZoneLimit, Me.Results_GreenZoneLimit))
            Exit Sub
        End If

        fvQuestion.DataBind()

        cnn.Close()
    End Sub

    Private Sub GetPreviousQuestion()
        Dim cnn As New SqlConnection(Me.ConnectionString)
        cnn.Open()
        Dim cmd As New SqlCommand()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "prcScreening_GET_PreviousQuestionID"
        With cmd.Parameters
            .Add("@CurrentQuestionID", SqlDbType.BigInt).Value = Me.CurrentQuestionID
            .Add("@ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@SurveyTypeID", SqlDbType.BigInt).Value = Me.SurveyTypeID
            .Add("@OUT_PreviousQuestionID", SqlDbType.BigInt).Direction = ParameterDirection.Output
            .Add("@OUT_PreviousQuestionSequence", SqlDbType.Int).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()
        If (cmd.Parameters("@OUT_PreviousQuestionID").Value <> 0) Then
            Me.CurrentQuestionID = cmd.Parameters("@OUT_PreviousQuestionID").Value
            Me.CurrentQuestionSequence = cmd.Parameters("@OUT_PreviousQuestionSequence").Value
        End If
        '--- If Previous Question was not found, leave screen on the current (i.e. the first) question.

        fvQuestion.DataBind()

        cnn.Close()

    End Sub

    Private Sub SaveSelectedAnswer()
        Dim cnn As New SqlConnection(Me.ConnectionString)
        cnn.Open()
        Dim cmd As New SqlCommand()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "prcScreening_ADD_ScreeningLogAnswer"
        With cmd.Parameters
            .Add("@ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@AnswerID", SqlDbType.BigInt).Value = 0
            '--- ToDo: implement saving of value and notes fields.
            .Add("@Value", SqlDbType.VarChar, 250).Value = DBNull.Value
            .Add("@Notes", SqlDbType.VarChar, 500).Value = DBNull.Value
        End With

        '--- find the Answer value passed from form for the dynamically created Answer control
        '--- The control itself, may not exist in the FormView
        Dim key As String
        For Each key In Request.Form.AllKeys
            If key.EndsWith("ctrlAnswer") Then
                cmd.Parameters("@AnswerID").Value = CInt(Request(key))
                Exit For
            End If
        Next

        'Dim ctrl As Control = CType(fvQuestion.FindControl("pnlAnswers"), Panel).FindControl("ctrlAnswer")
        'Select Case ctrl.GetType().Name.ToLower()
        '    Case "dropdownlist"
        '        cmd.Parameters("@AnswerID").Value = CType(ctrl, DropDownList).SelectedValue
        '    Case "radiobuttonlist"
        '        cmd.Parameters("@AnswerID").Value = CType(ctrl, RadioButtonList).SelectedValue
        'End Select

        'Dim rpt As Repeater = CType(fvQuestion.FindControl("rptAnswers"), Repeater)
        'Dim rb As HtmlInputRadioButton
        'Dim ansID As Int32
        'For Each itm As RepeaterItem In rpt.Items
        '    rb = CType(itm.FindControl("rbAnswer"), HtmlInputRadioButton)
        '    ansID = rb.Value
        '    If rb.Checked Then
        '        cmd.Parameters("@AnswerID").Value = ansID
        '        '--- ToDo: FUTURE: Implement determination of Answer "Value" here... 
        '        '--- Questions will have a "Structure" and a "DataType" that will determine how the interface is rendered.  We will deal with different
        '        '--- structures here.
        '        'cmd.Parameters("@Value").Value = ?

        '        Exit For
        '    End If
        'Next
        Dim tb As TextBox
        If cmd.Parameters("@AnswerID").Value <> 0 Then
            tb = CType(fvQuestion.FindControl("txtNotes"), TextBox)
            If tb.Text <> "" Then
                cmd.Parameters("@Notes").Value = tb.Text
            End If
            cmd.ExecuteNonQuery()
        End If

        cnn.Close()
    End Sub

    Private Sub CalculateResults()
        Dim cnn As New SqlConnection(Me.ConnectionString)
        'cnn.Open()
        Dim cmd As New SqlCommand("SELECT DISTINCT QuestionSetTypeID FROM tblScreening_QuestionSets WHERE SurveyTypeID = @SurveyTypeID", cnn)
        Dim dr As SqlDataReader

        '--- Get list of all QuestionSetTypes related to survey type
        cnn.Open()
        cmd.Parameters.Add("@SurveyTypeID", SqlDbType.BigInt).Value = Me.SurveyTypeID
        dr = cmd.ExecuteReader()

        '--- For each QuestionSetType, get scoring details and store in Dictionary properties.
        While (dr.Read())
            GetScoringDetails(dr("QuestionSetTypeID"))
        End While
        dr.Close()


        '--- ToDo: If control is set to Show Results, dynamically build-out result indicator bars and display results panel
        If Me.ShowResults Then

        End If

        'Dim color As String

        'divS_GuageLvl1.Style.Item("height") = Math.Round(200 * hidS_RedZone_Limit.Value).ToString() + "px"
        'divS_GuageLvl1.Style.Item("background-color") = "Red"
        'divS_GuageLvl2.Style.Item("height") = Math.Round(200 * (hidS_OrangeZone_Limit.Value - hidS_RedZone_Limit.Value)).ToString() + "px"
        'divS_GuageLvl2.Style.Item("background-color") = "Orange"
        'divS_GuageLvl3.Style.Item("height") = Math.Round(200 * (hidS_YellowZone_Limit.Value - hidS_OrangeZone_Limit.Value)).ToString() + "px"
        'divS_GuageLvl3.Style.Item("background-color") = "Yellow"
        'divS_GuageLvl4.Style.Item("height") = Math.Round(200 * (hidS_GreenZone_Limit.Value - hidS_YellowZone_Limit.Value)).ToString() + "px"
        'divS_GuageLvl4.Style.Item("background-color") = "Green"

        'divE_GuageLvl1.Style.Item("height") = Math.Round(200 * (hidE_RedZone_Limit.Value)).ToString() + "px"
        'divE_GuageLvl1.Style.Item("background-color") = "Red"
        'divE_GuageLvl2.Style.Item("height") = Math.Round(200 * (hidE_OrangeZone_Limit.Value - hidE_RedZone_Limit.Value)).ToString() + "px"
        'divE_GuageLvl2.Style.Item("background-color") = "Orange"
        'divE_GuageLvl3.Style.Item("height") = Math.Round(200 * (hidE_YellowZone_Limit.Value - hidE_OrangeZone_Limit.Value)).ToString() + "px"
        'divE_GuageLvl3.Style.Item("background-color") = "Yellow"
        'divE_GuageLvl4.Style.Item("height") = Math.Round(200 * (hidE_GreenZone_Limit.Value - hidE_YellowZone_Limit.Value)).ToString() + "px"
        'divE_GuageLvl4.Style.Item("background-color") = "Green"

        'divRatingSuitability.Style.Item("height") = Math.Round(200 * hidS_Prct.Value).ToString() + "px"
        'divRatingSuitability.Style.Item("margin-top") = (200 - Math.Round(200 * hidS_Prct.Value)).ToString() + "px"
        'lblSuitabilityPrct.Text = String.Format("{0:#.0%}", Convert.ToDouble(hidS_Prct.Value))
        'If hidS_Prct.Value <= hidS_RedZone_Limit.Value Then
        '    color = "Red"
        'ElseIf hidS_Prct.Value <= hidS_OrangeZone_Limit.Value Then
        '    color = "Orange"
        'ElseIf hidS_Prct.Value <= hidS_YellowZone_Limit.Value Then
        '    color = "Yellow"
        'Else
        '    color = "Green"
        'End If
        'divRatingSuitability.Style.Item("background-color") = color

        'divRatingEmployability.Style.Item("height") = Math.Round(200 * hidE_Prct.Value).ToString() + "px"
        'divRatingEmployability.Style.Item("margin-top") = (200 - Math.Round(200 * hidE_Prct.Value)).ToString() + "px"
        'lblEmployabilityPrct.Text = String.Format("{0:#.0%}", Convert.ToDouble(hidE_Prct.Value))
        'If hidE_Prct.Value <= hidE_RedZone_Limit.Value Then
        '    color = "Red"
        'ElseIf hidE_Prct.Value <= hidE_OrangeZone_Limit.Value Then
        '    color = "Orange"
        'ElseIf hidE_Prct.Value <= hidE_YellowZone_Limit.Value Then
        '    color = "Yellow"
        'Else
        '    color = "Green"
        'End If
        'divRatingEmployability.Style.Item("background-color") = color

        'pnlQuestionaire.Visible = False
        'pnlResults.Visible = True

        cnn.Close()
    End Sub

    Private Sub GetScoringDetails(QuestionSetTypeID As Int32)
        Dim cnn As New SqlConnection(Me.ConnectionString)
        Dim cmd As New SqlCommand()
        Dim dr As SqlDataReader
        Dim QSID As Int32

        cnn.Open()
        cmd.Connection = cnn
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "prcScreening_GET_ScoreInfoForScreeningLog"
        With cmd.Parameters
            .Add("@ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@QuestionSetTypeID", SqlDbType.BigInt).Value = QuestionSetTypeID
            .Add("@OUT_QuestionSetID", SqlDbType.BigInt).Direction = ParameterDirection.Output
            .Add("@OUT_Score", SqlDbType.Decimal).Direction = ParameterDirection.Output
            .Add("@OUT_MaxScore", SqlDbType.Decimal).Direction = ParameterDirection.Output
            .Add("@OUT_MinScore", SqlDbType.Decimal).Direction = ParameterDirection.Output
            .Add("@OUT_WeightedPercentage", SqlDbType.Decimal).Direction = ParameterDirection.Output
        End With
        cmd.Parameters("@OUT_Score").Precision = 18
        cmd.Parameters("@OUT_Score").Scale = 4
        cmd.Parameters("@OUT_MaxScore").Precision = 18
        cmd.Parameters("@OUT_MaxScore").Scale = 4
        cmd.Parameters("@OUT_MinScore").Precision = 18
        cmd.Parameters("@OUT_MinScore").Scale = 4
        cmd.Parameters("@OUT_WeightedPercentage").Precision = 18
        cmd.Parameters("@OUT_WeightedPercentage").Scale = 4
        cmd.ExecuteNonQuery()
        Me.Results_Scores(QuestionSetTypeID) = cmd.Parameters("@OUT_Score").Value
        Me.Results_MaxScores(QuestionSetTypeID) = cmd.Parameters("@OUT_MaxScore").Value
        Me.Results_ScorePercentages(QuestionSetTypeID) = cmd.Parameters("@OUT_WeightedPercentage").Value
        QSID = cmd.Parameters("@OUT_QuestionSetID").Value

        cmd.CommandType = CommandType.Text
        cmd.CommandText = "SELECT * FROM tblScreening_QuestionSets WHERE ID = @QuestionSetID"
        With cmd.Parameters
            .Clear()
            .Add("@QuestionSetID", SqlDbType.BigInt)
        End With

        cmd.Parameters("@QuestionSetID").Value = QSID
        dr = cmd.ExecuteReader()
        If dr.Read() Then
            Me.Results_RedZoneLimit(QuestionSetTypeID) = dr("Threshold_RedZone")
            Me.Results_OrangeZoneLimit(QuestionSetTypeID) = dr("Threshold_OrangeZone")
            Me.Results_YellowZoneLimit(QuestionSetTypeID) = dr("Threshold_YellowZone")
            Me.Results_GreenZoneLimit(QuestionSetTypeID) = dr("Threshold_GreenZone")
        End If
        dr.Close()

        cnn.Close()
    End Sub

    Private Sub UpdateProgress(Optional ByVal ForceComplete As Boolean = False)
        ' Dim bar1 As HtmlGenericControl = divProgress1
        ' Dim bar2 As HtmlGenericControl = divProgress2
        Dim QST_ID, QSID As Int32
        Dim barWidthTotal As Integer = 600


        Dim cnn As New SqlConnection(Me.ConnectionString)
        cnn.Open()
        Dim cmd As New SqlCommand()

        cmd.Connection = cnn
        '--- Use first available QuestionSetType (i.e. Context) available for the current survey
        cmd.CommandType = CommandType.Text
        cmd.CommandText = "SELECT TOP 1 @OUT_QuestionSetTypeID = QuestionSetTypeID FROM tblScreening_QuestionSets WHERE SurveyTypeID = @SurveyTypeID"
        cmd.Parameters.Add("@SurveyTypeID", SqlDbType.BigInt).Value = Me.SurveyTypeID
        cmd.Parameters.Add("@OUT_QuestionSetTypeID", SqlDbType.BigInt).Direction = ParameterDirection.Output
        cmd.ExecuteNonQuery()
        QST_ID = cmd.Parameters("@OUT_QuestionSetTypeID").Value

        '--- Determine most applicable QuestionSet for this screening so far.
        cmd.CommandText = "SELECT @OUT_QSetID = dbo.fncScreening_DetermineQuestionSetForScreeningLogAnswers(@ScreeningID, @QuestionSetTypeID)"
        With cmd.Parameters
            .Clear()
            .Add("@ScreeningID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@QuestionSetTypeID", SqlDbType.BigInt).Value = QST_ID
            .Add("@OUT_QSetID", SqlDbType.BigInt).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()
        QSID = cmd.Parameters("@OUT_QSetID").Value

        '--- Find out how many questions have been answered for this screening so far.
        cmd.CommandText = "SELECT @OUT_Count = COUNT(la.AnswerID) FROM tblScreening_Log_Answers la WHERE la.ScreeningLogID = @ScreeningLogID"
        cmd.CommandType = CommandType.Text
        With cmd.Parameters
            .Clear()
            .Add("@ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
            .Add("@OUT_Count", SqlDbType.Int).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()
        Me.QuestionsAnswered = cmd.Parameters("@OUT_Count").Value

        '--- Determine total number of questions based on applicable Question Set so far.
        cmd.CommandText = "SELECT @OUT_Count = COUNT(lnk.QuestionID) FROM tblScreening_LINK_QuestionsToSets lnk WHERE lnk.QuestionSetID = @QuestionSetID"
        With cmd.Parameters
            .Clear()
            .Add("@QuestionSetID", SqlDbType.BigInt).Value = QSID
            .Add("@OUT_Count", SqlDbType.Int).Direction = ParameterDirection.Output
        End With
        cmd.ExecuteNonQuery()
        Me.TotalQuestions = cmd.Parameters("@OUT_Count").Value

        '--- Connection not needed any longer
        cnn.Close()

        '--- specify new progress bar widths based on # of questions answered vs total questions
        If Not ForceComplete Then
            Me.ProgressPercentage = Me.QuestionsAnswered / (Me.TotalQuestions * 1.0)
        Else
            Me.ProgressPercentage = 1.0
        End If
        lblPrctComplete.Text = String.Format("{0:0%}", Me.ProgressPercentage)
        hidProgressPercentage.Value = String.Format("{0:0%}", Me.ProgressPercentage)
        '  bar1.Style.Item("width") = Math.Round(Me.ProgressPercentage * barWidthTotal).ToString() + "px"
        ' bar2.Style.Item("width") = Math.Round((1.0 - Me.ProgressPercentage) * barWidthTotal).ToString() + "px"

        '--- color progress bar based on % complete
        '--- R from 255 down to 100 (@ Green = 255)
        '--- G from 145 up to 255, then back down to 145
        '--- B from 0 up to 0
        '--- NOTE: might be better to just hard-code a few set colors like Red, Red-Orange, Orange, Yellow, and finally green based on % ranges rather than 
        '--- trying to gradually change the color...
        'Dim color As String
        'Dim x, y As Double
        'Dim RVal, GVal, BVal As Int16
        'If (Me.ProgressPercentage <= 0.5) Then
        '    GVal = 145 + Convert.ToInt16(Math.Round((255 - 145) * Me.ProgressPercentage * 2))
        '    RVal = 255
        '    BVal = 15
        'Else
        '    x = (Me.ProgressPercentage - 0.5)
        '    y = Math.Sqrt((0.5 * 0.5) - (x * x))
        '    GVal = 255 - Convert.ToInt16(Math.Round((255 - 170) * (x * 2)))
        '    RVal = 255 - Convert.ToInt16(Math.Round((255 - 100) * ((0.5 - y) * 2)))
        '    BVal = 15 + Convert.ToInt16(Math.Round((60 - 15) * (x * 2)))
        'End If

        'color = "#" + Hex(RVal).PadLeft(2, "0") + Hex(GVal).PadLeft(2, "0") + Hex(BVal).PadLeft(2, "0")
        'bar1.Style.Item("background-color") = color
    End Sub

    Private Sub SetExistingAnswer()
        Dim cnn As New SqlConnection(Me.ConnectionString)
        cnn.Open()
        Dim cmd As New SqlCommand()
        cmd.Connection = cnn

        '--- Get selected answer for question (if any) already provided and set selected item.
        '--- NOTE: "Value" field is not currently utilized... provided for for future modifications.
        cmd.CommandText = "SELECT la.AnswerID, la.Value, la.Notes FROM tblScreening_Log_Answers la INNER JOIN tblScreening_Answers ans ON (la.AnswerID = ans.ID) WHERE ans.QuestionID = @QuestionID AND la.ScreeningLogID = @ScreeningLogID"
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Clear()
        cmd.Parameters.Add("QuestionID", SqlDbType.BigInt).Value = Me.CurrentQuestionID
        cmd.Parameters.Add("ScreeningLogID", SqlDbType.BigInt).Value = Me.ScreeningID
        Dim dr As SqlDataReader = cmd.ExecuteReader()
        If dr.Read() Then
            Dim pnl As Panel = CType(fvQuestion.FindControl("pnlAnswers"), Panel)
            Dim ctrl As Control = CType(fvQuestion.FindControl("ctrlAnswer"), Control)
            Select Case ctrl.GetType().Name.ToLower()
                Case "dropdownlist"
                    CType(ctrl, DropDownList).SelectedValue = dr("AnswerID")
                Case "radiobuttonlist"
                    CType(ctrl, RadioButtonList).SelectedValue = dr("AnswerID")
            End Select
        End If
        dr.Close()

        UpdateProgress()
        '--- Raise ScreeningQuestionLoaded event.  Need to get required data for ScreeningQuestionLoadedEventArgs
        RaiseEvent ScreeningQuestionLoaded(Me, New ScreeningQuestionLoadedEventArgs(Me.CurrentQuestionID, Me.CurrentQuestionSequence, Me.ScreeningID, Me.AlreadyAnswered, Me.CallingQuestionID, Me.ProgressPercentage))

        cnn.Close()
    End Sub
#End Region

End Class

#Region "Notes and Commented Code"
'Private Sub btnPrevious_Click(sender As Object, e As System.EventArgs) Handles btnPrevious.Click
'    '--- Save selected answer
'    SaveSelectedAnswer()
'    '--- Get Next question
'    GetPreviousQuestion()
'End Sub

'Private Sub btnNext_Click(sender As Object, e As System.EventArgs) Handles btnNext.Click
'    '--- Save selected answer
'    SaveSelectedAnswer()
'    '--- Get Previous question
'    GetNextQuestion()
'End Sub
#End Region