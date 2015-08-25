<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="IncomeCalc.ascx.vb"
    Inherits="ACA_Screening.IncomeCalc" %>
<link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
<link href="../Content/bootstrap.css" rel="stylesheet" type="text/css" />

<%--<script src="../Scripts/jquery-1.9.1-vsdoc.js" type="text/javascript"></script>--%>

<script type="text/javascript">

    Sys.Application.add_init(appl_init);

    $(document).ready(function () {
        var numItems;

        $(".incomeFreqChange").live("change", function () {
            //var declarations
            var exactName = $(this).attr('id');
            var nameLen = exactName.length - 1;
            var numPosition = exactName.indexOf('ddlIncType') + 9;
            var lineNum = exactName.substr(nameLen, nameLen - numPosition);
            $("[id$=txtRate" + lineNum + "]").val('');
            $("[id$=txtHours" + lineNum + "]").val('');
            if ($(this).val() == 2000) {
                $("[id$=txtHours" + lineNum + "]").prop('disabled', false);
                $("[id$=txtHours" + lineNum + "]").css("background-color", "White");
            }
            else {
                $("[id$=txtHours" + lineNum + "]").prop('disabled', true);
                $("[id$=txtHours" + lineNum + "]").css("background-color", "LightGray");
            };
        });

        $(".incomeTypeChange").live("change", function () {
            //var declarations
            var exactName = $(this).attr('id');
            var nameLen = exactName.length - 1;
            var numPosition = exactName.indexOf('ddlIncType') + 9;
            var lineNum = exactName.substr(nameLen, nameLen - numPosition);
            var freq = $("[id$=ddlFrequency" + lineNum + "]");
            //disables txtHours on line with corresponding ddlIncomeType  if not earned income then remove hourly
            $("[id$=txtRate" + lineNum + "]").val('');
            $("[id$=txtHours" + lineNum + "]").val('');
            if ($(this).val() == "Earned Income") {
                freq.html('');
                freq.prepend('<option value="0">[SELECT]</option><option value="2000">Hourly</option><option value="52">Weekly</option><option value="26">Bi-Weekly</option><option value="12">Monthly</option><option value="1">Yearly</option>')
                $("[id$=txtHours" + lineNum + "]").prop('disabled', false);
                $("[id$=txtHours" + lineNum + "]").css("background-color", "White");
            }
            else {
                $("[id$=txtHours" + lineNum + "]").prop('disabled', true);
                $("[id$=txtHours" + lineNum + "]").css("background-color", "LightGray");
                freq.find("option[value=2000]").remove();
            };
        });

        $('.input').live('change', function () {
            inputChange();
        });
//        $('select').live('change', function () {
//            inputChange();
//        });

        function inputChange() {
            var tot = 0.0;
            var gtot = 0.0;
            var num = $("[id$=lblNumItems]").text();
            for (i = 0; i < num; i++) {

                var itype = $("[id$=ddlIncType" + i + "]");
                var freq = $("[id$=ddlFrequency" + i + "]");
                var rate = $("[id$=txtRate" + i + "]");
                var hrs = $("[id$=txtHours" + i + "]");
                var amt = $("[id$=txtIncomeAmount" + i + "]");
                if (freq == 2000) {
                    tot = hrs.val() * rate.val() * 52;
                }
                else {
                    tot = rate.val() * freq.val();
                }
                gtot = gtot + tot;
                amt.val((tot).toFixed(2).toString());
            }
            var ggt = $("[id$=txtGrandTotal]");
            ggt.val((gtot).toFixed(2).toString());
        }
    });

    function appl_init() {
        var pgRegMgr = Sys.WebForms.PageRequestManager.getInstance();
        pgRegMgr.add_endRequest(EndHandler);
    }

    function EndHandler() {
        //  afterAsyncPostBack();
        var num = $("[id$=lblNumItems]").text();
        for (i = 0; i < num; i++) {
            var itype = $("[id$=ddlIncType" + i + "]").val();
            var freq = $("[id$=ddlFrequency" + i + "]").val();
            var hrs = $("[id$=txtHours" + i + "]");
            if ((itype == 'Earned Income') && (freq == '2000')) {
                    hrs.attr("disabled", false);
            }
        }
    }


