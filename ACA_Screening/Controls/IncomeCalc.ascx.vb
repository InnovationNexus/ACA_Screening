Imports System.Web.UI.Page

Public Class IncomeCalc
    Inherits System.Web.UI.UserControl

#Region "Variable Declarations"
    Private d_txtIncomeAmount() As TextBox
    Private d_txtRate() As TextBox
    Private d_txtHours() As TextBox
    Private d_ddlPerson() As DropDownList
    Private d_ddlIncType() As DropDownList
    Private d_ddlFreq() As DropDownList
#End Region

#Region "Public Properties"
    Public Property numItems As Int16
        Get
            Dim o As Object = ViewState("numItems")
            If IsNothing(o) Then
                ViewState("numItems") = 4
                Return 4
            Else
                Return CInt(o)
            End If
        End Get
        Set(value As Int16)
            ViewState("numItems") = value
        End Set
    End Property
    Public Property incomeTotals As Decimal
        Get
            Dim o As Object = ViewState("incomeTotals")
            If IsNothing(o) Then
                Return 0.0
            Else
                Return CInt(o)
            End If
        End Get
        Set(value As Decimal)
            ViewState("incomeTotals") = value
        End Set
    End Property
#End Region

#Region "Event Handlers"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not IsPostBack Then
        '    lblNumItems.Text = 4
        'End If
    End Sub

    Protected Sub btnAddIncome_Click(sender As Object, e As EventArgs) Handles btnAddIncome.Click
        'Should be handled by pre_init
        Me.numItems += 1
    End Sub



#End Region

#Region "Public Methods"
    Public Shared Function GetPostBackControl(ByVal thePage As Page) As Control
        Dim myControl As Control = Nothing
        Dim ctrlName As String = thePage.Request.Params.Get("__EVENTTARGET")

        If ((ctrlName IsNot Nothing) And (ctrlName <> String.Empty)) Then
            myControl = thePage.FindControl(ctrlName)
        Else
            For Each Item As String In thePage.Request.Form
                Dim c As Control = thePage.FindControl(Item)
                If (TypeOf (c) Is System.Web.UI.WebControls.Button) Then
                    myControl = c
                End If
            Next
        End If
        Return myControl

    End Function
