<!DOCTYPE html>
<html>

<head>
    <title>Submission Form</title>
   <!-- <link rel="stylesheet" href="../css/submitformstyle.css"> -->
    <link rel="stylesheet" href="/CRM/css/submitformstyle.css">
</head>

<body>

    <div class="form">

        <h2>Submit Request Form</h2>

        <form action="index.cfm?fuse=submitvalidation" method="post">
            <label>Title</label>
            <input type="text" name="Title" required>

            <label>Department</label>

            <select name="Department" required>
                <option value="">-- Select Department --</option>
                <option value="HR">HR</option>
                <option value="Finance">Finance</option>
                <option value="IT">IT</option>
                <option value="Marketing">Marketing</option>
            </select>

            <label>Description</label>
            <input type="text" name="Description" required>

            <input type="submit" value="Submit">

        </form>

    </div>

    <br>

<cfinclude template="/CRM/includes/homebutton.cfm">
</body>

</html>