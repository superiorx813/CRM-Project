<!DOCTYPE html>
<html>
<head>
    <title>Stats Page</title>
    <link rel="stylesheet" href="/CRM/css/stats.css">
</head>
<body>

<cfoutput>
    <!-- Application Status Widget -->
    <cfif structKeyExists(application, "appStartTime")>
        <cfset uptime = now() - application.appStartTime>
        <cfset days = int(uptime)>
        <cfset hours = int((uptime - days) * 24)>
        <div class="app-status-widget">
            <h3>📊 Application Status</h3>
             <p>
            <strong>Started:</strong>
            #dateFormat(application.appStartTime, "mmmm dd, yyyy")#
            #timeFormat(application.appStartTime, "hh:mm:ss tt")#
        </p>

        <p>
            <strong>Uptime:</strong>
            #days# day(s), #hours# hour(s)
        </p>
        </div>
    </cfif>

    <!-- Active Users Count Widget -->
    <cfif structKeyExists(application, "allSessions")>
        <div class="active-users-widget">
            <h3>👥 Active Users
                <span class="online-dot"></span>
            </h3>
            <p><strong>Currently Active:</strong> #arrayLen(application.allSessions)# users</p>
        </div>
    </cfif>

    <!-- Current User Session Widget -->
    <cfif structKeyExists(session, "sessionStartTime")>
        <div class="session-status-widget">
            <h3>👤 Your Session Status</h3>
            <p><strong>User ID:</strong> #session.user_id#</p>
            <p><strong>Username:</strong> #session.username#</p>
            <p><strong>Session Started:</strong> #dateFormat(session.sessionStartTime, "mmmm dd, yyyy")# 
            #timeFormat(session.sessionStartTime, "hh:mm:ss tt")#</p>
            <p><strong>Last Activity:</strong> #dateFormat(session.lastActivity, "mmmm dd, yyyy")# 
            #timeFormat(session.lastActivity, "hh:mm:ss tt")#</p>
        </div>
    </cfif>

    <!-- All User Sessions Widget -->
    <cfif structKeyExists(application, "allSessions") AND arrayLen(application.allSessions)>
        <div class="all-sessions-widget">
            <h3>📋 All User Sessions</h3>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Session Started</th>
                    <th>Last Activity</th>
                </tr>
                <cfloop array="#application.allSessions#" index="s">
                    <tr>
                        <td>#s.user_id#</td>
                        <td>#s.username#</td>
                        <td>#dateFormat(s.sessionStartTime, "mmmm dd, yyyy")# 
                            #timeFormat(s.sessionStartTime, "hh:mm:ss tt")#</td>
                        <td>#dateFormat(s.lastActivity, "mmmm dd, yyyy")# 
                            #timeFormat(s.lastActivity, "hh:mm:ss tt")#</td>
                    </tr>
                </cfloop>
            </table>
        </div>
    </cfif>
</cfoutput>

<br>
<div class="bottom-section">
    <cfinclude template="/CRM/includes/homebutton.cfm">
</div>

</body>
</html>