#End Region

    Protected Overrides Sub CreateChildControls()
        MyBase.CreateChildControls()

        'Dim myControl As Control = GetPostBackControl(Me.Page)
        'If (myControl IsNot Nothing) Then
        '    If (myControl.ClientID.ToString() = "MainContent_acaIncomeCalc_btnAddIncome") Then
        '        Me.numItems += 1
        '    End If
        'End If

        Dim literalBreak As LiteralControl = New LiteralControl("<br />")
        Dim hiddenLabel As Label = New Label()

        '***
        hiddenLabel.ID = "lblNumItems"
        hiddenLabel.Text = CStr(Me.numItems)
        hiddenLabel.CssClass = "lblNumItems"
        phHidLabel.Controls.Add(hiddenLabel)

        '*** 
        d_ddlPerson = New DropDownList(numItems - 1) {}
        d_ddlIncType = New DropDownList(numItems - 1) {}
        d_txtIncomeAmount = New TextBox(numItems - 1) {}
        d_ddlFreq = New DropDownList(numItems - 1) {}
        d_txtRate = New TextBox(numItems - 1) {}
        d_txtHours = New TextBox(numItems - 1) {}

        Dim i As Integer
        For i = 0 To Me.numItems - 1 Step i + 1
            Dim ddlPerson As DropDownList = New DropDownList()
            Dim ddlIncType As DropDownList = New DropDownList()
            Dim txtIncomeAmount As TextBox = New TextBox()
            Dim ddlFreq As DropDownList = New DropDownList()
            Dim txtRate As TextBox = New TextBox()
            Dim txtHours As TextBox = New TextBox()

            '*** DDL Person
            ddlPerson.ID = "ddlPerson" + i.ToString()
            ddlPerson.Items.Add("Me")
            ddlPerson.Items.Add("Spouse")
            ddlPerson.Items.Add("Child 1")
            ddlPerson.Items.Add("Child 2")
            ddlPerson.Items.Add("Child 3")
            ddlPerson.Items.Add("Child 4")
            ddlPerson.Items.Add("Child 5")
            ddlPerson.Style("padding") = "1.25px 0px 1.25px 0px"
            ddlPerson.Style("margin") = "2px 5px 2px 5px"
            ddlPerson.DataBind()

            '*** DDL Income Type
            ddlIncType.ID = "ddlIncType" + i.ToString()
            ddlIncType.CssClass = "incomeTypeChange input"
            ddlIncType.Items.Add("Earned Income")
            ddlIncType.Items.Add("Alimony")
            ddlIncType.Items.Add("Rental Income")
            ddlIncType.Style("padding") = "1.25px 0px 1.25px 0px"
            ddlIncType.Style("margin") = "2px 5px 2px 5px"
            ddlIncType.DataBind()

            '*** TextBox Income Amount
            txtIncomeAmount.ID = "txtIncomeAmount" + i.ToString()
            txtIncomeAmount.Width = 70
            txtIncomeAmount.Enabled = False
            txtIncomeAmount.Style("margin") = "2px 5px 2px 5px"

            '*** DDL Frequency
            ddlFreq.ID = "ddlFrequency" + i.ToString()
            ddlFreq.CssClass = "incomeFreqChange input"
            ddlFreq.Items.Add(New ListItem("[SELECT]", "0"))
            ddlFreq.Items.Add(New ListItem("Hourly", "2000"))
            ddlFreq.Items.Add(New ListItem("Weekly", "52"))
            ddlFreq.Items.Add(New ListItem("Bi-Weekly", "26"))
            ddlFreq.Items.Add(New ListItem("Monthly", "12"))
            ddlFreq.Items.Add(New ListItem("Yearly", "1"))
            ddlFreq.Style("padding") = "1.25px 0px 1.25px 0px"
            ddlFreq.Style("margin") = "2px 5px 2px 5px"

            '*** TextBox Rate
            txtRate.ID = "txtRate" + i.ToString()
            txtRate.CssClass = "input"
            txtRate.Style("margin") = "2px 5px 2px 5px"

            '*** TextBox Hours
            txtHours.ID = "txtHours" + i.ToString()
            txtHours.CssClass = "input"
            txtHours.Enabled = False
            txtHours.Style("margin") = "2px 5px 2px 5px"
            phPerson.Controls.Add(ddlPerson)
            phIncomeType.Controls.Add(ddlIncType)
            phIncomeAmount.Controls.Add(txtIncomeAmount)
            phFrequency.Controls.Add(ddlFreq)
            phRate.Controls.Add(txtRate)
            phHours.Controls.Add(txtHours)

            d_ddlPerson(i) = ddlPerson
            d_ddlIncType(i) = ddlIncType
            d_txtIncomeAmount(i) = txtIncomeAmount
            d_ddlFreq(i) = ddlFreq
            d_txtRate(i) = txtRate
            d_txtHours(i) = txtHours

            phPerson.Controls.Add(literalBreak)
            phIncomeType.Controls.Add(literalBreak)
            phIncomeAmount.Controls.Add(literalBreak)
            phFrequency.Controls.Add(literalBreak)
            phRate.Controls.Add(literalBreak)
            phHours.Controls.Add(literalBreak)
        Next
    End Sub





End Class

#Region "Notes"


'Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
'    Dim myControl As Control = GetPostBackControl(Me.Page)

'    If (myControl IsNot Nothing) Then
'        If (myControl.ClientID.ToString() = "MainContent_acaIncomeCalc_btnAddIncome") Then
'            'numItems = Session("numItems")
'            Me.numItems += 1
'            ViewState("numItems") = numItems
'            'Session("numItems") = numItems
'        End If
'    End If
'End Sub




