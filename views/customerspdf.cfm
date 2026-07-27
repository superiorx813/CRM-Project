<!-- ================= LOG DATA ================= -->

<cfset logData = {

    action_type = "viewed_pdf",

    report_type = "customers",

    description = "#session.username# viewed pdf for customers with search term: #url.search#"

}>

<cfinclude template="logfile.cfm">

<cfsetting showdebugoutput="false">

<cfparam name="url.search" default="">

<cfheader
    name="Content-Disposition"
    value="inline; filename=Customer_Report.pdf">

<cfcontent type="application/pdf">

<cfdocument
    format="PDF"
    orientation="portrait"
    margintop="0.5"
    marginbottom="0.5"
    marginleft="0.5"
    marginright="0.5">

<html>

<head>

    <link rel="stylesheet"
          href="/CRM/css/downloadreport.css">

</head>

<body>

<h1>Customer Report</h1>

<p>
    Search:
    <cfoutput>#encodeForHTML(url.search)#</cfoutput>
</p>

<table>

    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
    </tr>

    <cfif structKeyExists(data,"customers")
        AND data.customers.recordCount GT 0>

        <cfloop query="data.customers">

            <cfoutput>
                <tr>
                    <td>#id#</td>
                    <td>#username#</td>
                    <td>#name#</td>
                    <td>#email#</td>
                    <td>#phone#</td>
                </tr>
            </cfoutput>

        </cfloop>

    <cfelse>

        <tr>
            <td colspan="5" align="center">
                No customers found
            </td>
        </tr>

    </cfif>

</table>

</body>

</html>

</cfdocument>