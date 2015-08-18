<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Home.aspx.vb" Inherits="ACA_Screening.Home" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Survey Management</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource runat="server" ID="srcSurveyList" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, SurveyName, SurveyDescription FROM tblScreening_SurveyTypes WHERE ClientID = @ClientID">
            <SelectParameters>
                <asp:QueryStringParameter Name="ClientID" Type="Int32" QueryStringField="ClientID" />    
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Panel runat="server" ID="pnlSelectSurvey" Visible="true">
            <asp:Label runat="server" ID="lblSurvey" Text="Survey:"></asp:Label>
            <asp:DropDownList runat="server" id="ddlSurveys" DataSourceID="srcSurveyList" DataTextField="SurveyName" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:Button runat="server" ID="btnNewSurvey" Text="New" />
            <asp:Button runat="server" ID="btnManageQuestions" Text="Edit" />
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlNewSurvey" Visible="false">
            <asp:Label runat="server" ID="lblSurveyName" Text="Survey Name: "></asp:Label>
            <asp:TextBox runat="server" ID="txtSurveyName"></asp:TextBox><br />
            <asp:Label runat="server" ID="lblSurveyDescription" Text="Description: "></asp:Label>
            <asp:TextBox runat="server" ID="txtSurveyDescription" TextMode="MultiLine" Height="250px" Width="500px"></asp:TextBox><br />
            <asp:Button runat="server" ID="btnSaveNewSurvey" Text="Save" />
        </asp:Panel>
        <br />
        <br />
        <asp:SqlDataSource runat="server" ID="srcResultTypeList" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, QuestionSetDescription FROM tblScreening_QuestionSets WHERE SurveyTypeID = @SurveyTypeID">
            <SelectParameters>
                <asp:ControlParameter Name="SurveyTypeID" Type="Int32" ControlID="ddlSurveys" PropertyName="SelectedValue" />
            </SelectParameters>    
        </asp:SqlDataSource>
        <asp:Label runat="server" ID="lblResultTypes" Text="Associated Result Types/Sets:"></asp:Label><br />
        <asp:ListBox runat="server" ID="lstResultTypes" DataSourceID="srcResultTypeList" DataTextField="QuestionSetDescription" DataValueField="ID" SelectionMode="Single" ></asp:ListBox>
        <br />
        <asp:Button runat="server" ID="btnManageResultTypes" Text="Manage Result/Question Set Types" />


    </div>
    </form>
</body>
</html>
