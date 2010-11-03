﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<CmsWeb.Models.CouponModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>List</title>
    <style>
        .alt 
        {
            background-color: #eee;
        }
    </style>
</head>
<body style="font-family:Arial">
    <script src="/Content/js/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function() {
            $("a.confirm").click(function() {
                return confirm("are you sure?");
            });
        });
    </script>
    <div>
    <form action="/Coupon/List" method="post">
    <table>
    <tr><td>User:</td><td><%=Html.DropDownList("useridfilter", Model.Users()) %></td></tr>
    <tr><td>Reg:</td><td><%=Html.DropDownList("regidfilter", Model.OnlineRegs()) %></td></tr>
    <tr><td>Status:</td><td><%=Html.DropDownList("usedfilter", Model.CouponStatus()) %></td></tr>
    <tr><td>Name:</td><td><%=Html.TextBox("name") %></td></tr>
    <tr><td>Date:</td><td><%=Html.TextBox("date") %></td></tr>
    </table>
    <input name="submit" type="submit" value="Search" />
    <input name="submit" type="submit" value="Excel" />
    </form>
    </div>
    
    <table cellpadding="4" cellspacing="0">
        <tr>
            <th></th>
            <th>
            </th>
            <th>
                User<br />
                Purchaser<br />
                Person
            </th>
            <th>
                <br />
                Coupon Amt<br />
                Trans. Amt
            </th>
            <th>
                <br />
                <br />
                Registration
            </th>
            <th>
                Created<br />
                Used<br />
            </th>
        </tr>

    <%  var n = 0;
        foreach (var item in Model.Coupons()) 
        {
            n++; %>
        <tr <%= (n % 2) == 0? "class='alt'" : "" %>>
            <td>
                <% if (!item.Used.HasValue && !item.Canceled.HasValue)
                   {
                      %>

                <%= Html.ActionLink("X", "Cancel", new { id = item.Code }, new { @class = "confirm" })%>
                <% } %>
            </td>
            <td nowrap="nowrap">
                <span style="font-family:Courier New"><%= Html.Encode(item.Coupon) %></span>
            </td>
            <td>
                <%= item.UserName %><br />
                <%= item.Name %><br />
                <%= item.Person ?? "na" %>
            </td>
            <td align="right">
                <%= Html.Encode(item.Amount.ToString2("C")) %><br />
                <%= Html.Encode(item.RegAmt.ToString2("C")) %>
            </td>
            <td>
                <%= item.OrgDivName %>
            </td>
            <td>
                <%= Html.Encode(item.Created.FormatDateTm()) %><br />
                <%= Html.Encode(item.Used.FormatDateTm(item.Canceled.HasValue ? "canceled" : "not used"))%><br />
            </td>
            <td>
            </td>
        </tr>
    
    <% } %>

    </table>

    <p>
        <%= Html.ActionLink("Coupon", "Index") %>
    </p>

</body>
</html>

