<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SurveyQuestions.aspx.vb" Inherits="ACA_Screening.SurveyQuestions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function EscapeQuestion() {
            var txt = document.getElementById('<%= Me.TextClientID  %>');
            if ((typeof txt !== 'undefined') && !(txt === null)) {
                txt.value = escape(txt.value);
            }
        }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:HyperLink runat="server" ID="lnkHome" NavigateUrl="" Text="&lt;&lt; Home"></asp:HyperLink><br />
        <br />

        <asp:SqlDataSource runat="server" ID="srcQuestions" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, CASE WHEN ISNULL(DesignerNote, '') = '' THEN '' ELSE '[' + DesignerNote + '] ' END + QuestionText AS Question, DesignerNote, QuestionText, QuestionSequence, QuestionType, DataType FROM tblScreening_Questions WHERE SurveyTypeID = @SurveyTypeID ORDER BY QuestionSequence">
            <SelectParameters>
                <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <h3>Question:</h3>
        <table>
            <tr>
                <td><asp:ListBox runat="server" ID="lstQuestions" DataSourceID="srcQuestions" DataTextField="Question" DataValueField="ID" AutoPostBack="true" Height="200px"></asp:ListBox><br /><asp:Button runat="server" ID="btnNewQuestion" Text="New Question" /></td>
                <td><asp:Button runat="server" ID="btnMoveQuestionUp" Text="Move Up" /><br /><asp:Button runat="server" ID="btnMoveQuestionDown" Text="Move Down" /><br /><asp:Button runat="server" ID="btnQuestionDependencies" Text="View/Edit Dependencies" /></td>
                <td></td>
            </tr>
        </table>

        <asp:SqlDataSource runat="server" ID="srcQuestionDetails" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, DesignerNote, QuestionText, QuestionSequence, QuestionExplanation, QuestionType, DataType FROM tblScreening_Questions WHERE ID = @QuestionID"
            UpdateCommand="UPDATE tblScreening_Questions SET DesignerNote = @DesignerNote, QuestionText = @QuestionText, QuestionExplanation = @QuestionExplanation, QuestionType = @QuestionType, DataType = @DataType WHERE ID = @QuestionID"
            InsertCommand="INSERT tblScreening_Questions (SurveyTypeID, DesignerNote, QuestionText, QuestionExplanation, QuestionSequence, QuestionType, DataType) VALUES (@SurveyTypeID, @DesignerNote, @QuestionText, @QuestionExplanation, @QuestionSequence, @QuestionType, @DataType)"
            >
            <SelectParameters>
                <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="lstQuestions" PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="lstQuestions" PropertyName="SelectedValue" />
                <asp:Parameter Name="DesignerNote" Type="String" />
                <asp:Parameter Name="QuestionText" Type="String" />
                <asp:Parameter Name="QuestionExplanation" Type="String" />
                <asp:Parameter Name="QuestionType" Type="String" />
                <asp:Parameter Name="DataType" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
                <asp:Parameter Name="DesignerNote" Type="String" />
                <asp:Parameter Name="QuestionText" Type="String" />
                <asp:Parameter Name="QuestionExplanation" Type="String" />
                <asp:Parameter Name="QuestionSequence" Type="Int16" />
                <asp:Parameter Name="QuestionType" Type="String" />
                <asp:Parameter Name="DataType" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:FormView runat="server" ID="fvQuestionDetails" DataSourceID="srcQuestionDetails" DataKeyNames="ID" DefaultMode="Edit" ViewStateMode="Enabled">
            <EditItemTemplate>
                Designer Note : <asp:TextBox runat="server" ID="txtDesignerNote" Text='<%# Bind("DesignerNote") %>' TextMode="SingleLine" Width="500px" ToolTip="This text will be displayed in brackets along with the question text in the Survey Designer.  It will NOT be displayed in the actual survey."></asp:TextBox><br />
                Question Text : <asp:TextBox runat="server" ID="txtQuestionText" Text='<%# Bind("QuestionText") %>' TextMode="MultiLine" Width="500px" Height="100px"></asp:TextBox><br />
                Explanation : <asp:TextBox runat="server" ID="txtQuestionExplanation" Text='<%# Bind("QuestionExplanation") %>' TextMode="MultiLine" Width="500px" Height="75px"></asp:TextBox><br />
                Selection Type : 
                <asp:DropDownList runat="server" ID="ddlQuestionsType" SelectedValue='<%# Bind("QuestionType") %>' AutoPostBack="false">
                    <asp:ListItem Text="RadioButtonList" Value="RadioButtonList"></asp:ListItem>
                    <asp:ListItem Text="DropDownList" Value="DropDownList"></asp:ListItem>
                    <asp:ListItem Text="CheckBox" Value="CheckBox"></asp:ListItem>
                    <asp:ListItem Text="MultiSelectList" Value="MultiSelectList"></asp:ListItem>
                    <asp:ListItem Text="TextBox" Value="TextBox"></asp:ListItem>
                </asp:DropDownList>
                <br />
                Data Type : 
                <asp:DropDownList runat="server" ID="ddlDataType" SelectedValue='<%# Bind("DataType") %>' AutoPostBack="false">
                    <asp:ListItem Text="AnswerID" Value="AnswerID"></asp:ListItem>
                    <asp:ListItem Text="Boolean" Value="Boolean"></asp:ListItem>
                    <asp:ListItem Text="Integer" Value="Integer"></asp:ListItem>
                    <asp:ListItem Text="Money" Value="Money"></asp:ListItem>
                    <asp:ListItem Text="Text" Value="Text"></asp:ListItem>
                </asp:DropDownList>
                <br />
                <asp:Button runat="server" ID="btnSaveQuestion" CommandName="Update" Text="Save" />&nbsp;&nbsp;
            </EditItemTemplate>
            <InsertItemTemplate>
                <asp:HiddenField runat="server" ID="hidQuestionSequence" Value='<%# Bind("QuestionSequence") %>' />
                Designer Note : <asp:TextBox runat="server" ID="txtDesignerNote" Text='<%# Bind("DesignerNote") %>' TextMode="SingleLine" Width="500px" ToolTip="This text will be displayed in brackets along with the question text in the Survey Designer.  It will NOT be displayed in the actual survey."></asp:TextBox><br />
                Question Text : <asp:TextBox runat="server" ID="txtQuestionText" Text='<%# Bind("QuestionText") %>' TextMode="MultiLine" Width="500px" Height="100px"></asp:TextBox><br />
                Explanation : <asp:TextBox runat="server" ID="txtQuestionExplanation" Text='<%# Bind("QuestionExplanation") %>' TextMode="MultiLine" Width="500px" Height="75px"></asp:TextBox><br />
                Selection Type : 
                <asp:DropDownList runat="server" ID="lstQuestionsType" SelectedValue='<%# Bind("QuestionType") %>' AutoPostBack="false">
                    <asp:ListItem Text="RadioButtonList" Value="RadioButtonList"></asp:ListItem>
                    <asp:ListItem Text="DropDownList" Value="DropDownList"></asp:ListItem>
                    <asp:ListItem Text="CheckBox" Value="CheckBox"></asp:ListItem>
                    <asp:ListItem Text="MultiSelectList" Value="MultiSelectList"></asp:ListItem>
                    <asp:ListItem Text="TextBox" Value="TextBox"></asp:ListItem>
                </asp:DropDownList>
                <br />
                Data Type : 
                <asp:DropDownList runat="server" ID="ddlDataType" SelectedValue='<%# Bind("DataType") %>' AutoPostBack="false">
                    <asp:ListItem Text="AnswerID" Value="AnswerID"></asp:ListItem>
                    <asp:ListItem Text="Boolean" Value="Boolean"></asp:ListItem>
                    <asp:ListItem Text="Integer" Value="Integer"></asp:ListItem>
                    <asp:ListItem Text="Money" Value="Money"></asp:ListItem>
                    <asp:ListItem Text="Text" Value="Text"></asp:ListItem>
                </asp:DropDownList>
                <br />
                <asp:Button runat="server" ID="btnSaveQuestion" CommandName="Insert" Text="Save" />&nbsp;&nbsp;<asp:Button runat="server" ID="btnCancelQuestion" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
        </asp:FormView>

    <asp:Panel runat="server" ID="pnlAnswers">
        <asp:SqlDataSource runat="server" ID="srcAnswers" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, Answer_Text, Answer_SequenceNumber FROM tblScreening_Answers WHERE QuestionID = @QuestionID ORDER BY Answer_SequenceNumber">
            <SelectParameters>
                <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="lstQuestions" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <table>
            <tr>
                <td><asp:ListBox runat="server" ID="lstAnswers" DataSourceID="srcAnswers" DataTextField="Answer_Text" DataValueField="ID" AutoPostBack="true" Width="300px" Height="175px" ></asp:ListBox><br /><asp:Button runat="server" ID="btnNewAnswer" Text="New Answer Option" /></td>
                <td><asp:Button runat="server" ID="btnMoveAnswerUp" Text="Move Up" /><br /><asp:Button runat="server" ID="btnMoveAnswerDown" Text="Move Down" /><br /><asp:Button runat="server" ID="btnAnswerDependencies" Text="View/Edit Dependencies" /></td>
                <td></td>
            </tr>
        </table>
        <br />
        
        <asp:SqlDataSource runat="server" ID="srcAnswerDetails" ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
            SelectCommand="SELECT ID, QuestionID, Answer_Text, Answer_SequenceNumber FROM tblScreening_Answers WHERE ID = @AnswerID"
            UpdateCommand="UPDATE tblScreening_Answers SET Answer_Text = @Answer_Text WHERE ID = @AnswerID"
            InsertCommand="INSERT INTO tblScreening_Answers (QuestionID, Answer_Text, Answer_SequenceNumber) VALUES (@QuestionID, @Answer_Text, @Answer_SequenceNumber)"
            >
            <SelectParameters>
                <asp:ControlParameter Name="AnswerID" Type="Int32" ControlID="lstAnswers" PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:ControlParameter Name="AnswerID" Type="Int32" ControlID="lstAnswers" PropertyName="SelectedValue" />
            </UpdateParameters>
            <InsertParameters>
                <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="lstQuestions" PropertyName="SelectedValue" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:FormView runat="server" ID="fvAnswerDetails" DataSourceID="srcAnswerDetails" DataKeyNames="ID" DefaultMode="Edit">
            <EditItemTemplate>
                <asp:TextBox runat="server" ID="txtAnswerText" Text='<%# Bind("Answer_Text") %>'></asp:TextBox><br />
                <asp:Button runat="server" ID="btnSaveAnswer" CommandName="Update" Text="Save" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <asp:HiddenField runat="server" ID="hidAnswer_SequenceNumber" Value='<%# Bind("Answer_SequenceNumber") %>' />
                <asp:TextBox runat="server" ID="txtAnswerText" Text='<%# Bind("Answer_Text") %>'></asp:TextBox><br />
                <asp:Button runat="server" ID="btnSaveAnswer" CommandName="Insert" Text="Save" />&nbsp;&nbsp;<asp:Button runat="server" ID="btnCancelAnswer" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
        </asp:FormView>
    </asp:Panel>

    </div>
    </form>
</body>
</html>
