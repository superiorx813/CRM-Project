
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="../../css/submitformstyle.css">
</head>
<body>

    <div class="form">
        <h2>Forgot Password</h2>

        <form action="passworduservalidation.cfm" method="post">

            <label for="username">Enter Username:</label>
            <input type="text" id="username" name="username" required>

            <input type="submit" value="Next">

        </form>
    </div>
    
        <a href="../loginform.cfm">Back to Login</a>
</body>
</html>
