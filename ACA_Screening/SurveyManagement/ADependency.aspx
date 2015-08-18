<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ADependency.aspx.vb" Inherits="ACA_Screening.ADependency" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h1>Answer Dependency</h1>
        <asp:HyperLink runat="server" ID="lnkBack" NavigateUrl="" Text="&lt;&lt; Back"></asp:HyperLink><br />
        <br />

        <!-- Selected Question / Answer Info -->
        <asp:SqlDataSource runat="server" ID="srcInfo"
            ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
            SelectCommand="SELECT ans.ID, ans.Answer_Text, ans.QuestionID, CASE WHEN ISNULL(DesignerNote, '') = '' THEN '' ELSE '[' + DesignerNote + '] ' END + QuestionText AS Question, quest.QuestionText, quest.QuestionSequence, surv.SurveyName FROM tblScreening_Answers ans INNER JOIN tblScreening_Questions quest ON (ans.QuestionID = quest.ID) INNER JOIN tblScreening_SurveyTypes surv ON (quest.SurveyTypeID = surv.ID) WHERE ans.ID = @AnswerID"
            SelectCommandType="Text"
            >
            <SelectParameters>
                <asp:QueryStringParameter Name="AnswerID" Type="Int32" QueryStringField="AnswerID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView runat="server" ID="fvInfo" DefaultMode="ReadOnly" DataSourceID="srcInfo">
            <ItemTemplate>
                <b>Survey: </b><asp:Label runat="server" ID="lblSurveyName" Text='<%# Eval("SurveyName") %>'></asp:Label><br />
                <b>Question: </b><asp:Label runat="server" ID="lblQuestionSeq" Text='<%# Eval("QuestionSequence") %>'></asp:Label>)  <asp:Label runat="server" ID="lblQuestionText" Text='<%# Eval("Question") %>'></asp:Label><br />
                <b>Answer: </b><asp:Label runat="server" ID="lblAnswerText" Text='<%# Eval("Answer_Text") %>'></asp:Label><br />
            </ItemTemplate>
        </asp:FormView>
        <br />

        <div>
        <h3>Define New Dependency</h3>
        <b>Select a combination of up to 5 answers for this Question/Answer to be dependent upon (i.e. The specified answers must be selected in order for this Answer to be displayed.):</b><br />
        <br />
        <asp:SqlDataSource ID="srcPrevQuestions" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:ACA_ScreeningConnectionString.ProviderName %>" 
            SelectCommand="prcScreening_LIST_PriorQuestions" 
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                <asp:QueryStringParameter Name="QuestionID" QueryStringField="QuestionID" Type="Int64" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:Repeater ID="rptPriorQuestions" runat="server" DataSourceID="srcPrevQuestions">
            <ItemTemplate>
                <b><%# Eval("QuestionSequence")%>) </b><%# Eval("Question")%><br />
                <asp:DropDownList runat="server" ID="ddlAnswers" DataTextField="Answer_Text" DataValueField="ID"></asp:DropDownList>
                <br />
                <br />
            </ItemTemplate>
        </asp:Repeater>
        <asp:Button runat="server" ID="btnAddDependency" Text="Add" />
        </div>

        <div>
            <h3>Existing Dependencies</h3>
            <asp:SqlDataSource ID="srcExistingDependencies" runat="server" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="prcScreening_List_DependenciesForAnswerID" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="AnswerID" QueryStringField="AnswerID" Type="Int64" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:Repeater runat="server" ID="rptExistingDependencies" DataSourceID="srcExistingDependencies">
                <ItemTemplate>
                    <h3 runat="server" id="h3OR">OR</h3>
                    <div style="border: 1px solid black; margin-top: 20px; padding: 15px;">
                        <asp:HiddenField runat="server" ID="hidDependencyID" Value='<%# Eval("DependencyID") %>' />

                        <div runat="server" id="divDep1">
                        <asp:HiddenField runat="server" ID="hidQID_1" Value='<%# Eval("QuestionID_1") %>' />
                        <asp:HiddenField runat="server" ID="hidAID_1" Value='<%# Eval("DependentOn_AnswerID_1") %>' />
                        <asp:Label runat="server" ID="Label1" Text='<%# Eval("Question_Sequence_1") %>'></asp:Label>) 
                        <asp:Label runat="server" ID="lblQ1" Text='<%# Eval("Question_1") %>'></asp:Label>
                        (Answer: <asp:Label runat="server" ID="lblA1" Text='<%# Eval("Answer_Text_1") %>'></asp:Label>)<br />
                        </div>

                        <div runat="server" id="divDep2">
                        <h3>AND</h3>
                        <asp:HiddenField runat="server" ID="hidQID_2" Value='<%# Eval("QuestionID_2") %>' />
                        <asp:HiddenField runat="server" ID="hidAID_2" Value='<%# Eval("DependentOn_AnswerID_2") %>' />
                        <asp:Label runat="server" ID="Label2" Text='<%# Eval("Question_Sequence_2") %>'></asp:Label>) 
                        <asp:Label runat="server" ID="lblQ2" Text='<%# Eval("Question_2") %>'></asp:Label>
                        (Answer: <asp:Label runat="server" ID="lblA2" Text='<%# Eval("Answer_Text_2") %>'></asp:Label>)<br />
                        </div>

                        <div runat="server" id="divDep3">
                        <h3>AND</h3>
                        <asp:HiddenField runat="server" ID="hidQID_3" Value='<%# Eval("QuestionID_3") %>' />
                        <asp:HiddenField runat="server" ID="hidAID_3" Value='<%# Eval("DependentOn_AnswerID_3") %>' />
                        <asp:Label runat="server" ID="Label3" Text='<%# Eval("Question_Sequence_3") %>'></asp:Label>) 
                        <asp:Label runat="server" ID="lblQ3" Text='<%# Eval("Question_3") %>'></asp:Label>
                        (Answer: <asp:Label runat="server" ID="lblA3" Text='<%# Eval("Answer_Text_3") %>'></asp:Label>)<br />
                        </div>

                        <div runat="server" id="divDep4">
                        <h3>AND</h3>
                        <asp:HiddenField runat="server" ID="hidQID_4" Value='<%# Eval("QuestionID_4") %>' />
                        <asp:HiddenField runat="server" ID="hidAID_4" Value='<%# Eval("DependentOn_AnswerID_4") %>' />
                        <asp:Label runat="server" ID="Label4" Text='<%# Eval("Question_Sequence_4") %>'></asp:Label>) 
                        <asp:Label runat="server" ID="lblQ4" Text='<%# Eval("Question_4") %>'></asp:Label>
                        (Answer: <asp:Label runat="server" ID="lblA4" Text='<%# Eval("Answer_Text_4") %>'></asp:Label>)<br />
                        </div>

                        <div runat="server" id="divDep5">
                        <h3>AND</h3>
                        <asp:HiddenField runat="server" ID="hidQID_5" Value='<%# Eval("QuestionID_5") %>' />
                        <asp:HiddenField runat="server" ID="hidAID_5" Value='<%# Eval("DependentOn_AnswerID_5") %>' />
                        <asp:Label runat="server" ID="Label5" Text='<%# Eval("Question_Sequence_5") %>'></asp:Label>) 
                        <asp:Label runat="server" ID="lblQ5" Text='<%# Eval("Question_5") %>'></asp:Label>
                        (Answer: <asp:Label runat="server" ID="lblA5" Text='<%# Eval("Answer_Text_5") %>'></asp:Label>)<br />
                        </div>

                        <asp:Button runat="server" ID="btnRemoveDependency" CommandName="Delete" CommandArgument='<%# Eval("DependencyID") %>' Text="Remove This Dependency" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
        
        
    </div>
    </form>
</body>
</html>
