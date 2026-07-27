<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="../../css/passwordreset.css">
</head>
<body>

    <div class="form">
        <h2>Reset Password</h2>

        <form action="passwordupdatedb.cfm" method="post">

            <label for="newpassword">New Password:</label>
            <input type="password" id="newpassword" name="newpassword" required>

            <label for="confirmpassword">Confirm Password:</label>
            <input type="password" id="confirmpassword" name="confirmpassword" required>

            <input type="submit" value="Update Password">

        </form>

        
    </div>
    <a href="passwordforgot.cfm">Back to Forgot Password</a>
</body>
</html>
