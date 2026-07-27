<html>
<body>

<h1>VALIDATION PAGE LOADED</h1>

<cfsetting showdebugoutput="no">

<!-- CHECK IF FORM VARIABLES EXIST -->
<cfif NOT isDefined("form.username") OR NOT isDefined("form.password")>

    Form variables not found - redirecting<br>

    <cflocation url="loginform.cfm" addtoken="no">

<cfelse>

    Form received: Username = #form.username#, Password = [hidden]<br>

</cfif>

<cftry>

    <!-- CHECK USER LOGIN -->
    <cfquery name="checkUser" datasource="#application.datasource#" result="queryResult">
        SELECT user_id, username
        FROM users
        WHERE username = 
            <cfqueryparam 
                value="#form.username#" 
                cfsqltype="cf_sql_varchar">

        AND password = 
            <cfqueryparam 
                value="#hash(form.password,'SHA-256')#" 
                cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- LOGIN SUCCESS -->
    <cfif checkUser.recordCount GT 0>

        <!-- SESSION VARIABLES -->
        <cfset session.isLoggedIn = true>
        <cfset session.user_id = checkUser.user_id[1]>
        <cfset session.username = checkUser.username[1]>

    <!-- Update global session list -->
    <cflock scope="application" type="exclusive" timeout="5">
        <cfif NOT structKeyExists(application, "allSessions")>
            <cfset application.allSessions = []>
        </cfif>

        <!-- Try to find this session in the list -->
        <cfset found = false>
        <cfloop from="1" to="#arrayLen(application.allSessions)#" index="i">
            <cfif application.allSessions[i].sessionStartTime EQ session.sessionStartTime>
                <cfset application.allSessions[i].user_id = session.user_id>
                <cfset application.allSessions[i].username = session.username>
                <cfset application.allSessions[i].lastActivity = session.lastActivity>
                <cfset found = true>
            </cfif>
        </cfloop>

        <!-- If not found, append new -->
        <cfif NOT found>
            <cfset arrayAppend(application.allSessions, {
                user_id = session.user_id,
                username = session.username,
                sessionStartTime = session.sessionStartTime,
                lastActivity = session.lastActivity
            })>
        </cfif>
    </cflock>

    <!-- LOG login VISIT -->
    <cfset logData = {
        action_type = "LOGIN",
        description = "User : #session.username# logged in successfully"
    }>
    <cfset logMessage = logData.description>
    <cfinclude template="logfile.cfm">

    <!-- REDIRECT TO HOME -->
    <cflocation url="../index.cfm" addtoken="no">

    <!-- LOGIN FAILED -->
    <cfelse>

        <cfoutput>

            <!DOCTYPE html>

            <html>

            <head>

                <title>Login Failed</title>

                <link 
                    rel="stylesheet" 
                    type="text/css" 
                    href="../css/loginformstyle.css">

            </head>

            <body>

                <div class="form">

                    <h2 style="color:red; text-align:center;">
                        Incorrect Username or Password
                    </h2>

                    <p style="text-align:center; margin-top:20px;">

                        <a href="loginform.cfm">
                            ← Go back to Login
                        </a>

                    </p>

                </div>

            </body>

            </html>

        </cfoutput>

    </cfif>

    <!-- ERROR HANDLING -->
    <cfcatch type="any">

        <cfoutput>

            Error: #cfcatch.message#<br>
            Detail: #cfcatch.detail#

        </cfoutput>

    </cfcatch>

</cftry>

</body>
</html>