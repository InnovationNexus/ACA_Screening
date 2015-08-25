<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Screening.ascx.vb"
    Inherits="ACA_Screening.ScreeningWizard" %>
<link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
<link href="../Content/bootstrap.css" rel="stylesheet" type="text/css" />
<%--<script src="http://localhost:49467/Scripts/jquery-1.9.1-vsdoc.js" type="text/javascript"></script>--%>
<script type="text/javascript">
    function uniqueRadio(clickedRadio) {
        var rbs = $("[id*=rbAnswer]");
        for (var i = 0; i < rbs.length; i++) {
            if (rbs[i].value != clickedRadio.value) rbs[i].checked = false;
        }
    }

    $(document).ready(function () {
        //PROGRESS BAR JQUERY BEGIN 
        var hidPercComp = $('[id$=hidProgressPercentage]').val();
        $('.progress-bar').css("width", hidPercComp);
        $('.progress-bar-value').text(hidPercComp);
        $('.progess-bar').attr("aria-valuenow", hidPercComp);
        $('table td:first-child').css("padding", "0px 0px 0px 10px");
        //PROGRESS BAR JQUERY END 

        $('td').css('padding', '0px');
        $('[id$=divQuestion]').css('padding', '0px 5px 0px 5px');
        $('[id$=txtNotes]').css('margin', '0px 5px');

        $('#divQuestions').css('margin-left', '8px');
        $('[id$=ctrlAnswer]').css('margin-left', '25px');

    });

