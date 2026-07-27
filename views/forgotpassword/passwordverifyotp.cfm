<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
    <link rel="stylesheet" href="../../css/submitformstyle.css">
</head>
<body>

    <div class="form">
        <h2>OTP Verification</h2>

        <form action="passwordotpvalidation.cfm" method="post">

            <label for="otp">Enter OTP:</label>
            <input type="text" id="otp" name="otp" required>

            <input type="submit" value="Verify OTP">

        </form>        
    </div>
    <a href="passwordforgot.cfm">Back to Forgot Password</a>
</body>
</html>
