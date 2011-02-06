<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/onlinereg.Master"
    Inherits="System.Web.Mvc.ViewPage<CmsWeb.Models.PaymentForm>" %>

<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
    <%= SquishIt.Framework.Bundle.JavaScript()
        .Add("/Content/js/jquery-1.4.2.js")
        .Add("/Content/js/jquery-ui-1.8.2.custom.js")
        .Add("/Content/js/jquery.idle-timer.js")
        .Add("/Content/js/jquery.showpassword-1.0.js")
        .Add("/Content/js/jquery.validate.js")
        .Add("/Scripts/OnlineRegPayment.js")
        .Render("/Content/OnLineRegPayment_#.js")
    %>
    <script type="text/javascript">
        $(function () {
            $(document).bind("idle.idleTimer", function () {
                window.location.href = '<%=Model.ti.Url %>';
            });
            var tmout = parseInt('<%=ViewData["timeout"] %>');
            $.idleTimer(tmout);
        });
    </script>
<div class="regform" style="width:400px">
    <h2>
        Payment Processing</h2>
<% if(ViewData.ContainsKey("Terms"))
   { %>
    <a id="displayterms" title="click to display terms" href="#">Display Terms</a>
    <div id="Terms" title="Terms of Agreement" class="modalPopup" style="display: none;
        width: 400px; padding: 10px">
        <%=ViewData["Terms"] %></div>
    <p>
        <%=Html.CheckBox("IAgree") %>
        I agree to the above terms and conditions.</p>
    <p>
        You must agree to the terms above for you or your minor child before you can continue.</p>
<% } %>
    <form action="/onlinereg/ProcessPayment/<%=Model.ti.DatumId %>" method="post">
    <%=Html.Hidden("pf.ti.DatumId", Model.ti.DatumId) %>
    <%=Html.Hidden("pf.ti.Url", Model.ti.Url) %>
    <%=Html.Hidden("pf.AskDonation", Model.AskDonation) %>
    <%=Html.Hidden("pf.ti.Amt", Model.ti.Amt) %>
<% if (Model.AskDonation)
   { %>
    <%=Html.Hidden("pf.ti.Regfees", Model.ti.Regfees)%>
<% } %>
    <table width="100%">
    <col align="right" style="white-space:nowrap;padding-right:10px" />
    <col align="left" />
    <tr><td>Name</td>
        <td><%=Html.TextBox("pf.ti.Name", Model.ti.Name, new { @class = "wide" })%></td></tr>
    <tr><td>Address</td>
        <td><%=Html.TextBox("pf.ti.Address", Model.ti.Address, new { @class = "wide" })%></td></tr>
    <tr><td>City</td>
        <td><%=Html.TextBox("pf.ti.City", Model.ti.City, new { @class = "wide" }) %></td></tr>
    <tr><td>State</td>
        <td> <%=Html.TextBox("pf.ti.State", Model.ti.State, new { @class = "short" }) %></td></tr>
    <tr><td>Zip</td>
        <td> <%=Html.TextBox("pf.ti.Zip", Model.ti.Zip, new { @class = "wide" }) %></td></tr>
    <tr><td>Phone</td>
        <td><%=Html.TextBox("pf.ti.Phone", Model.ti.Phone, new { @class = "wide" }) %></td></tr>
    <tr><td>Email</td>
        <td><%=Html.TextBox("pf.ti.Emails", Model.ti.Emails, new { @class = "wide" }) %></td></tr>
<% if (Model.AskDonation)
   { %>
    <tr><td>Registration Fees</td>
        <td><span id="regfees" class="right"><%=Model.ti.Regfees.ToString2("N2")%></span></td></tr>
    <tr><td>Donate Additional Amount</td>
        <td><%=Html.TextBox("pf.ti.Donate", Model.ti.Donate, new { @class = "short" }) %>
            <a id="applydonation" href="#" style="font-size:90%">Apply Donation</a></td></tr>
<% } %>
    <tr><td>Total Transaction Amount</td>
        <td><span id="amt" class="right"><%=Model.ti.Amt.ToString2("N2")%></span></td></tr>
    <tr><td>Credit Card</td>
        <td><%=Html.TextBox("pf.CreditCard", Model.CreditCard, new { @class = "wide", autocomplete = "off" }) %></td></tr>
    <tr><td>Card ID number<br /><a id="findidclick" href="#"><span style="font-size:65%">How to find your ID#</span></a></td>
        <td><%=Html.TextBox("pf.CCV", Model.CCV, new { @class = "short", autocomplete = "off" }) %></td></tr>
    <tr><td>Expires (MMYY)</td>
        <td><%=Html.TextBox("pf.Expires", Model.Expires, new { @class = "short", autocomplete = "off" }) %></td></tr>
    <tr><td></td>
        <td height="40"><input id="Submit" type="submit" name="Submit" class="submitbutton" value="Pay with Credit Card" />
            <div class="column"><%=Html.ValidationMessage("form") %></div></td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr><td>Payment Code</td>
        <td><%=Html.Password("Coupon", ViewData["Coupon"], new { @class = "wide", autocomplete = "off" }) %><br />
            <input id="showpassword" type="checkbox" /> Show Code</td></tr>
    <tr><td></td>
        <td>
        <a href="/OnlineReg/ApplyCoupon/<%=Model.ti.DatumId %>" class="submitbutton">Apply Code</a>
        <div class="right red" id="validatecoupon"></div>
        </td></tr>
    </table>
    </form>
</div>
<div id="findid" style="display:none"> 
<h2>Card Identification #</h2>
<table width="100%">
<tr>
    <td><h3>American Express</h3></td>
    <td><img src="/images/amex.jpg" alt="amex" /></td>
</tr>
<tr>
    <td><h3>Visa</h3></td>
    <td><img src="/images/visa.jpg" alt="visa" /></td>
</tr>
<tr>
    <td><h3>MasterCard</h3></td>
    <td><img src="/images/mastercard.jpg" alt="mastercard" /></td>
</tr>
<tr>
    <td><h3>Discover</h3></td>
    <td><img src="/images/discovercard.jpg" alt="discover" /></td>
</tr>
</table>

</div> 
</asp:Content>