</script>
<div id="divWizContainer">
    <div id="divScreeningWizard">
        <div class="clear-fix">
        </div>
        <div id="divProgBarContainer">
            <div id="divProgressBar" class="progress center-block" style="width: 80%; text-align: center;">
                <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0"
                    aria-valuemax="100">
                    <span class="progress-bar-value">60%</span>
                </div>
                <asp:HiddenField runat="server" ID="hidProgressPercentage" Value="0%" />
            </div>
            <div id="divProgBarText">
                <span class="progress_bar_percent" style="visibility: hidden;">
                    <asp:Label runat="server" ID="lblPrctComplete" Text="0%"></asp:Label>
                    Complete<br />
                </span>
            </div>
        </div>
        <br />
        <div id="divQuestionContainer" style="width: 800px; max-height: 600px">
            <asp:Panel runat="server" ID="pnlQuestionaire" Visible="true">
                <asp:FormView runat="server" ID="fvQuestion" DataSourceID="srcQuestion" DataKeyNames="QuestionID">
                    <ItemTemplate>
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <div id="divQuestions" style="padding: 15px;">
                                            <span class="question">
                                                <%# Eval("QuestionText")%>
                                            </span>
                                            <br />
                                            <asp:Panel runat="server" ID="pnlAnswers">
                                            </asp:Panel>
                                            <br />
                                            <br />
                                        </div>
                                    </td>
                                    <td>
                                        <div id="divExplanationContainer" class="explanationContainer">
                                            <asp:Label runat="server" ID="txtExplanation" Text='<%# Eval("QuestionExplanation") %>'
                                                CssClass="explanationText"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNotesContainer" runat="server">
                            <asp:Label ID="lblNotes" runat="server" Style="margin-left: 8px;">Notes:</asp:Label>
                            <br />
                            <asp:TextBox runat="server" ID="txtNotes" Text="" TextMode="MultiLine" Rows="5" Width="784px"></asp:TextBox>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:FormView>
                <div id="divPagerContainer" class="QuestionnairePager">
                    <ul class="pager">
                        <li><a href="#" runat="server" id="btnPrevious1">Previous</a></li>
                        <li><a href="#" runat="server" id="btnNext1">Next</a></li>
                    </ul>
                </div>
                <asp:SqlDataSource runat="server" ID="srcQuestion" SelectCommand="SELECT ID AS QuestionID, QuestionText, QuestionExplanation, QuestionSequence, QuestionType, DataType FROM tblScreening_Questions WHERE ID = @QuestionID"
                    SelectCommandType="Text">
                    <SelectParameters>
                        <asp:Parameter Name="QuestionID" Type="Int32" DefaultValue='0' />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="srcAnswers" SelectCommand="prcScreening_LIST_AnswersForScreeningQuestion"
                    SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="QuestionID" Type="Int32" DefaultValue='0' />
                        <asp:Parameter Name="ScreeningLogID" Type="Int32" DefaultValue='0' />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
        </div>
        <div id="divResultsContainer">
            <asp:Panel runat="server" ID="pnlResults" Visible="false">
                <h2>
                    Screening Results
                </h2>
                <br />
                <!-- ToDo: obsolete.  Need to make this dynamically build as many score/rating bars as necessary based on QuestionSetTypes -->
                <table>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            ERS Suitability
                        </td>
                        <td style="width: 100px;">
                            &nbsp;
                        </td>
                        <td colspan="2" style="text-align: center;">
                            Employability
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div runat="server" id="divGuageSuitability" style="display: block; width: 50px;
                                height: 200px; background-color: #cfcfcf; padding: 0px; vertical-align: bottom;">
                                <div runat="server" id="divS_GuageLvl4" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divS_GuageLvl3" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divS_GuageLvl2" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divS_GuageLvl1" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div id="divMeterSuitability" style="display: block; width: 50px; height: 200px;
                                background-color: #cfcfcf; padding: 0px; vertical-align: bottom;">
                                <div runat="server" id="divRatingSuitability" style='display: block; padding: 0px;
                                    width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px; text-align: center;'>
                                    <span style="color: White; font-weight: bold; padding-top: 4px;">
                                        <asp:Label runat="server" ID="lblSuitabilityPrct"></asp:Label></span>
                                </div>
                            </div>
                        </td>
                        <td style="width: 100px;">
                            &nbsp;
                        </td>
                        <td>
                            <div runat="server" id="divGuageEmployability" style="display: block; width: 50px;
                                height: 200px; background-color: #cfcfcf; padding: 0px; vertical-align: bottom;">
                                <div runat="server" id="divE_GuageLvl4" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divE_GuageLvl3" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divE_GuageLvl2" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                                <div runat="server" id="divE_GuageLvl1" style='display: block; position: relative;
                                    padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px;'>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div id="divMeterEmployability">
                                <div runat="server" id="divRatingEmployability" style='display: block; padding: 0px;
                                    width: 46px; margin-left: 2px; margin-right: 2px; margin-bottom: 0px; text-align: center;'>
                                    <span style="color: White; font-weight: bold; padding-top: 4px;">
                                        <asp:Label runat="server" ID="lblEmployabilityPrct"></asp:Label></span>
                                </div>
                            </div>
                            <%--
							<div id="divMeterEmployability" style="display: block; width: 50px; height: 200px; background-color: #cfcfcf; padding: 0px;
								vertical-align: bottom;">
								<div runat="server" id="divRatingEmployability" style='display: block; padding: 0px; width: 46px; margin-left: 2px; margin-right: 2px;
									margin-bottom: 0px; text-align: center;'>
									<span style="color: White; font-weight: bold; padding-top: 4px;">
										<asp:Label runat="server" ID="lblEmployabilityPrct"></asp:Label></span>
								</div>
							</div>
                            --%>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:HiddenField ID="hidScreeningLogID" runat="server" />
        </div>
    </div>
</div>
<%--	ORIGINAL PROGRESS BAR CODE	
	
		<div id="divProgress" style="width: 750px;" class="center-block">
		<div runat="server" id="divProgress1" class="center-block" style="display: inline-block; height: 30px; width: 0px; vertical-align: middle;
			float: left;">
		</div>
		<div runat="server" id="divProgress2" class="center-block" style="display: inline-block; height: 20px; margin-top: 5px; width: 600px;
			background-color: #dfdfdf; vertical-align: middle; float: left;">
		</div>
			<span class="progress_bar_percent" style="visibility:hidden;">style="float: left; vertical-align: middle; margin-top: 6px; display: inline-block; z-index:200;"
				<asp:Label runat="server" ID="lblPrctComplete" Text="0%"></asp:Label>
				Complete<br />
			</span>
		</div>
--%>