<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ScreeningSuccess.aspx.vb"
	Inherits="ACA_Screening.ScreeningSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">

		//change this to use css center-this class
		jQuery.fn.center = function () {
			this.css("position", "relative");
			this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                $(window).scrollTop()) + "px");
			this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                $(window).scrollLeft()) + "px");
			return this;
		}

		$(document).ready(function () {
			$('.UpdateBtn').click(function (sender, e) {
				$("[id$=CompChart]").css('visibility', 'visible');
			});

			//			$('.cust-input').css('width', '260px');
			$('.ddl').css('width', '200');
			$('.firstColumn').css('width', '200');
			$('[id$=divSuccessInfo]').children().children('input,select').css('margin-right', '0px');
			$('[id$=divSuccessInfo]').children().children('input,select').addClass('center-block');
			$('[id$=divOuter]').center();
			$('th').addClass('text-centered');
			//			$('table').css('width', '100%');
			//			$('tbody').css('position', 'relative');
			//			$('tbody').css('left', '25%');
			//			$('tbody').css('top', '25%');
			//			$('tbody').css('width', '800px');
			//			$('tbody').css('width', '80%');
			//			$('tbody').css('margin', '0 auto');
			//			$('tbody').css('width', '100%');
			//			$('tr:first-child').css('width', '80%');
			//			$('tr:first-child').css('margin', '0 auto');
			//			$('tbody').addClass('center-block');
			//			$('tr:first-child').addClass('center-block');

			//Textbox Placeholder Begin
			$('[id$=txtEmployerCd]').attr('placeholder', 'Employer Code');
			$('[id$=txtEmployeeNo]').attr('placeholder', 'Employer Number');
			$('[id$=txtFirstName]').attr('placeholder', 'First');
			$('[id$=txtMiddleName]').attr('placeholder', 'MI');
			$('[id$=txtLastName]').attr('placeholder', 'Last');
			$('[id$=txtSSN]').attr('placeholder', 'Social Security Number');
			$('[id$=txtDOB]').attr('placeholder', 'Birth Date');
			$('[id$=txtAddress1]').attr('placeholder', 'Address Line 1');
			$('[id$=txtAddress2]').attr('placeholder', 'Address Line 2');
			$('[id$=txtCity]').attr('placeholder', 'City');
			$('[id$=txtState]').attr('placeholder', 'ST');
			$('[id$=txtZip]').attr('placeholder', 'Zip');
			$('[id$=txtPhonePrimary]').attr('placeholder', 'Primary Phone Number');
			$('[id$=txtPhoneSecondary]').attr('placeholder', 'Secondary Phone Number');
			$('[id$=txtEmail]').attr('placeholder', 'Email Address');
			//Textbox Placeholder End

			//Phone Mask
			$('.phone').mask("(999)-999-9999");
		});
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div id="divOuter">
		<div id="divInner" style="width: 800px; margin: 0 auto;">
			<asp:FormView ID="fvScreenedPerson" runat="server" DataSourceID="SqlScreenedPerson" DataKeyNames="ID" CssClass="center-block">
				<EditItemTemplate>
					<div id="fvScreenedPerson_EditItemTemplate" class="test center-block">
						<div id="divSuccessInfo" class="divSuccess border-radius center-block">
							<div class="form-group-custom">
								<asp:Label ID="lblSalutation" runat="server" Text="Salutation:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:DropDownList ID="ddlSalutation" runat="server" CssClass="form-control cust-input ddl" SelectedValue='<%# Bind("Salutation") %>'>
									<asp:ListItem Value="" Text="None"></asp:ListItem>
									<asp:ListItem Value="Mr." Text="Mr."></asp:ListItem>
									<asp:ListItem Value="Mrs." Text="Mrs."></asp:ListItem>
									<asp:ListItem Value="Ms." Text="Ms."></asp:ListItem>
									<asp:ListItem Value="Miss" Text="Miss"></asp:ListItem>
								</asp:DropDownList>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblName" runat="server" Enabled="False" Text="Name:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtFirstName" runat="server" Text='<%# Eval("FirstName") %>' CssClass="form-control cust-input firstColumn" />
								<asp:RequiredFieldValidator ID="valFirstName" runat="server" ControlToValidate="txtFirstName" Text="*" ErrorMessage="Please enter your first name."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
								<asp:TextBox ID="txtMiddleName" runat="server" Text='<%# Bind("MiddleName") %>' CssClass="cust-input form-control" Style="width: 60px;" />
								<asp:TextBox ID="txtLastName" runat="server" Text='<%# Eval("LastName") %>' CssClass="form-control cust-input" />
								<asp:RequiredFieldValidator ID="valLastName" runat="server" ControlToValidate="txtLastName" Text="*" ErrorMessage="Please enter your last name."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblSuffix" runat="server" Text="Suffix:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:DropDownList ID="ddlSuffix" runat="server" CssClass="form-control cust-input ddl" SelectedValue='<%# Bind("Suffix") %>'>
									<asp:ListItem Value="" Text="None"></asp:ListItem>
									<asp:ListItem Value="Sr." Text="Sr."></asp:ListItem>
									<asp:ListItem Value="Jr." Text="Jr."></asp:ListItem>
									<asp:ListItem Value="III" Text="III"></asp:ListItem>
									<asp:ListItem Value="Esq" Text="Esq"></asp:ListItem>
								</asp:DropDownList>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblAddress1" runat="server" Text="Address 1:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtAddress1" runat="server" Text='<%# Bind("Address1") %>' CssClass="form-control cust-input" Style="width: 474px;" />
								<asp:RequiredFieldValidator ID="valAddress" runat="server" ControlToValidate="txtAddress1" Text="*" ErrorMessage="Please provide your current address."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblAddress2" runat="server" Text="Address 2:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtAddress2" runat="server" Text='<%# Bind("Address2") %>' CssClass="form-control cust-input" Style="width: 474px;" />
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblCityStateZip" runat="server" Text="City, State, Zip:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control cust-input firstColumn" />
								<asp:RequiredFieldValidator ID="valCity" runat="server" ControlToValidate="txtCity" Text="*" ErrorMessage="Please provide your current city of residence."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
								<asp:TextBox ID="txtState" runat="server" Enabled="False" Text='<%# hidStateProv.value %>' CssClass="form-control cust-input"
									Style="width: 60px;" />
								<asp:TextBox ID="txtZip" runat="server" Text='<%# Bind("Zip") %>' CssClass="form-control cust-input" Style="width: 208px;" />
								<asp:RequiredFieldValidator ID="valZip" runat="server" ControlToValidate="txtZip" Text="*" ErrorMessage="Please provide your current zip code."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblPhone1" runat="server" Text="Phone:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtPhonePrimary" runat="server" Text='<%# Bind("PrimaryPhone") %>' CssClass="form-control cust-input phone" Style="width: 235px;" />
								<asp:RequiredFieldValidator ID="valPhonePrimary" runat="server" ControlToValidate="txtPhonePrimary" Text="*" ErrorMessage="Please enter your primary phone number."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
								<asp:TextBox ID="txtPhoneSecondary" runat="server" Text='<%# Bind("SecondaryPhone") %>' CssClass="form-control cust-input phone"
									Style="width: 235px;" />
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblSSN" runat="server" Text="Social Security #:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtSSN" runat="server" Enabled="False" Text='<%# Eval("SSN") %>' CssClass="form-control cust-input" />
								<%--<asp:RequiredFieldValidator ID="SSN" runat="server" ControlToValidate="txtSSN" Text="*" ErrorMessage="Please enter your social security number."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>--%>
							</div>
							<div class="form-group-custom">
								<asp:Label ID="lblDOB" runat="server" Text="Date of Birth:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtDOB" runat="server" Enabled="False" Text='<%# Eval("DOB", "{0:MMMM d, yyyy}") %>' CssClass="form-control cust-input" />
								<asp:RequiredFieldValidator ID="valDOB" runat="server" ControlToValidate="txtDOB" Text="*" ErrorMessage="Please enter your date of birth."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
							</div>
							<div id="divPrimaryEmail" class="form-group-custom">
								<asp:Label ID="lblEmailPrimary" runat="server" Text="Email:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email_Primary") %>' CssClass="form-control cust-input" />
								<asp:RegularExpressionValidator ID="valEmailRegEx" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="Invalid e-mail address."
									Text="*" ForeColor="Red" SetFocusOnError="true" EnableClientScript="true" ValidationExpression="^[\w\.\-]+@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]{1,})*(\.[a-zA-Z]{2,3}){1,2}$">  
								</asp:RegularExpressionValidator>
								<asp:RequiredFieldValidator ID="valEmailRequired" runat="server" ControlToValidate="txtEmail" Text="*" ErrorMessage="Please enter your email address."
									Display="Dynamic" ValidationGroup="valGroup" ForeColor="Red"></asp:RequiredFieldValidator>
							</div>
							<div id="divEmpCode" class="form-group-custom">
								<asp:Label ID="lblEmpCode" runat="server" Text="Employer Code:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtEmpCode" runat="server" Enabled="False" Text='<%# Eval("EmployerCode") %>' CssClass="form-control cust-input" />
							</div>
							<div id="divEmpID" class="form-group-custom">
								<asp:Label ID="lblEmployeeID" runat="server" Text="Employee ID:" CssClass="col-md-3 bg-custom"></asp:Label>
								<span class="col-md-1"></span>
								<asp:TextBox ID="txtEmployeeID" runat="server" Enabled="False" Text='<%# Eval("EmployeeID") %>' CssClass="form-control cust-input" />
							</div>
							<div id="divBestContact" class="form-group-custom">
								<asp:Label ID="lblBestWay" runat="server" CssClass="col-md-3 bg-custom" Text="Contact Method:"></asp:Label>
								<span class="col-md-1"></span>
								<asp:DropDownList ID="ddlBestWay" runat="server" CssClass="form-control cust-input" SelectedValue='<%# Bind("BestContactMethod") %>'
									Width="300px">
									<asp:ListItem Value="" Text="How should we contact you?"></asp:ListItem>
									<asp:ListItem Value="Phone" Text="Telephone"></asp:ListItem>
									<asp:ListItem Value="E-mail" Text="E-mail"></asp:ListItem>
									<asp:ListItem Value="Mail" Text="Postal Mail"></asp:ListItem>
								</asp:DropDownList>
								<asp:CompareValidator ID="valBestWay" runat="server" ControlToValidate="ddlBestWay" ValueToCompare="" Type="String" Operator="NotEqual"
									ErrorMessage="You must select a Best Contact Method." Text="*" SetFocusOnError="true"></asp:CompareValidator>
							</div>
							<br />
							<div id="divValidation" class="validation center-block">
								<asp:ValidationSummary ID="ValidationSummary1" HeaderText="You must enter a value for the following:" EnableClientScript="true"
									DisplayMode="BulletList" ValidationGroup="valGroup" ShowSummary="true" runat="server" />
							</div>
							<br />
							<asp:Button ID="UpdateButton" CssClass="UpdateBtn center-block" runat="server" CausesValidation="True" CommandName="Update"
								Text="Submit" ValidationGroup="valGroup" />
							&nbsp;
							<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" Visible="False" />
						</div>
					</div>
				</EditItemTemplate>
			</asp:FormView>
		</div>
	</div>
	<asp:HiddenField ID="hidScreenedPersonID" runat="server" />
	<div id="divCompChart" runat="server" style="display: none; margin: 0 auto; width: 900px; border: 2px solid black; padding: 15px 15px 15px 15px;">
        <p>Below is a brief comparison of some of your healthcare coverage options.  We have put together a package with more detailed information as
        well as all of the forms you might need to pursue Medicaid coverage.  Please click on the 'Next Steps' button below to learn about the Medicaid
        application process, time frames, what you need to do, and what to expect.</p>
		<%--**********// Mock Comparison Chart //********** --%>
		<table style="width: 900px">
			<tr>
				<th>
				</th>
				<th>
					<span style="text-decoration: underline;">Medicaid Plan</span>
				</th>
				<th>
					<span style="text-decoration: underline;">Company Plan A</span>
				</th>
				<th>
					<span style="text-decoration: underline;">Company Plan B</span>
				</th>
			</tr>
			<tr>
				<th>
					<span style="z-index: 6; position: relative;">Monthly Premium</span>
				</th>
				<td>
					<span class="glyphicon glyphicon-thumbs-up"></span>&nbsp;&nbsp;&nbsp;$0
				</td>
				<td>
					$248
				</td>
				<td>
					$385
				</td>
			</tr>
			<tr>
				<th>
					Deductable
				</th>
				<td>
					<span class="glyphicon glyphicon-thumbs-up"></span>&nbsp;&nbsp;&nbsp;$20
				</td>
				<td>
					$120
				</td>
				<td>
					$65
				</td>
			</tr>
			<tr>
				<th>
					Co-pay
				</th>
				<td>
					<span class="glyphicon glyphicon-thumbs-up"></span>&nbsp;&nbsp;&nbsp;$10
				</td>
				<td>
					$40
				</td>
				<td>
					$20
				</td>
			</tr>
			<tr>
				<th>
					Max Out-of-Pocket
				</th>
				<td>
					<span class="glyphicon glyphicon-thumbs-up"></span>&nbsp;&nbsp;&nbsp;$100
				</td>
				<td>
					$400
				</td>
				<td>
					$150
				</td>
			</tr>
		</table>
		<br />
		<br />
		<br />
		<asp:Button ID="btnAppInstructions" runat="server" Text="Next Steps" CssClass="btn-primary center-block btn-border-radius">
		</asp:Button>
		<br />
		<asp:Button ID="btnSendInfo" runat="server" Text="View/Print Information and Forms Packet" CssClass="btn-primary center-block btn-border-radius"></asp:Button>
		<br />
		<br />
	</div>
	<div id="sqlDataSource">
		<asp:SqlDataSource ID="SqlScreenedPerson" runat="server" ConnectionString="<%$ ConnectionStrings:ACA_ScreeningConnectionString %>"
			SelectCommand="prcScreening_Get_ScreenedPersonRecord" SelectCommandType="StoredProcedure" UpdateCommand="prcScreening_UPDATE_ScreenedPersonRecord"
			UpdateCommandType="StoredProcedure">
			<SelectParameters>
				<asp:ControlParameter ControlID="hidScreenedPersonID" Name="ID" PropertyName="Value" Type="Int64" />
			</SelectParameters>
			<UpdateParameters>
				<asp:ControlParameter ControlID="hidScreenedPersonID" Name="ID" PropertyName="Value" Type="Int64" />
				<asp:Parameter Name="MiddleName" Type="String" />
				<asp:Parameter Name="Salutation" Type="String" />
				<asp:Parameter Name="Suffix" Type="String" />
				<asp:Parameter Name="Address1" Type="String" />
				<asp:Parameter Name="Address2" Type="String" />
				<asp:Parameter Name="City" Type="String" />
				<asp:Parameter Name="StateProv" Type="String" />
				<asp:Parameter Name="Zip" Type="String" />
				<asp:Parameter Name="Email_Primary" Type="String" />
				<asp:Parameter Name="Email_Secondary" Type="String" />
				<asp:Parameter Name="BestContactMethod" Type="String" />
				<asp:Parameter Name="PrimaryPhone" Type="String" />
				<asp:Parameter Name="SecondaryPhone" Type="String" />
			</UpdateParameters>
		</asp:SqlDataSource>
	</div>
	<asp:HiddenField ID="hidStateProv" runat="server" />
</asp:Content>
