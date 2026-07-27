<cfparam name="form.username" default="">

<cfquery name="getUser" datasource="#application.datasource#">
    SELECT username, mail_id AS email
    FROM users
    WHERE username = <cfqueryparam
                        value="#form.username#"
                        cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getUser.recordCount EQ 0>

     <script src="/CRM/scripts/alert.js"></script>

    <script>
        usernameNotFound();
        window.location = "forgotpassword.cfm";
    </script>

<cfelse>

    <!-- Store Username -->
    <cfset session.resetUsername = getUser.username>
    <cfset session.resetEmail = getUser.email>

    <!-- Mask Email -->
    <cfset emailParts = listToArray(getUser.email, "@")>
    <cfset firstPart = left(emailParts[1],2)>
    <cfset maskedEmail = firstPart & "******@" & emailParts[2]>

</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>Email Verification</title>
    <link rel="stylesheet" href="../../css/submitformstyle.css">
</head>
<body>

    <div class="form">
        <h2>Email Verification</h2>

        <p>
            Registered Email:  
            <b><cfoutput>#maskedEmail#</cfoutput></b>
        </p>

        <form action="passwordsendotp.cfm" method="post">
            <input type="submit" value="Send OTP">
        </form>        
    </div>
    <a href="../loginform.cfm">Back to Login</a>
</body>
</html>