'Protected Overrides Sub OnInit(e As System.EventArgs)
'    MyBase.OnInit(e)

'    If Not (IsPostBack) Then
'        Session("numItems") = 4
'        'Session("numItems") = numItems
'    Else
'        'numItems = Session("numItems")
'        'numItems = CInt(hidNumItems.Value)
'    End If

'    Dim literalBreak As LiteralControl = New LiteralControl("<br />")

'    '*** 
'    d_ddlPerson = New DropDownList(numItems - 1) {}
'    d_ddlIncType = New DropDownList(numItems - 1) {}
'    d_txtIncomeAmount = New TextBox(numItems - 1) {}
'    d_ddlFreq = New DropDownList(numItems - 1) {}
'    d_txtRate = New TextBox(numItems - 1) {}
'    d_txtHours = New TextBox(numItems - 1) {}

'    Dim i As Integer
'    For i = 0 To numItems - 1 Step i + 1
'        Dim ddlPerson As DropDownList = New DropDownList()
'        Dim ddlIncType As DropDownList = New DropDownList()
'        Dim txtIncomeAmount As TextBox = New TextBox()
'        Dim ddlFreq As DropDownList = New DropDownList()
'        Dim txtRate As TextBox = New TextBox()
'        Dim txtHours As TextBox = New TextBox()

'        '*** DDL Person
'        ddlPerson.ID = "ddlPerson" + i.ToString()
'        ddlPerson.Items.Add("Me")
'        ddlPerson.Items.Add("Spouse")
'        ddlPerson.Items.Add("Child 1")
'        ddlPerson.Items.Add("Child 2")
'        ddlPerson.Items.Add("Child 3")
'        ddlPerson.Items.Add("Child 4")
'        ddlPerson.Items.Add("Child 5")
'        ddlPerson.Style("padding") = "1.25px 0px 1.25px 0px"
'        ddlPerson.Style("margin") = "2px 5px 2px 5px"
'        ddlPerson.DataBind()

'        '*** DDL Income Type
'        ddlIncType.ID = "ddlIncType" + i.ToString()
'        ddlIncType.Items.Add("Earned Income")
'        ddlIncType.Items.Add("Alimony")
'        ddlIncType.Items.Add("Rental Income")
'        ddlIncType.Style("padding") = "1.25px 0px 1.25px 0px"
'        ddlIncType.Style("margin") = "2px 5px 2px 5px"
'        ddlIncType.DataBind()

'        '*** TextBox Income Amount
'        txtIncomeAmount.ID = "txtIncomeAmount" + i.ToString()
'        txtIncomeAmount.Width = 70
'        txtIncomeAmount.Style("margin") = "2px 5px 2px 5px"

'        '*** DDL Frequency
'        ddlFreq.ID = "ddlFrequency" + i.ToString()
'        ddlFreq.Items.Add("Hourly")
'        ddlFreq.Items.Add("Weekly")
'        ddlFreq.Items.Add("Bi-Weekly")
'        ddlFreq.Items.Add("Monthly")
'        ddlFreq.Items.Add("Yearly")
'        ddlFreq.Style("padding") = "1.25px 0px 1.25px 0px"
'        ddlFreq.Style("margin") = "2px 5px 2px 5px"

'        '*** TextBox Rate
'        txtRate.ID = "txtRate" + i.ToString()
'        txtRate.Style("margin") = "2px 5px 2px 5px"

'        '*** TextBox Hours
'        txtHours.ID = "txtHours" + i.ToString()
'        txtHours.Style("margin") = "2px 5px 2px 5px"

'        phPerson.Controls.Add(ddlPerson)
'        phIncomeType.Controls.Add(ddlIncType)
'        phIncomeAmount.Controls.Add(txtIncomeAmount)
'        phFrequency.Controls.Add(ddlFreq)
'        phRate.Controls.Add(txtRate)
'        phHours.Controls.Add(txtHours)

