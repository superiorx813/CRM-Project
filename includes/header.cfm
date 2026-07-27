<link rel="stylesheet" type="text/css" href="/CRM/css/header.css">

<!-- Navbar -->
<div class="navbar">

    <div class="nav-left">
        <button id="menuBtn" onclick="toggleSidebar()">
            ☰ Menu
        </button>
    </div>

    <div class="nav-center">
        <span class="lin">
            Logged in as |
            <strong>
                <cfoutput>#session.username#</cfoutput>
            </strong>
        </span>
    </div>

    <div class="nav-right">
        <button
    type="button"
    class="logout-btn"
    onclick="window.location.href='index.cfm?fuse=logout';">
    Logout
</button>
    </div>

</div>

<!-- Sidebar -->
<div id="mySidebar" class="sidebar">

    <a href="index.cfm?fuse=profile">
        Go to My Profile
    </a>

    <a href="index.cfm?fuse=submitform">
        Submit Request
    </a>

    <a href="index.cfm?fuse=viewrequest">
        View Requests
    </a>

    <cfif structKeyExists(session, "username")
        AND session.username EQ "admin">

        <a href="index.cfm?fuse=viewlogs">
            View Logs
        </a>

        <a href="index.cfm?fuse=customers">
            Customer Management
        </a>

        <a href="index.cfm?fuse=usersregisterlist">
            Register Users
        </a>

        <a href="index.cfm?fuse=stats">
            Application & User Stats
        </a>

    </cfif>

</div>

<script>
function toggleSidebar() {

    let sidebar = document.getElementById("mySidebar");

    if (sidebar.style.width === "250px") {
        sidebar.style.width = "0";
    } else {
        sidebar.style.width = "250px";
    }

}
</script>