</script>
<style type="text/css">
    .bottom-padding
    {
        padding-bottom: 100px;
    }
    ul
    {
        list-style: none;
    }
    ul li
    {
        display: inline-block;
        padding: 0 5px;
    }
    li
    {
        margin: 2px 5px 2px 5px;
        padding: 2px 5px 2px 5px;
    }
    :disabled
    {
        background-color:lightgray;
        }

    .lblNumItems
    {
        display:none;
     }

</style>
<div id="divIncomeCalcContainer" >
    <div id="divIncomeCalc">
        <div id="divIncomeQuestions" class="center-block">
            <div id="divFamIncomeContainer">
                <ul>
                    <li style="width: 70px;">Person</li>
                    <li style="width: 130px;">Type of Income</li>
                    <li style="width: 100px;">Frequency</li>
                    <li style="width: 100px;">Rate</li>
                    <li style="width: 100px;">Hours/Week</li>
                    <li style="width: 80px;">Annual Income</li>
                </ul>
                <ul>
                    <li style="width: 70px">
                        <asp:UpdatePanel ID="upnlPerson" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phPerson" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                    <li style="width: 130px;">
                        <asp:UpdatePanel ID="upnlIncomeType" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phIncomeType" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                    <li style="width: 100px;">
                        <asp:UpdatePanel ID="upnlFrequency" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phFrequency" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                    <li style="width: 100px;">
                        <asp:UpdatePanel ID="upnlRate" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phRate" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                    <li style="width: 100px;">
                        <asp:UpdatePanel ID="upnlHours" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phHours" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                    <li style="width: 80px;">
                        <asp:UpdatePanel ID="upnlIncomeAmount" runat="server">
                            <ContentTemplate>
                                <asp:PlaceHolder ID="phIncomeAmount" runat="server"></asp:PlaceHolder>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </li>
                </ul>
            </div>
            <br />
            <asp:Button ID="btnAddIncome" runat="server" Text="More Income" />
            <br />
        
            <br />
            <asp:Label ID="Label1" runat="server" Width="375px"></asp:Label>
            <asp:Label ID="Label2" runat="server" text="Total Family Income : "></asp:Label>
            <asp:TextBox ID="txtGrandTotal" runat="server" Enabled="false"></asp:TextBox>
        
        
        </div>
    </div>
</div>





<p>
    &nbsp;<asp:UpdatePanel ID="upnlHidLabel"  runat="server" >
        <ContentTemplate>
            <asp:PlaceHolder  ID="phHidLabel" runat="server" ></asp:PlaceHolder>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnAddIncome" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    &nbsp;
</p>
<br /><br />




<%--<asp:Label ID="lblNumItems" runat="server" Text=""></asp:Label>--%>
<%--<asp:HiddenField ID="hidNumItems" runat="server" />
--%>
<%--<script type="text/javascript">
	$(function () {
		//$('ul li:first-child input').css('width', '120px');
		//$('li').css('width', '120px');
		//$('ul li:first-child').css('width', '120px');
		//$('ul li:first-child').css('padding-right', '10px');
		//$('select').after('<br />');
		//$('input').after('<br />');

		//$('[id*=lblQuestion]').css('border', '3px solid black');
		//		$('tr td:first-child').css('width', '350px');
		//		$('tr td:not(:first-child)').addClass('text-center');
		//		$('tr td').css('padding-left', '10px');
		//		//$('tr td:first-child').css('display', 'inline');
		//		//$('tbody').css('padding', '10px');

		//		$('tr:first-child').css('padding-left', '10px');
		//		//$("div:contains('pnlFamMem')").css('border', '3px solid black');
		//		$('td').css('padding', '0px 0px 20px 0px');
		//		//$("[id*='pnlFamMem'").css('border', '3px solid black'); // ('padding-bottom', '60px');
		//		$('tbody > children').css('padding-bottom', '30px');
	});
</script>--%>