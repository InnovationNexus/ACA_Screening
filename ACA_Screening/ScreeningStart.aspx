<%@ Page Title="ACA Medicaid Screening" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ScreeningStart.aspx.vb"
	Inherits="ACA_Screening.ScreeningStartPage" MaintainScrollPositionOnPostback="true" %>

<%@ Register TagPrefix="ACA" TagName="Screening" Src="Controls/Screening.ascx" %>
<%@ Register TagPrefix="ACA" TagName="IncomeCalc" Src="Controls/IncomeCalc.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<link rel="stylesheet" type="text/css" href="Styles/ACA.css" />
	<script type="text/javascript">
		$(document).ready(function () {

			//Privacy Icon Click BEGIN
			$('.divPrivacyInfo').hide();
			$('.spanPrivacyIcon').hover(function () {
				$('.divPrivacyInfo').toggle(); //css('visibility', 'visible');
			});
			//Privacy Icon Click END

			//Textbox Placeholder BEGIN
			$('[id$=txtEmployerCd]').attr('placeholder', 'Employer Code');
			$('[id$=txtEmpName]').attr('placeholder', 'Employer Name');
			$('[id$=txtEmployeeNo]').attr('placeholder', 'Employee Number');
			$('[id$=txtFirstName]').attr('placeholder', 'First');
			$('[id$=txtMiddleName]').attr('placeholder', 'MI');
			$('[id$=txtLastName]').attr('placeholder', 'Last');
			$('[id$=txtSSN]').attr('placeholder', 'Social Security Number');
			$('[id$=txtDOB]').attr('placeholder', 'Birth Date');
			//Textbox Placeholder END

			//Center and capitalize employer text BEGIN
			var txtEmpCd = $('[id$=txtEmployerCd]');
			var txtEmpName = $('[id$=txtEmpName]');
			if (txtEmpCd.val() !== "") {
				txtEmpCd.addClass("text-center");
			}
			if (txtEmpName.val() !== "") {
				txtEmpName.addClass("text-center");
			}
			txtEmpCd.change(function () {
				$(this).val($(this).val().toUpperCase());
			});
			//Center and capitalize employer text END

			//SSN Mask
			$(".ssn").mask("999-99-9999");

			//DOB Mask
			$(".dob").mask("99/99/9999");

			//ToDo: Only change focus if NOT a postback
			//Focus on Employer Code if it wasn't already provided (via querystring).
			//Otherwise, focus on employee number on pageload
			$('[id$=txtEmployeeNo]').focus();
		});

		function RemoveWarning() {
			var div1 = $('[id$=divInvalidEmpCode]');
			div1.css('display', 'none');
			var div2 = $('[id$=divShade]');
			div2.css('display', 'none');
			var emp1 = $('[id$=txtEmployerCd]');
			emp1.val = '';
		}
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true">
	</asp:ScriptManager>
	<div class="info_container" id="informationHeader">
		<div class="instructions-control center-block border-radius bg-primary">
			<p id="instructionParagraph" class="text-left center-block">
				We will ask just a few questions to determine your possible medical/heath insurance options.&nbsp;&nbsp; This tool will
				provide you with the information you need to make an informed choice about your healthcare coverage.&nbsp;&nbsp; All of
				your personal information is kept strictly confidential and will not be shared with any 3rd parties nor with your employer.
			</p>
		</div>
	</div>
	<div id="divStart" class="divStart center-block border-radius" runat="server">
		<div class="form-group-custom">
			<asp:Label ID="lblEmployerCd" runat="server" CssClass="bg-custom col-md-3 col-sm-4 col-xs-8" Text="Employer Code:"></asp:Label>
			<asp:TextBox ID="txtEmployerCd" runat="server" CssClass="form-control cust-input" AutoPostBack="true" CausesValidation="False" />
			<asp:RequiredFieldValidator ID="valEmployerCd" runat="server" ControlToValidate="txtEmployerCd" ErrorMessage="Employer Code is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red"></asp:RequiredFieldValidator>
			<span class="spanPrivacyIcon"><span class="glyphicon glyphicon-comment"></span><span style="position: relative; top: -2px;">
				Privacy Info</span> </span>
		</div>
		<div class="form-group-custom">
			<asp:UpdatePanel ID="upnlEmpName" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
					<asp:Label ID="lblEmpName" runat="server" CssClass="bg-custom col-md-3 col-sm-4 col-xs-8" Text="Employer Name:"></asp:Label>
					<asp:TextBox ID="txtEmpName" runat="server" Enabled="false" CssClass="form-control cust-input" />
				</ContentTemplate>
			</asp:UpdatePanel>
		</div>
		<div class="form-group-custom">
			<asp:Label ID="lblEmployeeNo" runat="server" CssClass="bg-custom col-md-3 col-sm-4 col-xs-8" Text="Employee Number:"></asp:Label>
			<asp:TextBox ID="txtEmployeeNo" runat="server" CssClass="form-control cust-input" Text='' />
			<asp:RequiredFieldValidator ID="valEmployeeNo" runat="server" ControlToValidate="txtEmployeeNo" ErrorMessage="Employee Number is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red"></asp:RequiredFieldValidator>
		</div>
		<div class="form-group-custom">
			<asp:Label ID="lblFirstName" runat="server" CssClass="bg-custom col-md-2 col-sm-3 col-xs-6" Text="Name:"></asp:Label>
			<span class="col-md-1 col-sm-2 col-xs-4"></span>
			<asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control col-md-4 col-sm-6 col-xs-12 cust-input" Text='' />
			<asp:RequiredFieldValidator ID="valFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First Name is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red"></asp:RequiredFieldValidator>
			<asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control col-md-1 col-sm-2 col-xs-4 cust-input" Text='' Style="width: 60px;" />
			<asp:TextBox ID="txtLastName" runat="server" CssClass="form-control cust-input" Text='' />
			<asp:RequiredFieldValidator ID="valLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last Name is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red"></asp:RequiredFieldValidator>
		</div>
		<div class="form-group-custom">
			<asp:Label ID="lblSSN" runat="server" CssClass="bg-custom col-md-3 col-sm-4 col-xs-8" Text="Social Security #:"></asp:Label>
			<asp:TextBox ID="txtSSN" runat="server" CssClass="form-control cust-input ssn" Text='' CausesValidation="false" />
			<%-- <asp:RequiredFieldValidator ID="valSSN" runat="server" ControlToValidate="txtSSN" ErrorMessage="Social Security Number is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red" SetFocusOnError="false"></asp:RequiredFieldValidator>--%>
		</div>
		<div class="form-group-custom">
			<asp:Label ID="lblDOB" runat="server" CssClass="bg-custom col-md-3 col-sm-4 col-xs-8" Text="Birth Date:"></asp:Label>
			<asp:TextBox ID="txtDOB" runat="server" CssClass="form-control cust-input dob" Text='' CausesValidation="false" />
			<%--<asp:RequiredFieldValidator ID="valDOB" runat="server" ControlToValidate="txtDOB" ErrorMessage="Date of Birth is Required"
				Text="*" Display="Dynamic" ValidationGroup="valGroupStart" ForeColor="Red" SetFocusOnError="false"></asp:RequiredFieldValidator> --%>
			<%--			<asp:RegularExpressionValidator ID="valDOBEx" runat="server" ValidationExpression="^\d{1,2}\/\d{1,2}\/\d{4}$" ValidationGroup="valGroupStart"
				ControlToValidate="txtDOB" ErrorMessage="Invalid Date of Birth Entry" Display="Dynamic" CssClass="error"></asp:RegularExpressionValidator>--%>
		</div>
		<br />
		<div id="divValidation" class="validation center-block">
			<asp:ValidationSummary ID="ValidationSummary1" HeaderText="You must enter a value for the following:" EnableClientScript="true"
				DisplayMode="BulletList" ValidationGroup="valGroupStart" ShowSummary="true" runat="server" />
		</div>
		<br />
		<asp:Button ID="btnStart" runat="server" Text="Start Questionnaire" Width="250px" CssClass="center-block btn-primary btn-border-radius"
			ValidationGroup="valGroupStart" />
		<br />
	</div>
	<div id="divInvalidEmpCode" class="modal-alert" runat="server">
		<%--<div id="divInvalidEmpCode" class="center-block border-radius invalidEmpCdWarn" runat="server">--%>
		<p>
			<asp:Label ID="lblWarning" Class="padding10" runat="server" Text="Label"></asp:Label>
		</p>
		<input id="btnClose" class="center-block btn-primary btn-border-radius" type="button" value="Close" style="z-index: 2300;"
			onclick="RemoveWarning()" />
		<br />
	</div>
	<div id="divQuestions" runat="server" class="border-radius divQuestions center-this">
		<h4 class="text-center" style="background-color: #f0f8ff;">
			Question Session
		</h4>
		<ACA:Screening ID="acaScreeningQuestions" runat="server" />
	</div>
	<div id="divEligible" runat="server" class="eligibilityModal border-radius center-this">
		<div class="jumbotron">
			<h2 class="text-center" style="text-decoration: underline; padding-bottom: 0px; margin-bottom: 0px;">
				Questionnaire Complete
			</h2>
			<br />
			<p class="lead text-center">
				Good News! It appears that you may qualify for Medicaid healthcare coverage in your state!
			</p>
		</div>
		<p>
			<b>Pusuing Medicaid could save you a substantial amount of money compared to utilizing the insurance options offered by your
				employer.</b> In order to continue to assist you, we will need a little more information. We will then show you a comparison
			of your employer's insurance plan and the Medicaid coverage which is available to you so you can make an informed choice.
			We will also provide you with the information and documents you need to enroll in Medicaid if you wish.
		</p>
		<br />
		<asp:Button ID="btnEligible" runat="server" Text="Continue" CssClass="center-block" Style="margin-bottom: 10px;" />
	</div>
	<div id="divNotEligible" runat="server" class="eligibilityModal border-radius center-this">
		<div class="jumbotron">
			<h2 class="text-center" style="text-decoration: underline; padding-bottom: 0px; margin-bottom: 0px;">
				Questionnaire Complete
			</h2>
			<br />
			<p class="lead text-center">
				<asp:Label runat="server" ID="lblNegativeResponse">
				It appears that your best option for health insurance coverage may be the insurance offered by your employer. It does not
				appear that you would qualify for Medicaid in your state, although there are some less common situations for which we did
				not screen which could still qualify you for Medicaid. Alternatively, you can also look into the state insurance exchanges
				for coverage options.
				</asp:Label>
			</p>
		</div>
		<asp:Button ID="btnNotEligible" runat="server" Text="Return Home" CssClass="center-block btn-primary btn-border-radius" />
		<br />
	</div>
	<div id="divPrivacyInfo" class="divPrivacyInfo">
		<p>
			<strong class="text-center center-block"><span style="text-decoration: underline;">Privacy Policy</span></strong> This information
			is collected for the sole purpose of determining your health coverage options and additional benefits of which you may not
			be aware. Your information is kept strictly confidential and is never shared with any 3rd parties. Your employer will NOT
			be informed of your personal answers nor of your individual results from this survey.
		</p>
	</div>
	<div id="divIncomeCalc" class="border-radius divIncomeCalc center-this" style="display:none;" runat="server">
		<h4 class="text-center" style="background-color: White; padding: 10px;">
			Income Calculator
		</h4>
		<ACA:IncomeCalc ID="acaIncomeCalc" runat="server" EnableViewState="true" />
	</div>

    <div id="divCloseBtn" runat="server" style="display:none; z-index:2200;">
    
         <asp:Button ID="Button2" runat="server" Text="Button" />
    </div>
    
    

	<div id="divShade" runat="server" class="shader">
		&nbsp;<asp:Button ID="Button1" runat="server" Text="Button" />
	</div>
	<!-- NOTES & COMMENTS -- JQUERY

			//Instructions Fade Begin
			//			$('.cust-input').click(function () {
			//				$('.instructions-control').html("<p class='text-left bg-primary center-block'>We will ask a handfull of questions to determine your eligibility for medicaid. &nbsp;&nbsp; After you have finished, we will provide you with...<br /><span class='border-radius' style='background-color:white;color:#2c3e50;padding:3px;margin-left:380px;'>Click here to read more...</span>");
			//			});

			//			$('.instructions-control').click(function () {
			//				$('.instructions-control').html("<p class='text-left bg-primary center-block'>We will ask a handfull of questions to determine your eligibility for medicaid. &nbsp;&nbsp; After you have finished, we will provide you with information you need to pursue healthcare coverage. &nbsp;&nbsp; If you are deemed eligible, we will ask for your contact information. &nbsp;&nbsp; We use this to send you detailed information regarding your options for healthcare coverage. &nbsp;&nbsp; Once you have submitted your contact information, we will send you even a informational packet to help educate and inform you on your choices for health coverage.</p>");
			//			});
			//Instructions Fade End

	-->
</asp:Content>