'        d_ddlPerson(i) = ddlPerson
'        d_ddlIncType(i) = ddlIncType
'        d_txtIncomeAmount(i) = txtIncomeAmount
'        d_ddlFreq(i) = ddlFreq
'        d_txtRate(i) = txtRate
'        d_txtHours(i) = txtHours

'        phPerson.Controls.Add(literalBreak)
'        phIncomeType.Controls.Add(literalBreak)
'        phIncomeAmount.Controls.Add(literalBreak)
'        phFrequency.Controls.Add(literalBreak)
'        phRate.Controls.Add(literalBreak)
'        phHours.Controls.Add(literalBreak)
'    Next
'End Sub

'Private Sub addControl()

'    numItems += 1


'hidNumItems.Value = numItems.ToString()

'Dim ddlPerson As New DropDownList
'Dim ddlIncType As New DropDownList
'Dim txtIncomeAmount As New TextBox
'Dim ddlFreq As New DropDownList
'Dim txtRate As New TextBox
'Dim txtHours As New TextBox

'Person DDL
'ddlPerson.ID = "ddlPerson" + numItems.ToString()
'ddlPerson.ViewStateMode = UI.ViewStateMode.Enabled
'ddlPerson.Items.Add("Me")
'ddlPerson.Items.Add("Spouse")
'ddlPerson.Items.Add("Child 1")
'ddlPerson.Items.Add("Child 2")
'ddlPerson.Items.Add("Child 3")
'ddlPerson.Items.Add("Child 4")
'ddlPerson.Items.Add("Child 5")
'ddlPerson.DataBind()
'ddlPerson.DataTextField = ""
'ddlPerson.DataValueField = ""

'Income Type DDL
'ddlIncType.ID = "ddlIncType" + numItems.ToString()
'ddlIncType.Items.Add("Earned Income")
'ddlIncType.Items.Add("Alimony")
'ddlIncType.Items.Add("Rental Income")
'ddlIncType.DataBind()

'ddlIncType.DataTextField = ""
'ddlIncType.DataValueField = ""

''Income Amount TXT
'txtIncomeAmount.ID = "txtIncomeAmount" + numItems.ToString()
'txtIncomeAmount.ViewStateMode = UI.ViewStateMode.Enabled

''Freq DDL
'ddlFreq.ID = "ddlFrequency" + numItems.ToString()
'ddlFreq.Items.Add("Hourly")
'ddlFreq.Items.Add("Weekly")
'ddlFreq.Items.Add("Bi-Weekly")
'ddlFreq.Items.Add("Monthly")
'ddlFreq.Items.Add("Yearly")

''Rate TXT
'txtRate.ID = "txtRate" + numItems.ToString()
'txtRate.ViewStateMode = UI.ViewStateMode.Enabled

''Hours TXT
'txtHours.ID = "txtHours" + numItems.ToString()
'txtHours.ViewStateMode = UI.ViewStateMode.Enabled


'pnlPerson.Controls.Add(ddlPerson)
'pnlIncomeType.Controls.Add(ddlIncType)
'pnlIncomeAmount.Controls.Add(txtIncomeAmount)
'pnlFrequency.Controls.Add(ddlFreq)
'pnlRate.Controls.Add(txtRate)
'pnlHours.Controls.Add(txtHours)


'End Sub
#End Region
'ddlFreq.SelectedIndex() = "0"
'ddlFreq.SelectedValue() = "[Select]"
'ddlFreq.Items.Add("[Select]")
'ddlFreq.Items.Add("Hourly")
'ddlFreq.Items.Add("Weekly")
'ddlFreq.Items.Add("Bi-Weekly")
'ddlFreq.Items.Add("Monthly")
'ddlFreq.Items.Add("Yearly")