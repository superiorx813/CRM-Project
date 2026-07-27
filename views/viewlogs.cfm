<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Activity Logs</title>

    <link rel="stylesheet" href="/CRM/css/viewlogs.css">
    <link rel="stylesheet" href="/CRM/css/pagination.css">

</head>

<body>

<div class="container">

    <h2>Activity Logs</h2>

    <!-- TABLE -->
    <table id="Table">

        <thead>
            <tr>
                <th>Log ID</th>
                <th>User ID</th>
                <th>Username</th>
                <th>Action</th>
                <th>Description</th>
                <th>Created At</th>
            </tr>
        </thead>

        <tbody>

<cfif structKeyExists(data, "logs") AND data.logs.recordCount GT 0>

    <cfoutput query="data.logs">
        <tr>
            <td>#log_id#</td>
            <td>#user_id#</td>
            <td>#username#</td>
            <td>#action_type#</td>
            <td>#description#</td>
            <td>#created_at#</td>
        </tr>
    </cfoutput>

<cfelse>

    <tr>
        <td colspan="6" style="text-align:center;">
            No logs found
        </td>
    </tr>

</cfif>

</tbody>

    </table>

    <!-- PAGINATION -->
    <div class="pagination" id="pagination"></div>

</div>

<!-- HOME BUTTON -->
<div class="home-button">
    <cfinclude template="/CRM/includes/homebutton.cfm">
</div>

<!-- JS PAGINATION -->
<script src="/CRM/scripts/pagination.js"></script>

</body>
</html>