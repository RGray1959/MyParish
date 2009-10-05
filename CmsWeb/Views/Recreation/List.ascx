<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<CMSWeb.Models.RecreationModel>" %>
<% IEnumerable<CMSWeb.Models.ParticipantInfo> participants;
   if ((Model.LeagueId ?? 0) == 0)
       participants = Model.FetchParticipants0();
   else
       participants = Model.FetchParticipants();
    %>
<% foreach (var r in participants)
   { %>
<tr>
    <td><input name="selected" type="checkbox" <%=r.Checked %> value="<%=r.PeopleId%>" class="check" /></td>
    <td><a href="/Person.aspx?id=<%=r.PeopleId %>"><%=r.Name%></a></td>
    <td><%=r.MemberType %></td>
    <td><%=r.MemberStatus %></td>
    <td><%=r.TeamName%></td>
    <td><%=r.Birthday%></td>
    <td><%=r.ShirtSize%></td>
    <td><%=r.FeePaid%></td>
    <td><%=r.Request%></td>
    <% if (r.Id != null)
       { %>
    <td><a href="/Recreation/Detail/<%=r.Id%>"><%=r.Uploaded.Value.ToString("M/d H:mm") %></a></td>
    <% }
       else
       { %>
    <td><a href="#" class="createdetail" pid="<%=r.PeopleId %>" oid="<%=r.OrgId %>">create</a></td>
    <% } %>
</tr>
<% } %>
