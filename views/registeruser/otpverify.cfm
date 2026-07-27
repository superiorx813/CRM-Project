<!DOCTYPE html>
<html>
<head>
    <title>OTP Verification</title>
    <link rel="stylesheet" href="../../css/otpverifystyle.css">
</head>

<body>

<div class="otp-container">

    <h2>OTP Verification</h2>

    <form action="finalregisterdb.cfm" method="POST">

        <label>Enter OTP</label>
        <input type="text" name="otp" required>

        <input type="submit" value="Verify OTP">

    </form>

    <div class="otp-note">
        <strong>OTP sent to your entered email</strong>
    </div>

</div>

</body>
</html>