<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/TicketTracker_Main.Master" CodeBehind="Screening_Setup_NewQuestionSet.aspx.vb" Inherits="TicketTracker.Screening_Setup_NewQuestionSet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script type="text/javascript">
        function setKey(key, ansID, ansText, questionSeq) {
            var hid = $("[id$=hidKeyAnswerID_" + key + "]");
            var lbl = $("[id$=lblKeyAnswerID_" + key + "]");
            hid.val(ansID);
            lbl.text('Q' + questionSeq + ' : ' + ansText + ' (' + ansID.toString() + ')');

            return false;
        }

        function clearKey(key) {
            var hid = $("[id$=hidKeyAnswerID_" + key + "]");
            var lbl = $("[id$=lblKeyAnswerID_" + key + "]");
            hid.val('');
            lbl.text('');

            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphLeftAccessBar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="server">
    <div id="divNewForm" style="display: block; float: left; width: 600px;">
        <asp:Label runat="server" ID="lblQSType" CssClass="Label StdWidthLabel" Text="Screening Type:"></asp:Label>
        <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ID="rblQSType" RepeatLayout="Flow">
            <asp:ListItem Text="Employability" Value="E"></asp:ListItem>
            <asp:ListItem Text="ERS Suitability" Value="S"></asp:ListItem>
        </asp:RadioButtonList>
        <br />
        <asp:Label runat="server" ID="lblQSDescription" CssClass="Label StdWidthLabel LblAlignTop" Text="Description:"></asp:Label>
        <asp:TextBox runat="server" ID="txtQSDescription" TextMode="MultiLine" MaxLength="200" Rows="2" Width="350px"></asp:TextBox>
        <br />
        <asp:HiddenField runat="server" ID="hidKeyAnswerID_1" Value="" />
        <asp:Label runat="server" ID="Label1" CssClass="Label StdWidthLabel" Text="Key Answer 1:"></asp:Label>
        <asp:Label runat="server" ID="lblKeyAnswerID_1" CssClass="Label Data" ></asp:Label>&nbsp;&nbsp;<a href="#" onclick="clearKey(1)">Clear</a>
        <br />
        <asp:HiddenField runat="server" ID="hidKeyAnswerID_2" Value="" />
        <asp:Label runat="server" ID="Label2" CssClass="Label StdWidthLabel" Text="Key Answer 2:"></asp:Label>
        <asp:Label runat="server" ID="lblKeyAnswerID_2" CssClass="Label Data" ></asp:Label>&nbsp;&nbsp;<a href="#" onclick="clearKey(2)">Clear</a>
        <br />
        <asp:HiddenField runat="server" ID="hidKeyAnswerID_3" Value="" />
        <asp:Label runat="server" ID="Label3" CssClass="Label StdWidthLabel" Text="Key Answer 3:"></asp:Label>
        <asp:Label runat="server" ID="lblKeyAnswerID_3" CssClass="Label Data" ></asp:Label>&nbsp;&nbsp;<a href="#" onclick="clearKey(3)">Clear</a>
        <br />
        <asp:Label runat="server" ID="Label4" CssClass="Label WideWidthLabel" Text="Red Zone Upper Limit:"></asp:Label>
        <asp:TextBox runat="server" ID="txtThreshhold_RedZone" Width="50px"></asp:TextBox>%
        <br />
        <asp:Label runat="server" ID="Label5" CssClass="Label WideWidthLabel" Text="Orange Zone Upper Limit:"></asp:Label>
        <asp:TextBox runat="server" ID="txtThreshhold_OrangeZone" Width="50px"></asp:TextBox>%
        <br />
        <asp:Label runat="server" ID="Label6" CssClass="Label WideWidthLabel" Text="Yellow Zone Upper Limit:"></asp:Label>
        <asp:TextBox runat="server" ID="txtThreshhold_YellowZone" Width="50px"></asp:TextBox>%
        <br />
        <asp:Label runat="server" ID="Label7" CssClass="Label WideWidthLabel" Text="Green Zone Upper Limit:"></asp:Label>
        <asp:TextBox runat="server" ID="txtThreshhold_GreenZone" Width="50px" Text="100"></asp:TextBox>%
        <br />
    </div>

    <div id="divQandA" style="display: block; float: left; border: solid 1px black; padding: 10px; height: 600px; overflow-y: scroll;">
        <table>
            <tr>
                <td>
                    <asp:SqlDataSource runat="server" ID="srcQuestions" SelectCommandType="Text" SelectCommand="SELECT QuestionID, QuestionText, QuestionSequence FROM tblTT_Screening_Questions ORDER BY QuestionSequence"
                         ConnectionString='<%$ ConnectionStrings:TicketTrackerConnectionString %>'></asp:SqlDataSource>
                    <asp:Repeater runat="server" ID="rptQuestions" DataSourceID="srcQuestions">
                        <ItemTemplate>
                            <%# Eval("QuestionSequence")%> : <%# Eval("QuestionText")%><br />
                                <ul style="margin-top: 2px; padding-top: 0px;">
                                    <asp:Repeater runat="server" ID="rptAnswers">
                                        <ItemTemplate>
                                            <li>
                                                <a href="#" onclick="setKey(1, '<%# Eval("AnswerID") %>', '<%# Eval("Answer_Text") %>', '<%# Eval("QuestionSequence") %>')">Key 1</a>
                                                <a href="#" onclick="setKey(2, '<%# Eval("AnswerID") %>', '<%# Eval("Answer_Text") %>', '<%# Eval("QuestionSequence") %>')">Key 2</a>
                                                <a href="#" onclick="setKey(3, '<%# Eval("AnswerID") %>', '<%# Eval("Answer_Text") %>', '<%# Eval("QuestionSequence") %>')">Key 3</a>&nbsp&nbsp;
                                                <%# Eval("Answer_Text")%>
                                                <asp:HiddenField runat="server" ID="hidAnsID" Value='<%# Eval("AnswerID") %>' />
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                        </ItemTemplate>
                    </asp:Repeater>
                </td>
            </tr>
        </table>
    </div>


</asp:Content>
