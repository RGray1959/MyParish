﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<CmsWeb.Models.OnlineRegModel>" %>
   <select name="m.classid">
   <% foreach (var i in Model.Classes())
      { %>
   <option value="<%=i.Value %>" <%=i.Selected ? "selected='selected'" : "" %>><%=i.Text %></option> 
   <% } %>
   <% foreach (var i in Model.FilledClasses())
      { %>
   <option value="0" disabled="disabled"><%=i %> (filled)</option> 
   <% } %>
   </select>
   <%=Html.ValidationMessage("classid")%>