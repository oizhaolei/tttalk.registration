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

    RegistrationPlugin plugin = (RegistrationPlugin) XMPPServer.getInstance().getPluginManager().getPlugin("tttalk.registration");

    Map<String, String> errors = new HashMap<String, String>();
    
    if (savetranslator) {
        if (translator == null || translator.trim().length() < 1) {
            errors.put("userNotFound", "userNotFound");
        }
        
        try {
            XMPPServer.getInstance().getUserManager().getUser(translator);
        }
        catch (Exception e) {
            errors.put("userNotFound", "userNotFound");
        }
        
        if (errors.size() == 0) {
            plugin.setTranslator(translator);
            response.sendRedirect("registration-props-form.jsp?translatorSaved=true");
            return;
        }
    }
    
    translator = plugin.getTranslator();
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
   
    <% if (ParamUtils.getBooleanParameter(request, "translatorSaved")) { %>

    <div class="jive-success">
    <table cellpadding="0" cellspacing="0" border="0">
    <tbody>
        <tr>
            <td class="jive-icon"><img src="images/success-16x16.gif" width="16" height="16" border="0"></td>
            <td class="jive-icon-label">Translator saved.</td>
        </tr>
    </tbody>
    </table>
    </div>
   
    <% } %>

    <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tbody>
        <tr>
            <td><input type="text" name="translator" size="30" maxlength="100" value="<%= (translator != null ? translator : "") %>"/>
            <% if (errors.containsKey("userNotFound")) { %> 
            <span class="jive-error-text"><br>userNotFound</span>
            <% } %>
        </tr>
    </tbody>
    </table>
    
   <br>
    <input type="submit" value="Save"/>
    </div>
</form>

</body>
</html>
