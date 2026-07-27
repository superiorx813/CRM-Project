<cfparam name="logData.action_type" default="">
<cfparam name="logData.report_type" default="">
<cfparam name="logData.description" default="">
<!--- DATABASE LOG --->
<cfif structKeyExists(session, "username") AND len(trim(session.username))>

    <cfquery datasource="#application.datasource#">
        INSERT INTO logs (
            user_id,
            username,
            action_type,
            report_type,
            description
        )
        VALUES (
            <cfqueryparam value="#session.user_id#" cfsqltype="cf_sql_integer" null="#NOT structKeyExists(session,'user_id')#">,
            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#logData.action_type#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#logData.report_type#" cfsqltype="cf_sql_varchar" null="#NOT len(trim(logData.report_type))#">,
            <cfqueryparam value="#logData.description#" cfsqltype="cf_sql_varchar">)
    </cfquery>

</cfif>

<!--- TEXT LOG --->

<cfset logMessage = logData.description>

<cfset logFolder = expandPath("/CRM/logs")>

<cfif NOT directoryExists(logFolder)>
    <cfdirectory action="create" directory="#logFolder#">
</cfif>

<cfset logFile = logFolder & "/log_" & dateFormat(now(),"yyyy-mm-dd") & ".txt">

<cfset userIP = CGI.REMOTE_ADDR>

<cfset logText = "
==================================================
DateTime : #dateTimeFormat(now(),'yyyy-mm-dd HH:nn:ss')#
Username : #session.username#
IP       : #userIP#
Action   : #logMessage#
==================================================

">

<cffile action="append"
    file="#logFile#"
    output="#logText#"
    addnewline="yes">