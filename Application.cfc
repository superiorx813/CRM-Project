<cfcomponent displayname="CRM Application" hint="Application settings and request security for the CRM">

    <!--- Application configuration --->
    <cfset this.name = "CRMApplication">
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>
    <cfset this.applicationTimeout = createTimeSpan(30,0,0,0)>
    <!---<cfset this.datasource = "mydb">--->
    <cfset this.setClientCookies = true>
    <cfset this.setDomainCookies = false>
    <cfset this.scriptProtect = "all">

    <cffunction name="onApplicationStart" returntype="boolean" output="false">
    <cfset application.datasource = "mydb">
    <cfset application.controller = new controller() >
    <cfset application.appStartTime = now()>
    <cfset application.allSessions = []>
    <cfreturn true>
    </cffunction>

    <cffunction name="onSessionStart" returntype="void" output="false">
        <cfset session.isLoggedIn = false>
        <cfset session.user_id = 0>
        <cfset session.username = "">
        <cfset session.loginAttempts = 0>
        <cfset session.sessionStartTime = now()>
        <cfset session.lastActivity = now()>        
    </cffunction>

    <cffunction name="onRequestStart" returntype="boolean" output="false">
    <cfargument name="targetPage" type="string" required="true">
    <!--- allow access to public pages without session --->
    <!--- Allow ColdFusion Scheduled Tasks --->
    <cfif CGI.HTTP_USER_AGENT EQ "CFSCHEDULE">
        <cfreturn true>
    </cfif>

    <cfif structKeyExists(url, "init")>
       <cfset onApplicationStart()>
       <cfoutput>Application initialized</cfoutput>
       <cfabort>
    </cfif>

    <cfset var currentPage = listLast(arguments.targetPage, "/\")>
    <cfset var publicPages = "loginform.cfm,loginvalidation.cfm,registerform.cfm,registervalidation.cfm,otpverify.cfm,finalregisterdb.cfm,passwordforgot.cfm,passworduservalidation.cfm,passwordsendotp.cfm,passwordverifyotp.cfm,passwordotpvalidation.cfm,passwordreset.cfm,passwordupdatedb.cfm">

    <!--- Detect API / AJAX calls --->
    <cfset var isAPI = findNoCase(".cfc", arguments.targetPage) OR findNoCase("components", arguments.targetPage)>
    <cfset session.lastActivity = now()>
    <!--- Prevent caching --->
    <cfheader name="Cache-Control" value="no-store, no-cache, must-revalidate, max-age=0">
    <cfheader name="Expires" value="Thu, 01 Jan 1970 00:00:00 GMT">
    <cfheader name="X-Content-Type-Options" value="nosniff">
    <cfheader name="X-Frame-Options" value="SAMEORIGIN">

    <!--- SESSION CHECK ONLY FOR NORMAL PAGES (NOT AJAX) --->
    <cfif NOT isAPI AND NOT listFindNoCase(publicPages, currentPage)
        AND (NOT structKeyExists(session, "user_id") OR session.user_id EQ 0)>
        <cflocation url="/CRM/Views/loginform.cfm" addtoken="false">
        <cfreturn false>
    </cfif>

    <cfreturn true>
    </cffunction>
       
    <cffunction name="onMissingTemplate" returntype="boolean" output="true">
        <cfargument name="targetPage" type="string" required="true">
        <cflog file="application" type="warning" text="Missing template: #arguments.targetPage#">
        <cfheader statuscode="404">
        <cfcontent type="text/html" reset="true">
        <cfoutput>
            <!DOCTYPE html>
            <html>
            <head>
                <title>Page Not Found</title>
                <link rel="stylesheet" href="css/onmissingtemplate.css">
            </head>
            <body>
                <div class="error-box">
                    <h1>Page Not Found</h1>
                    <p>The requested page does not exist.</p>
                    <p><a href="/CRM/Views/loginform.cfm">Go to login</a></p>
                </div>
            </body>
            </html>
        </cfoutput>

        <cfreturn true>
    </cffunction>   

    <cffunction name="onError" returntype="void" output="true">
    <cfargument name="exception" required="true">
    <cfargument name="eventName" required="false" default="">
    <!-- Log the error -->
    <cflog
        file="application"
        type="error"
        text="
        Event: #arguments.eventName#
        Message: #arguments.exception.message#
        Detail: #arguments.exception.detail#
        ">
    <!-- Return HTTP 500 -->
    <cfheader statuscode="500">
    <!-- Clear previous output -->
    <cfcontent reset="true">
    <cfoutput>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Application Error</title>
        <link rel="stylesheet" href="/CRM/css/onerror1.css">
    </head>
    <body>
        <div class="error-box">
            <h1>Application Error</h1>
            <p>
                An unexpected error occurred while processing your request.
            </p>
            <hr>
            <h3>Error Details</h3>
            <p>
                <strong>Event :</strong>
                #encodeForHTML(arguments.eventName)#
            </p>
            <p>
                <strong>Message :</strong>
                #encodeForHTML(arguments.exception.message)#
            </p>
            <p>
                <strong>Detail :</strong>
                #encodeForHTML(arguments.exception.detail)#
            </p>
            <cfif structKeyExists(arguments.exception, "type")>
                <p>
                    <strong>Type :</strong>
                    #encodeForHTML(arguments.exception.type)#
                </p>
            </cfif>
            <cfif structKeyExists(arguments.exception, "template")>
                <p>
                    <strong>Template :</strong>
                    #encodeForHTML(arguments.exception.template)#
                </p>
            </cfif>
            <cfif structKeyExists(arguments.exception, "line")>
                <p>
                    <strong>Line :</strong>
                    #arguments.exception.line#
                </p>
            </cfif>
            <br>
            <a href="/CRM/Views/loginform.cfm">
                Go to Login
            </a>
        </div>
    </body>
    </html>
    </cfoutput>
</cffunction>
    
<cffunction name="onSessionEnd" returntype="void" output="false">
    <cfargument name="sessionScope" required="true">
    <cfargument name="appScope" required="true">

    <!-- Remove expired session from global list -->
    <cflock scope="application" type="exclusive" timeout="5">
        <cfif structKeyExists(appScope, "allSessions")>
            <cfloop from="1" to="#arrayLen(appScope.allSessions)#" index="i">
                <cfif appScope.allSessions[i].sessionStartTime EQ arguments.sessionScope.sessionStartTime>
                    <cfset arrayDeleteAt(appScope.allSessions, i)>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
    </cflock>

    <!-- Log session expiry -->
    <cflog
        file="application"
        type="information"
        text="Session expired for user: #arguments.sessionScope.username#">
</cffunction>

<cffunction name="onRequestEnd" returntype="void" output="false">

    <!-- CHECK USER LOGIN -->
    <cfif structKeyExists(session, "username")
        AND len(trim(session.username))>

        <!-- UPDATE LAST ACTIVITY -->
        <cfset session.lastActivity = now()>

        <!-- Update global session list -->
        <cflock scope="application" type="exclusive" timeout="5">
            <cfif structKeyExists(application, "allSessions")>
                <cfloop from="1" to="#arrayLen(application.allSessions)#" index="i">
                    <cfif application.allSessions[i].sessionStartTime EQ session.sessionStartTime>
                        <cfset application.allSessions[i].lastActivity = session.lastActivity>
                        <cfbreak>
                    </cfif>
                </cfloop>
            </cfif>
        </cflock>

        <!-- LOG PAGE VISIT -->
        <cflog
            file="application"
            type="information"
            text="Page request completed by user: #session.username#">

    </cfif>

</cffunction>

</cfcomponent>
