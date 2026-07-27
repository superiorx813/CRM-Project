<cfsetting showdebugoutput="false">
<!--- GET PDF VIEW COUNTS --->
<cfquery name="qPdfStats" datasource="mydb">

    SELECT
        username,
        report_type,
        COUNT(*) AS total_views

    FROM logs

    WHERE action_type = 'viewed_pdf'

    GROUP BY
        username,
        report_type

    ORDER BY
        username

</cfquery>

<!--- SEND EMAIL --->
<cfmail
    to="dharmakasani@gmail.com"
    from="superiorx813@gmail.com"
    subject="Daily PDF Usage Report"
    type="html">

<html>

<head>

<style>

table{
    border-collapse:collapse;
    width:100%;
}

th{
    background:blue;
    color:white;
    padding:10px;
    border:1px solid black;
}

td{
    padding:10px;
    border:1px solid black;
    text-align:center;
}

h2{
    color:blue;
}

</style>

</head>

<body>

<h2>Daily PDF Usage Report</h2>

<table>

    <tr>
        <th>Username</th>
        <th>Report Type</th>
        <th>Total Views</th>
    </tr>

    <cfloop query="qPdfStats">

        <tr>
            <td>#qPdfStats.username#</td>
            <td>#qPdfStats.report_type#</td>
            <td>#qPdfStats.total_views#</td>
        </tr>

    </cfloop>

</table>

</body>

</html>

</cfmail>

Mail processed successfully.