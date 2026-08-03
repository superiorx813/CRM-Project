<cfif form.otp EQ session.otp>

    <cfquery datasource="#application.datasource#">
        INSERT INTO users(username,password,mail_id)
        VALUES(
            <cfqueryparam value="#session.temp_username#" cfsqltype="cf_sql_varchar">,

            <cfqueryparam value="#session.temp_password#" cfsqltype="cf_sql_varchar">,

            <cfqueryparam value="#session.temp_email#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>
     <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "new user",
        description = "#session.temp_username# registered for application"
    }>

    <!-- ================= INCLUDE LOGGER ================= -->
    <cfinclude template="/CRM/views/logfile.cfm">

    <cfset structClear(session)>

    <cflocation
        url="/CRM/views/loginform.cfm?status=registered"
        addtoken="false">

<cfelse>

    <script src="/CRM/scripts/alert.js"></script>

    <script>
        invalidOtp();
        window.location.href = "otpverify.cfm";
    </script>

</cfif>