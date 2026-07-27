
<cfheader
    name="Content-Disposition"
    value="inline; filename=Request_Report.pdf">

<cfcontent type="application/pdf">

<cfdocument format="PDF">

<html>

<head>

    <link
        rel="stylesheet"
        href="/CRM/css/downloadreport.css">

</head>

<body>

    <div class="report-container">

        <h2>Requests PDF Report</h2>

        <table>

            <tr>

                <th>ID</th>

                <th>Title</th>

                <th>Department</th>

                <th>Description</th>

            </tr>

            <cfoutput query="data.getRequests">

                <tr>

                    <td>#user_request_id#</td>

                    <td>#Title#</td>

                    <td>#Department#</td>

                    <td>#Description#</td>

                </tr>

            </cfoutput>

        </table>

    </div>

</body>

</html>

</cfdocument>

