<!DOCTYPE html>
<html>
<head>
    <title>Home Page</title>
    <link rel="stylesheet" href="/CRM/css/homestyle.css">
</head>
<body>


<!-- Page content -->
<div class="content">
   
    <div class="content">

    <cfoutput>

    <h1><span class="user-status"><strong>#data.message#</strong></span></h1>
    <h2>Hello!!! <span style="color:black">#session.username#</span></h2>
        <h2>Current Date & Time :
        <span style="color:black">#dateFormat(now(), "dd-mm-yyyy")#
        -
        <span style="color:black">#timeFormat(now(), "hh:mm:ss tt")#</span></h2>
        <!-- Application Status Widget -->
        <cfset uptime = now() - application.appStartTime>
    
    </cfoutput>

</div>

</div>

</body>
</html>
