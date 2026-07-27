<!DOCTYPE html>
<html>
<head>
    <title>Register Page</title>
    <link rel="stylesheet" href="/CRM/css/registerformstyle.css">


</head>

<body>

<div class="form">

<form action="registervalidation.cfm" method="POST">

    <h2>Register</h2>

    <label>Username</label><br>
    <input type="text" name="username" required><br><br>
    <label>Email</label><br>
    <input type="email" name="email" required><br><br>

    <label>Password</label><br>
    <input type="password" name="password" required><br><br>

    <label>Confirm Password</label><br>
    <input type="password" name="confirmpassword" required><br><br>

    <input type="submit" value="Send OTP">

</form>

</div>
</body>
</html>