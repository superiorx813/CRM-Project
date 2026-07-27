<!DOCTYPE html>
<html>

<head>

    <title>Update Request</title>

    <link rel="stylesheet" href="/CRM/css/updateformstyle.css">

</head>

<body>

<h2>Edit Details</h2>

<cfoutput query="data.getRequest">

<div class="form">

<form
    action="index.cfm?fuse=updatevalidation"
    method="post">

    <!-- HIDDEN ID -->
    <input
        type="hidden"
        name="request_id"
        value="#request_id#">

    <!-- TITLE -->
    <label>Title</label>

    <input
        type="text"
        name="Title"
        value="#Title#"
        required>

    <!-- DEPARTMENT -->
    <label>Department</label>

    <select name="Department" required>

        <option value="">-- Select Department --</option>

        <option value="HR"
            <cfif Department EQ "HR">selected</cfif>>

            HR

        </option>

        <option value="Finance"
            <cfif Department EQ "Finance">selected</cfif>>

            Finance

        </option>

        <option value="IT"
            <cfif Department EQ "IT">selected</cfif>>

            IT

        </option>

        <option value="Marketing"
            <cfif Department EQ "Marketing">selected</cfif>>

            Marketing

        </option>

    </select>

    <!-- DESCRIPTION -->
    <label>Description</label>

    <input
        type="text"
        name="Description"
        value="#Description#"
        required>

    <!-- SUBMIT -->
    <input
        type="submit"
        value="Update">

</form>

</div>

</cfoutput>

<br>

<a href="index.cfm?fuse=viewrequest">

    Back to List

</a>

</body>
</html>

