<%@ page
   import="java.util.*,
           org.jivesoftware.admin.*,
           org.jivesoftware.openfire.XMPPServer,
           org.jivesoftware.openfire.user.*,
           org.tttalk.openfire.plugin.RegistrationPlugin,
           org.jivesoftware.util.*"
   errorPage="error.jsp"%>

<%
    boolean savetranslator = request.getParameter("savetranslator") != null;
    String translator = ParamUtils.getParameter(request, "translator");
    String service = ParamUtils.getParameter(request, "service");
    String volunteer = ParamUtils.getParameter(request, "volunteer");

    RegistrationPlugin plugin = (RegistrationPlugin) XMPPServer.getInstance().getPluginManager().getPlugin("tttalk.registration");

    Map<String, String> errors = new HashMap<String, String>();
    
    if (savetranslator) {
    	errors = plugin.createGlobalProperties(translator, service, volunteer);
    }
    
    if (translator == null)
    	translator = plugin.getTranslator();
    if (service == null)
    	service = plugin.getService();
    if (volunteer == null)
    	volunteer = plugin.getVolunteer();

%>

<html>
    <head>
        <title>User Registration</title>
        <meta name="pageID" content="registration-props-form"/>
    </head>
    <body>

<form action="registration-props-form.jsp?savetranslator=true" method="post">
<div class="jive-contentBoxHeader">Translator</div>
<div class="jive-contentBox">
    <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tbody>
        <tr>
        	<td width="70px">Translator:</td>
            <td>
            <input type="text" name="translator" size="30" maxlength="100" value="<%= (translator != null ? translator : "") %>"/>
            <% if (errors.containsKey(RegistrationPlugin.TTTALK_USER_TRANSLATOR)) { %> 
            <span class="jive-error-text">userNotFound</span>
            <% } else if (savetranslator){ %>
            <span class="jive-success-text">saved</span>
            <% } %>
            </td>
        </tr>
        <tr>
        	<td>Service:</td>
            <td>
            <input type="text" name="service" size="30" maxlength="100" value="<%= (service != null ? service : "") %>"/>
            <% if (errors.containsKey(RegistrationPlugin.TTTALK_USER_SERVICE)) { %> 
            <span class="jive-error-text">userNotFound</span>
            <% } else if (savetranslator){ %>
            <span class="jive-success-text">saved</span>
            <% } %>
            </td>
        </tr>
        <tr>
        	<td>Volunteer:</td>
            <td>
            <input type="text" name="volunteer" size="30" maxlength="100" value="<%= (volunteer != null ? volunteer : "") %>"/>
            <% if (errors.containsKey(RegistrationPlugin.TTTALK_USER_VOLUNTEER)) { %> 
            <span class="jive-error-text">userNotFound</span>
            <% } else if (savetranslator){ %>
            <span class="jive-success-text">saved</span>
            <% } %>
            </td>
        </tr>
    </tbody>
    </table>
    
   <br>
    <input type="submit" value="Save"/>
    </div>
</form>

</body>
</html>
