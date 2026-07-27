<cfoutput>
<!-- <cfdump var="#form#"> -->

<cfif NOT structKeyExists(form,"username") 
    OR NOT structKeyExists(form,"email") 
    OR NOT structKeyExists(form,"password") 
    OR NOT structKeyExists(form,"confirmpassword")>

   <script src="/CRM/scripts/alert.js"></script>

<script>
    formNotSubmitted();
    window.location.href = "registerform.cfm";
</script>
<cfelse>

    <cfif form.password NEQ form.confirmpassword>

        <script src="/CRM/scripts/alert.js"></script>

    <script>
    passwordMismatch();
    window.location.href = "registerform.cfm";
    </script>

    <cfelse>

        <cfset otp = randRange(100000,999999)>

        <cfset session.temp_username = form.username>
        <cfset session.temp_email = form.email>
        <cfset session.temp_password = hash(form.password, "SHA-256")>
        <cfset session.otp = otp>

        <cfmail to="#form.email#"
                from="superiorx813@gmail.com"
                subject="OTP Verification"
                type="html">

            <h3>Your OTP Code</h3>
            <h2>#otp#</h2>

        </cfmail>

        <cflocation url="otpverify.cfm" addtoken="false">

    </cfif>

</cfif>

</cfoutput>