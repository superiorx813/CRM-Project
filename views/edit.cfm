<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <link rel="stylesheet" href="/CRM/css/editstyle.css">
</head>

<body>

<div class="card">

    <h2>Edit Profile</h2>

    <cfoutput>

    <form action="index.cfm?fuse=editvalidation"
          method="post"
          enctype="multipart/form-data">

       
        <label>Name</label>
        <input type="text" name="name" value="#data.user.name#" required>


        <label>Role</label>
        <input type="text" name="role" value="#data.user.role#" required>

        <label>Description</label>
        <textarea name="description" required>#data.user.description#</textarea>

        <label>Profile Image</label>
        <input type="file" name="profilePic">

        <br><br>

        <button type="submit">Update</button>

    </form>

    </cfoutput>

</div>

</body>
</html>