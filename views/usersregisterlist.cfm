<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>User Registration List</title>

    <!-- CSS FILE -->
    <link rel="stylesheet" href="/CRM/css/usersregisterlist.css">
</head>

<body>

    <!-- MAIN CONTAINER -->
    <div class="container">

        <h1>User Registration List</h1>

        <!-- TABLE -->
        <div class="table-box">

            <table id="Table">

                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>

                    <!-- CHECK DATA EXISTS -->
                    <cfif structKeyExists(data, "users") AND data.users.recordCount GT 0>

                        <cfoutput query="data.users">

                            <tr>
                                <td>#user_id#</td>
                                <td>#username#</td>
                                <td>#mail#</td>
                                <td>

                                    <!-- STATUS CHECK -->
                                    <cfif lcase(username) EQ "admin">

                                        <span class="admin">Admin</span>

                                    <cfelse>

                                        <span class="user">General User</span>

                                    </cfif>

                                </td>
                            </tr>

                        </cfoutput>

                    <cfelse>

                        <tr>
                            <td colspan="4" style="text-align:center;">
                                No users found
                            </td>
                        </tr>

                    </cfif>

                </tbody>

            </table>

        </div>

    </div>

    <!-- PAGINATION  -->
    <div class="pagination" id="pagination"></div>

    <!-- HOME BUTTON -->
    <cfinclude template="/CRM/includes/homebutton.cfm">

    <script src="/CRM/scripts/pagination.js"></script>

</body>

</html>