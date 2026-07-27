<!-- Generate OTP -->
<cfset otp = RandRange(100000,999999)>

<!-- Store OTP -->
<cfset session.resetOTP = otp>

<!-- Send Mail -->
<cfmail
    to="#session.resetEmail#"
    from="yourmail@gmail.com"
    subject="Password Reset OTP"
    type="html">

    <h2>Password Reset OTP</h2>

    <p>Your OTP is:</p>

    <h1>#otp#</h1>

</cfmail>
<script src="/CRM/scripts/alert.js"></script>

<script>
    otpSentSuccess();
    window.location = "passwordverifyotp.cfm";
</script>