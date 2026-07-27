
<!-- PROFILE IMAGE PATH -->
<cfif structKeyExists(data, "user") AND len(trim(data.user.profile_image))>
    <cfset profilePic = "/CRM/" & data.user.profile_image>
<cfelse>
    <cfset profilePic = "/CRM/images/uploads/default.png">
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>Profile</title>

    <link rel="stylesheet" href="/CRM/css/profilestyle.css">

    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

<div class="card">

    <!-- TOP -->
    <div class="top-section">
        <img src="<cfoutput>#profilePic#</cfoutput>" alt="Profile Image">
    </div>

    <!-- CONTENT -->
    <div class="content">

        <h2>
            <cfoutput>
                Name: #data.user.name#
            </cfoutput>
        </h2>

        <h3>
            <cfoutput>
                Role: #data.user.role#
            </cfoutput>
        </h3>

        <div class="line"></div>

        <p>
            <cfoutput>
                Description: #data.user.description#
            </cfoutput>
        </p>

        <!-- SOCIAL -->
        <div class="social-icons">
            <a href="#"><i class="fa-brands fa-instagram"></i></a>
            <a href="#"><i class="fa-brands fa-twitter"></i></a>
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
        </div>

        <!-- ACTIONS -->
        <a href="index.cfm?fuse=edit" class="edit-btn">Edit Profile</a>

        <a href="index.cfm?fuse=deleteprofile"
           class="delete-btn"
           onclick="return confirm('Delete profile picture?')">
            Delete Profile Picture
        </a>

    </div>

    <!-- HOME -->
    <div class="bottom-section">
        <cfinclude template="/CRM/includes/homebutton.cfm">
    </div>

</div>

</body>
</html>