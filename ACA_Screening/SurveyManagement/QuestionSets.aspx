<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="QuestionSets.aspx.vb" Inherits="ACA_Screening.QuestionSets" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>

    <asp:HyperLink runat="server" ID="lnkHome" NavigateUrl="" Text="&lt;&lt; Home"></asp:HyperLink><br />
    <br />

    <asp:Panel runat="server" ID="pnlSelectQuestionSet">
        <asp:SqlDataSource runat="server" ID="srcQuestionSets"
            SelectCommandType="Text" SelectCommand="SELECT ID AS QuestionSetID, QuestionSetTypeID, QuestionSetDescription FROM tblScreening_QuestionSets WHERE SurveyTypeID = @SurveyTypeID ORDER BY QuestionSetID"
            ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'>
            <SelectParameters>
                <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Label runat="server" ID="lblQuestionSet" Text="Question Set:" CssClass="Label StdWidthLabel"></asp:Label>
        <asp:DropDownList runat="server" ID="ddlQuestionSets" DataSourceID="srcQuestionSets" DataTextField="QuestionSetDescription" DataValueField="QuestionSetID" AutoPostBack="true"></asp:DropDownList>
    </asp:Panel>

    <asp:SqlDataSource runat="server" ID="srcQuestionSetDetail"
        SelectCommandType="StoredProcedure" SelectCommand="prcScreening_QuestionSetDetails"
        ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'
        InsertCommand="INSERT INTO tblScreening_QuestionSets (QuestionSetTypeID, QuestionSetDescription, SurveyTypeID, KeyAnswerID_1, KeyAnswerID_2, KeyAnswerID_3, KeyAnswerID_4, KeyAnswerID_5, Threshold_RedZone, Threshold_OrangeZone, Threshold_YellowZone, Threshold_GreenZone) VALUES (@QuestionSetTypeID, @QuestionSetDescription, @SurveyTypeID, @KeyAnswerID_1, @KeyAnswerID_2, @KeyAnswerID_3, @KeyAnswerID_4, @KeyAnswerID_5, @Threshold_RedZone, @Threshold_OrangeZone, @Threshold_YellowZone, @Threshold_GreenZone)"
        >
        <SelectParameters>
            <asp:ControlParameter Name="QuestionSetID" Type="Int32" ControlID="ddlQuestionSets" PropertyName="SelectedValue" />
        </SelectParameters>
        <InsertParameters>
            <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:FormView runat="server" ID="fvQuestionSetDetail" DataSourceID="srcQuestionSetDetail" DataKeyNames="QuestionSetID">
        <ItemTemplate>
            <asp:Button runat="server" ID="btnNewQuestionSet" CommandName="New" Text="New" /><br />
            <br />

            <asp:Label runat="server" ID="Label1" Text="Question Set ID:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label2" Text='<%# Eval("QuestionSetID") %>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label3" Text="Description:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label4" Text='<%# Eval("QuestionSetDescription") %>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label11" Text="Green Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label12" Text='<%# String.Format("{0:0.0 %}", Eval("Threshold_GreenZone")) %>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label9" Text="Yellow Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label10" Text='<%# String.Format("{0:0.0 %}", Eval("Threshold_YellowZone")) %>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label7" Text="Orange Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label8" Text='<%# String.Format("{0:0.0 %}", Eval("Threshold_OrangeZone")) %>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label5" Text="Red Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label6" Text='<%# String.Format("{0:0.0 %}", Eval("Threshold_RedZone")) %>' CssClass="Data Label"></asp:Label>
            <br />
            <h3>Key Question/Answers:</h3>
            <asp:Label runat="server" ID="Label13" Text="Answer Key 1:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label14" Text='<%# " " +  Eval("AnsKey1_QuestionSequence").ToString() + ") " + Eval("AnsKey1_Question") + " : " + Eval("AnsKey1_Text") + " (" + Eval("AnsKey1_ID").ToString() + ")"%>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label15" Text="Answer Key 2:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label16" Text='<%# " " +  Eval("AnsKey2_QuestionSequence").ToString() + ") " + Eval("AnsKey2_Question") + " : " + Eval("AnsKey2_Text") + " (" + Eval("AnsKey2_ID").ToString() + ")"%>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label17" Text="Answer Key 3:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label21" Text='<%# " " +  Eval("AnsKey3_QuestionSequence").ToString() + ") " + Eval("AnsKey3_Question") + " : " + Eval("AnsKey3_Text") + " (" + Eval("AnsKey3_ID").ToString() + ")"%>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label18" Text="Answer Key 4:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label22" Text='<%# " " +  Eval("AnsKey4_QuestionSequence").ToString() + ") " + Eval("AnsKey4_Question") + " : " + Eval("AnsKey4_Text") + " (" + Eval("AnsKey4_ID").ToString() + ")"%>' CssClass="Data Label"></asp:Label>
            <br />
            <asp:Label runat="server" ID="Label23" Text="Answer Key 5:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:Label runat="server" ID="Label24" Text='<%# " " +  Eval("AnsKey5_QuestionSequence").ToString() + ") " + Eval("AnsKey5_Question") + " : " + Eval("AnsKey5_Text") + " (" + Eval("AnsKey5_ID").ToString() + ")"%>' CssClass="Data Label"></asp:Label>
            <br />
        </ItemTemplate>
        <InsertItemTemplate>
            <asp:SqlDataSource runat="server" ID="srcQuestionSetTypes" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, TypeDescription FROM tblScreening_QuestionSetTypes WHERE SurveyTypeID = @SurveyTypeID"
                >
                <SelectParameters>
                    <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:Label runat="server" ID="Label1" Text="Question Set Type:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlQuestionSetType" DataSourceID="srcQuestionSetTypes" DataTextField="TypeDescription" DataValueField="ID" SelectedValue='<%# Bind("QuestionSetTypeID") %>'></asp:DropDownList>
            <br />
            <asp:Label runat="server" ID="Label3" Text="Description:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:TextBox runat="server" ID="txtQuestionSetDescription" Text='<%# Bind("QuestionSetDescription") %>' CssClass="Data"></asp:TextBox>
            <br />
            <asp:Label runat="server" ID="Label11" Text="Green Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:TextBox runat="server" ID="txtThreshold_GreenZone" Text='<%# Bind("Threshold_GreenZone") %>' CssClass="Data"></asp:TextBox>
            <br />
            <asp:Label runat="server" ID="Label9" Text="Yellow Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:TextBox runat="server" ID="txtThreshold_YellowZone" Text='<%# Bind("Threshold_YellowZone") %>' CssClass="Data Label"></asp:TextBox>
            <br />
            <asp:Label runat="server" ID="Label7" Text="Orange Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:TextBox runat="server" ID="txtThreshold_OrangeZone" Text='<%# Bind("Threshold_OrangeZone") %>' CssClass="Data Label"></asp:TextBox>
            <br />
            <asp:Label runat="server" ID="Label5" Text="Red Zone Upper Limit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:TextBox runat="server" ID="txtThreshold_RedZone" Text='<%# Bind("Threshold_RedZone") %>' CssClass="Data Label"></asp:TextBox>
            <br />
            <h3>Key Question/Answers:</h3>
            <asp:SqlDataSource runat="server" ID="srcQuestions" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, qus.QuestionText FROM tblScreening_Questions qus WHERE qus.SurveyTypeID = @SurveyTypeID ORDER BY qus.QuestionSequence"
                >
                <SelectParameters>
                    <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:Label runat="server" ID="Label13" Text="Answer Key 1:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlAnswerKeyQuestion1" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlAnswerKey1" DataTextField="Answer_Text" DataValueField="ID" DataSourceID="srcAnswers1"></asp:DropDownList>
            <asp:SqlDataSource runat="server" ID="srcAnswers1" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, ans.Answer_Text FROM tblScreening_Answers ans WHERE ans.QuestionID = @QuestionID ORDER BY ans.Answer_SequenceNumber"
                >
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlAnswerKeyQuestion1" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />

            <asp:Label runat="server" ID="Label25" Text="Answer Key 2:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlAnswerKeyQuestion2" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlAnswerKey2" DataTextField="Answer_Text" DataValueField="ID" DataSourceID="srcAnswers2"></asp:DropDownList>
            <asp:SqlDataSource runat="server" ID="srcAnswers2" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, ans.Answer_Text FROM tblScreening_Answers ans WHERE ans.QuestionID = @QuestionID ORDER BY ans.Answer_SequenceNumber"
                >
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlAnswerKeyQuestion2" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />

            <asp:Label runat="server" ID="Label26" Text="Answer Key 3:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlAnswerKeyQuestion3" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlAnswerKey3" DataTextField="Answer_Text" DataValueField="ID" DataSourceID="srcAnswers3"></asp:DropDownList>
            <asp:SqlDataSource runat="server" ID="srcAnswers3" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, ans.Answer_Text FROM tblScreening_Answers ans WHERE ans.QuestionID = @QuestionID ORDER BY ans.Answer_SequenceNumber"
                >
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlAnswerKeyQuestion3" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />

            <asp:Label runat="server" ID="Label27" Text="Answer Key 4:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlAnswerKeyQuestion4" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlAnswerKey4" DataTextField="Answer_Text" DataValueField="ID" DataSourceID="srcAnswers4"></asp:DropDownList>
            <asp:SqlDataSource runat="server" ID="srcAnswers4" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, ans.Answer_Text FROM tblScreening_Answers ans WHERE ans.QuestionID = @QuestionID ORDER BY ans.Answer_SequenceNumber"
                >
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlAnswerKeyQuestion4" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />

            <asp:Label runat="server" ID="Label28" Text="Answer Key 5:" CssClass="Label StdWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlAnswerKeyQuestion5" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="ID" AutoPostBack="true"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlAnswerKey5" DataTextField="Answer_Text" DataValueField="ID" DataSourceID="srcAnswers5"></asp:DropDownList>
            <asp:SqlDataSource runat="server" ID="srcAnswers5" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
                SelectCommand="SELECT ID, ans.Answer_Text FROM tblScreening_Answers ans WHERE ans.QuestionID = @QuestionID ORDER BY ans.Answer_SequenceNumber"
                >
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlAnswerKeyQuestion5" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />

            <asp:Button runat="server" ID="btnSave" CommandName="Insert" Text="Save" />
        </InsertItemTemplate>
    </asp:FormView>

    <asp:Panel runat="server" ID="pnlQuestionsForSet" Visible="true">
        <div style="width: 95%; border: solid 1px black;">
            <!-- select Question from list -->
            <asp:SqlDataSource runat="server" ID="srcQuestions"
                SelectCommandType="Text" SelectCommand="SELECT ID AS QuestionID, QuestionText, QuestionSequence FROM tblScreening_Questions WHERE SurveyTypeID = @SurveyTypeID ORDER BY QuestionSequence"
                ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'>
                <SelectParameters>
                    <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
                </SelectParameters>    
            </asp:SqlDataSource>
            <asp:Label runat="server" ID="Label17" Text="Select Question to Edit:" CssClass="Label WideWidthLabel"></asp:Label>
            <asp:DropDownList runat="server" ID="ddlQuestion" DataSourceID="srcQuestions" DataTextField="QuestionText" DataValueField="QuestionID" AutoPostBack="true"></asp:DropDownList>
            <br />

            <!-- question detail for this Question set -->
            <asp:SqlDataSource runat="server" ID="srcQuestionDetail" 
                SelectCommandType="Text"
                SelectCommand="SELECT qu.ID AS QuestionID, qu.QuestionText, qu.QuestionSequence, ISNULL(lnk.MaxScore, 0) AS MaxScore FROM tblScreening_Questions qu LEFT OUTER JOIN tblScreening_LINK_QuestionsToSets lnk ON (qu.ID = lnk.QuestionID) AND (lnk.QuestionSetID = @QuestionSetID) WHERE qu.ID = @QuestionID"
                ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'>
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlQuestion" PropertyName="SelectedValue" />
                    <asp:ControlParameter Name="QuestionSetID" Type="Int32" ControlID="ddlQuestionSets" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:FormView runat="server" ID="fvQuestionDetail" DataSourceID="srcQuestionDetail">
                <ItemTemplate>
                    <asp:Label runat="server" ID="Label19" Text="Max Score:" CssClass="Label WideWidthLabel"></asp:Label>
                    <asp:TextBox runat="server" ID="txtMaxScore" Text='<%# Eval("MaxScore") %>'></asp:TextBox>
                    <br />
                </ItemTemplate>
            </asp:FormView>

            <!-- list Answers for selected Question -->
            <asp:SqlDataSource runat="server" ID="srcAnswers"
                SelectCommandType="StoredProcedure"
                SelectCommand="prcScreening_AnswerDetail_ForQuestion"
                ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'>
                <SelectParameters>
                    <asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="ddlQuestion" PropertyName="SelectedValue" />
                    <asp:ControlParameter Name="QuestionSetID" Type="Int32" ControlID="ddlQuestionSets" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView runat="server" ID="gvAnswers" DataSourceID="srcAnswers" DataKeyNames="AnswerID" GridLines="Both" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField HeaderText="" DataField="AnswerID" ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="Answer">
                        <ItemTemplate>
                            <asp:HiddenField runat="server" ID="hidAnswerID" Value='<%# Eval("AnswerID") %>' />
                            <asp:HiddenField runat="server" ID="hidQuestionSetID" Value='<%# Eval("QuestionSetID") %>' />
                            <asp:Label runat="server" ID="Label20" Text='<%# Eval("Answer_Text") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Answer Value (% of Question Max Score)">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="txtAnsPrct" Text='<%# String.Format("{0:0.0}", 100 * Eval("Answer_Prct")) %>' Width="50px"></asp:TextBox>%
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Is Best?">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:CheckBox runat="server" ID="cbIsBest" Checked='<%# Eval("IsBest_YN") %>'></asp:CheckBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Is Least Acceptable?">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:CheckBox runat="server" ID="cbIsLA" Checked='<%# Eval("IsLeastAcceptable_YN") %>'></asp:CheckBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Is Worst?">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:CheckBox runat="server" ID="cbIsWorst" Checked='<%# Eval("IsWorst_YN") %>'></asp:CheckBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <asp:Button runat="server" ID="btnSaveQuestion" Text="Save Question" />
        </div>
        <br />
        <br />

        <!-- View all questions, max scores, and answer values -->
        <div id="divQandA" style="display: block; float: left; border: solid 1px black; padding: 10px; height: 600px; overflow-y: scroll;">
            <table>
                <tr>
                    <td>
                        <asp:SqlDataSource runat="server" ID="srcAllQuestions" SelectCommandType="Text" SelectCommand="SELECT qus.ID AS QuestionID, CASE WHEN ISNULL(qus.DesignerNote, '') = '' THEN '' ELSE '[' + qus.DesignerNote + '] ' END + qus.QuestionText AS Question, qus.QuestionText, qus.QuestionSequence, @QuestionSetID AS QuestionSetID, ISNULL(lnk.MaxScore, 0.0) AS MaxScore FROM tblScreening_Questions qus LEFT OUTER JOIN tblScreening_LINK_QuestionsToSets lnk ON (qus.ID = lnk.QuestionID) AND (lnk.QuestionSetID = @QuestionSetID) WHERE qus.SurveyTypeID = @SurveyTypeID ORDER BY QuestionSequence"
                             ConnectionString='<%$ ConnectionStrings:ACA_ScreeningConnectionString %>'>
                            <SelectParameters>
                                <asp:ControlParameter Name="QuestionSetID" Type="Int32" ControlID="ddlQuestionSets" PropertyName="SelectedValue" />
                                <asp:QueryStringParameter Name="SurveyTypeID" Type="Int32" QueryStringField="SurveyTypeID" />
                            </SelectParameters>     
                        </asp:SqlDataSource>
                        <asp:Repeater runat="server" ID="rptQuestions" DataSourceID="srcAllQuestions">
                            <ItemTemplate>
                                <%# Eval("QuestionSequence")%> : <%# Eval("Question")%> (Max Points: <%# Eval("MaxScore")%>)<br />
                                 <table style="margin-left: 20px; padding-left: 10px; padding-right: 10px; padding-top: 5px; padding-bottom: 5px;">
                                    <tr>
                                        <asp:Repeater runat="server" ID="rptAnswers">
                                            <ItemTemplate>
                                                <td style="padding-left: 10px; padding-right: 10px; padding-top: 5px; padding-bottom: 5px;">
                                                    <%# Eval("Answer_Text")%> (<%# String.Format("{0:0.0 %}", Eval("Answer_Prct"))%>)&nbsp;&nbsp;
                                                    <%# IIf(Eval("IsBest_YN") <> 0, "<span style='background-color: Yellow'>&nbsp;&nbsp;</span>", "")%><%# IIf(Eval("IsLeastAcceptable_YN") <> 0, "<span style='background-color: Orange'>&nbsp;&nbsp;</span>", "")%><%# IIf(Eval("IsWorst_YN") <> 0, "<span style='background-color: Red'>&nbsp;&nbsp;</span>", "")%>
                                                    <asp:HiddenField runat="server" ID="hidAnsID" Value='<%# Eval("AnswerID") %>' />
                                                </td>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tr>
                                 </table>
                            </ItemTemplate>
                        </asp:Repeater>
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>

</div>
</form>
</body>