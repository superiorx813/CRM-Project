<!-- PREVENT CACHE -->
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0">
<!DOCTYPE html>
<html>

<head>
<title>Login Page</title>
<link rel="stylesheet" type="text/css" href="../css/loginformstyle.css">
</head>

<body>
    <script src="/CRM/scripts/alert.js"></script>

<cfif structKeyExists(url, "status")
      AND url.status EQ "registered">

    <script>
        registrationSuccess();
    </script>

</cfif>

<div class="form">

    <h2>Login</h2>

    <form action="loginvalidation.cfm" method="post" name="loginForm" id="loginForm">

        <label>Username:</label>

        <input type="text" name="username" id="username" placeholder="Enter Username" required>

        <label>Password:</label>

        <input type="password" name="password" id="password" placeholder="Enter Password" required>

        <input type="submit" value="Login">

    </form>

    <div class="text">
        Don’t have an account?
    </div>

    <form action="registeruser/registerform.cfm">

        <input type="submit" value="Register here" class="registerBtn">

    </form>

    <div class="forgot">

        <a href="forgotpassword/Passwordforgot.cfm">Forgot Password?</a>

    </div>

</div>
  

</body>
</html>