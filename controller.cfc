<cfcomponent output="false">
    <!-- HOME -->
    <cffunction name="home" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.title = "CRM Home Page">
        <cfset data.message = "Welcome to CRM Home">
        <cfreturn data>
    </cffunction>

 <!-- PROFILE -->
<cffunction name="profile" access="public" returntype="struct" output="false">
    <cfset var data = {}>
    <cfset data.title = "User Profile">
    <!-- GET USER FROM DB -->
    <cfquery name="data.user" datasource="#application.datasource#">
        SELECT name, role, description, profile_image
        FROM users
        WHERE username = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
    action_type = "viewed_profile",
    description = "#session.username# viewed their profile"
}>
   <cfinclude template="views/logfile.cfm">
    <cfreturn data>
</cffunction>

  <!-- ================= EDIT PAGE ================= -->
<cffunction name="edit" access="public" returntype="struct" output="true">

    <cfset var data = {}>
    <!-- GET USER -->
    <cfquery name="getUser" datasource="#application.datasource#">
        SELECT  name, role, description, profile_image
        FROM users
        WHERE username =
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- CHECK USER EXISTS -->
    <cfif getUser.recordCount EQ 0>
        <cfoutput>
            <h3 style="color:red;text-align:center;">
                User not found
            </h3>
        </cfoutput>
        <cfabort>
    </cfif>

    <!-- QUERY TO STRUCT -->
    <cfset data.user = {
        name = getUser.name[1],
        role = getUser.role[1],
        description = getUser.description[1],
        profile_image = getUser.profile_image[1]
    }>
    <cfset data.title = "Edit Profile">
    <cfreturn data>

</cffunction>
<!-- ================= EDIT VALIDATION ================= -->
<cffunction name="editvalidation" access="public" returntype="void" output="true">
    <!-- SESSION CHECK -->
    <cfset var username = session.username>
    <!-- FORM VALIDATION -->
    <cfparam name="form.name" default="">
    <cfparam name="form.role" default="">
    <cfparam name="form.description" default="">
    <cfif NOT len(trim(form.name)) OR NOT len(trim(form.role)) OR NOT len(trim(form.description))>
        <cfoutput>
            <h3 style="color:red;text-align:center;">All fields required</h3>
        </cfoutput>
        <cfabort>
    </cfif>

    <!-- GET OLD IMAGE -->
    <cfquery name="getOldImage" datasource="#application.datasource#">
        SELECT profile_image
        FROM users
        WHERE username =
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfset var imagePath = getOldImage.profile_image>

 <!--upload image-->
 <cfif len(trim(form.profilePic))>
    <cfset var uploadPath = expandPath("./images/uploads")>

    <!-- CREATE FOLDER IF NOT EXISTS -->
    <cfif NOT directoryExists(uploadPath)>
        <cfdirectory action="create" directory="#uploadPath#">
    </cfif>

    <!-- UPLOAD FILE -->
    <cffile action="upload"
            filefield="profilePic"
            destination="#uploadPath#"
            nameconflict="makeunique"
            result="fileResult">

    <!-- ALLOWED EXTENSIONS -->
    <cfset allowedExtensions = "jpg,jpeg,png">
    <!-- VALIDATE TYPE -->
    <cfif NOT listFindNoCase(allowedExtensions, fileResult.serverFileExt)>
        <cffile action="delete"
                file="#fileResult.serverDirectory#/#fileResult.serverFile#">
        <cfoutput>
            <h3 style="color:red;text-align:center;">
                Only JPG, JPEG, PNG allowed
            </h3>
        </cfoutput>
        <cfabort>
    </cfif>

    <!-- FULL FILE PATH -->
    <cfset uploadedFile = fileResult.serverDirectory & "/" & fileResult.serverFile>
    <!-- ================= RESIZE FEATURE (ADDED) ================= -->
    <cfimage action="resize"
        source="#uploadedFile#"
        destination="#uploadedFile#"
        width="200"
        height="200"
        overwrite="true">
    <!-- SAVE DB PATH -->
    <cfset imagePath = "images/uploads/#fileResult.serverFile#">
</cfif>   

    <!-- UPDATE DB -->
    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET
            name = <cfqueryparam value="#form.name#" cfsqltype="cf_sql_varchar">,
            role = <cfqueryparam value="#form.role#" cfsqltype="cf_sql_varchar">,
            description = <cfqueryparam value="#form.description#" cfsqltype="cf_sql_varchar">,
            profile_image = <cfqueryparam value="#imagePath#" cfsqltype="cf_sql_varchar">
        WHERE username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
    </cfquery>
        <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "UPDATE_PROFILE",
        description = "User #session.username# updated profile (Name: #form.name#, Role: #form.role#)"
    }>
    <!-- ================= INCLUDE LOGGER ================= -->
    <cfinclude template="views/logfile.cfm">
    <!-- REDIRECT -->
    <cflocation url="index.cfm?fuse=profile" addtoken="false">
</cffunction>  

<cffunction name="deleteProfile" access="public" returntype="void" output="true">
    <!-- ================= GET CURRENT IMAGE ================= -->
    <cfquery name="getImage" datasource="#application.datasource#">
        SELECT profile_image
        FROM users
        WHERE username =
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- ================= DELETE IMAGE FILE ================= -->
    <cfif len(trim(getImage.profile_image))>
        <cfset imagePath = expandPath("./#getImage.profile_image#")>
        <cfif fileExists(imagePath)>
            <cffile action="delete" file="#imagePath#">
        </cfif>
    </cfif>

    <!-- ================= UPDATE DATABASE ================= -->
    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET profile_image = ''
        WHERE username =
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>   
    <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "DELETE_PROFILE",
        description = "User : #session.username# deleted profile picture "
    }>
    <cfset logMessage = logData.description>
    <!-- ================= LOG TO DB + FILE ================= -->
    <cfinclude template="views/logfile.cfm">
    <!-- ================= REDIRECT ================= -->
    <cflocation url="index.cfm?fuse=profile" addtoken="false">
</cffunction>
    
    <!-- SUBMIT REQUEST -->
    <cffunction name="submitform" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.title = "Submit Request">
        <cfreturn data>
    </cffunction>
     
    <cffunction name="submitvalidation" access="public" returntype="void" output="true">
    <!-- ================= FORM VALIDATION ================= -->
    <cfparam name="form.Title" default="">
    <cfparam name="form.Description" default="">
    <cfparam name="form.Department" default="">
    <cfif NOT len(trim(form.Title)) OR NOT len(trim(form.Description)) OR NOT len(trim(form.Department))>
        <cfoutput>
            <h3 style="color:red;">All fields are required</h3>
        </cfoutput>
        <cfabort>
    </cfif>

    <cftry>
        <!-- ================= GET LAST REQUEST ID ================= -->
        <cfquery datasource="#application.datasource#" name="getLast">
            SELECT MAX(user_request_id) AS last_id
            FROM requests
            WHERE username =
            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset var nextId = 1>
        <cfif isNumeric(getLast.last_id)>
            <cfset nextId = getLast.last_id + 1>
        </cfif>
        <!-- ================= INSERT REQUEST ================= -->
        <cfquery datasource="#application.datasource#">
            INSERT INTO requests (
                username,
                Title,
                Description,
                Department,
                user_request_id
            )
            VALUES (
                <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.Title#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.Description#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#form.Department#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#nextId#" cfsqltype="cf_sql_integer">
            )
        </cfquery>
        <!-- ================= LOG DATA ================= -->
        <cfset logData = {
            action_type = "REQUEST_SUBMITTED",
            description = "User #session.username# submitted request ID #nextId#"
        }>
        <cfset logMessage = "submitted request ID #nextId#">
        <!-- ================= LOGGER ================= -->
        <cfinclude template="views/logfile.cfm">
        <!-- ================= SUCCESS ================= -->
        <cfoutput>
            <script>
                alert("Request submitted successfully! ID: #nextId#");
                window.location.href = "index.cfm?fuse=viewrequest";
            </script>
        </cfoutput>
        <cfcatch type="any">
            <cfoutput>
                <h3 style="color:red;">
                    ERROR: #cfcatch.message# <br>
                    #cfcatch.detail#
                </h3>
            </cfoutput>
        </cfcatch>
    </cftry>
</cffunction>


<!-- VIEW REQUEST -->
<cffunction name="viewrequest" access="public" returntype="struct" output="true">
    <cfset var data = {} />
    <!-- DEFAULT FILTER -->
    <cfparam name="form.searchDepartment" default="All Departments">
    <!-- GET UNIQUE DEPARTMENTS in filter -->
    <cfquery name="getDepartments" datasource="#application.datasource#">
        SELECT DISTINCT Department
        FROM requests
        WHERE TRIM(Department) <> ''
        ORDER BY Department ASC
    </cfquery>

    <!-- GET REQUESTS -->
    <cfquery name="getRequests" datasource="#application.datasource#">
        SELECT *
        FROM requests
        WHERE username =
        <cfqueryparam
            value="#session.username#"
            cfsqltype="cf_sql_varchar">
        <cfif form.searchDepartment NEQ "All Departments">
            AND Department =
            <cfqueryparam
                value="#form.searchDepartment#"
                cfsqltype="cf_sql_varchar">
        </cfif>
        ORDER BY request_id DESC
    </cfquery>
    <!-- STORE IN DATA STRUCT -->
    <cfset data.getDepartments = getDepartments>
    <cfset data.getRequests = getRequests>
    <!-- TITLE -->
    <cfset data.title = "View Requests">
    <cfreturn data>
</cffunction>

<!-- DOWNLOAD REPORT -->
<cffunction
    name="downloadreport"
    access="public"
    returntype="struct"
    output="false">
    <cfset var data = {}>
    <!-- URL PARAM -->
    <cfparam
        name="url.department"
        default="All Departments">

    <!-- GET REQUESTS -->
    <cfquery
        name="getRequests"
        datasource="#application.datasource#">
        SELECT *
        FROM requests
        WHERE username =
        <cfqueryparam
            value="#session.username#"
            cfsqltype="cf_sql_varchar">
        <cfif url.department NEQ "All Departments">
            AND Department =
            <cfqueryparam
                value="#url.department#"
                cfsqltype="cf_sql_varchar">
        </cfif>
        ORDER BY request_id DESC
    </cfquery>
    <!-- STORE DATA -->
    <cfset data.getRequests = getRequests>
  <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
    action_type = "viewed_pdf",
    report_type = "requests",
    description = "#session.username# viewed Requests PDF of department: #url.department#"
}>
   <cfinclude template="views/logfile.cfm">
    <cfreturn data>
</cffunction>

<!-- UPDATE FORM -->
<cffunction
    name="updateform"
    access="public"
    returntype="struct"
    output="false">
    <cfset var data = {}>
    <!-- URL PARAM -->
    <cfparam
        name="url.id"
        default="0">
    <!-- GET REQUEST -->
    <cfquery
        name="getRequest"
        datasource="#application.datasource#">
        SELECT *
        FROM requests
        WHERE request_id =
        <cfqueryparam
            value="#url.id#"
            cfsqltype="cf_sql_integer">
    </cfquery>
    <!-- STORE DATA -->
    <cfset data.getRequest = getRequest>
    <!-- PAGE TITLE -->
    <cfset data.title = "Update Request">
    <cfreturn data>
</cffunction>

<!-- UPDATE VALIDATION -->
<cffunction
    name="updatevalidation"
    access="public"
    returntype="void"
    output="false">
    <!-- UPDATE QUERY -->
    <cfquery datasource="#application.datasource#">
        UPDATE requests
        SET
            Title =
            <cfqueryparam
                value="#form.Title#"
                cfsqltype="cf_sql_varchar">,
            Department =
            <cfqueryparam
                value="#form.Department#"
                cfsqltype="cf_sql_varchar">,
            Description =
            <cfqueryparam
                value="#form.Description#"
                cfsqltype="cf_sql_varchar">
        WHERE request_id =
            <cfqueryparam
                value="#form.request_id#"
                cfsqltype="cf_sql_integer">
    </cfquery>
     <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "UPDATED REQUEST",
        description = "User #session.username# updated the existing request"
    }>
    <!-- ================= INCLUDE LOGGER ================= -->
    <cfinclude template="views/logfile.cfm">
    <!-- SUCCESS REDIRECT -->
    <cflocation
        url="index.cfm?fuse=viewrequest&status=updated"
        addtoken="false">
</cffunction>


<!-- DELETE VALIDATION -->
<cffunction
    name="deletevalidation"
    access="public"
    returntype="void"
    output="false">
    <!-- SESSION CHECK -->
    <!-- URL PARAM -->
    <cfparam
        name="url.id"
        default="0">
    <!-- GET USER + USER REQUEST ID -->
    <cfquery
        datasource="#application.datasource#"
        name="getInfo">
        SELECT
            username,
            user_request_id
        FROM requests
        WHERE request_id =
        <cfqueryparam
            value="#url.id#"
            cfsqltype="cf_sql_integer">
    </cfquery>
    <!-- DELETE QUERY -->
    <cfquery datasource="#application.datasource#">
        DELETE FROM requests
        WHERE request_id =
        <cfqueryparam
            value="#url.id#"
            cfsqltype="cf_sql_integer">
    </cfquery>
    <!-- RESET MYSQL VARIABLE -->
    <cfquery datasource="#application.datasource#">
        SET @count = 0
    </cfquery>
    <!-- REORDER USER REQUEST IDS -->
    <cfquery datasource="#application.datasource#">
        UPDATE requests
        SET user_request_id = (@count := @count + 1)
        WHERE username =
        <cfqueryparam
            value="#getInfo.username#"
            cfsqltype="cf_sql_varchar">
        ORDER BY request_id ASC
    </cfquery>
   
    <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "DELETE REQUEST",
        description = "User #session.username# deleted the existing request"
    }>
    <!-- ================= INCLUDE LOGGER ================= -->
    <cfinclude template="views/logfile.cfm">    
    <!-- REDIRECT -->
    <cflocation
        url="index.cfm?fuse=viewrequest&status=deleted"
        addtoken="false">
</cffunction>

<!-- VIEW LOGS -->
    <cffunction name="viewlogs" access="public" returntype="struct" output="false">
    <cfset var data = {}>
    <cfquery name="data.logs" datasource="#application.datasource#">
        SELECT *
        FROM logs
        ORDER BY created_at DESC
    </cfquery>
    <cfreturn data>
</cffunction>


    <!-- CUSTOMERS -->
    <cffunction name="customers" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.title = "Customer Management">
        <cfreturn data>
    </cffunction>

    <!-- CUSTOMER AJAX API -->
    <cffunction
    name="customersApi"
    access="remote"
    returntype="any"
    returnformat="json"
    output="false">
    <cfset var customerService =
        createObject("component", "components.customers")>
    <cfset var result = {}>
    <!-- URL Defaults -->
    <cfparam name="url.action" default="">
    <cfparam name="url.search" default="">
    <cfparam name="url.page" default="1">
    <cfparam name="url.pageSize" default="5">

    <!-- FORM Defaults -->
    <cfparam name="form.action" default="">
    <cfparam name="form.search" default="">
    <cfparam name="form.page" default="1">
    <cfparam name="form.pageSize" default="5">

    <cfparam name="form.id" default="">
    <cfparam name="form.name" default="">
    <cfparam name="form.email" default="">
    <cfparam name="form.phone" default="">

    <!-- Determine Action -->
    <cfset var action = "">
    <cfif len(trim(form.action))>
        <cfset action = form.action>
    <cfelse>
        <cfset action = url.action>
    </cfif>
    <cfswitch expression="#action#">
    <!-- GET CUSTOMERS -->
    <cfcase value="getCustomers">
    <cfset result =
        customerService.getCustomers(
            search   = structKeyExists(url,"search") ? url.search : "",
            page     = structKeyExists(url,"page") ? val(url.page) : 1,
            pageSize = structKeyExists(url,"pageSize") ? val(url.pageSize) : 5
        )
    >
</cfcase>
    
    <!-- SAVE CUSTOMER -->
    <cfcase value="saveCustomer">
        <cfparam name="form.id" default="">
        <cfset result =
            customerService.saveCustomer(
                id = form.id,
                name = form.name,
                email = form.email,
                phone = form.phone
            )>
    </cfcase>

    <cfcase value="emailExists">
    <cfset result =
        customerService.emailExists(
            email = url.email,
            id = structKeyExists(url,"id") ? url.id : 0
        )>
</cfcase>

<!-- GET CUSTOMER -->
<cfcase value="getCustomer">
    <cfset result =
        customerService.getCustomer(
            id = url.id
        )>
</cfcase>

<!-- DELETE CUSTOMER -->
<cfcase value="deleteCustomer">
    <cfset result =
        customerService.deleteCustomer(
            id = url.id
        )>
</cfcase>
    <!-- DEFAULT -->
    <cfdefaultcase>
        <cfset result = {
            success = false,
            message = "Unknown action"
        }>
    </cfdefaultcase>
</cfswitch>
    <cfreturn result>
</cffunction>

    <!-- CUSTOMERS PDF -->
<cffunction name="customerspdf"
    access="public"
    returntype="struct"
    output="false">
    <cfset var data = {}>
    <cfparam name="url.search" default="">
    <cfset var searchTerm = "%" & trim(url.search) & "%">
    <cfquery name="data.customers" datasource="#application.datasource#">
        SELECT
            id,
            username,
            name,
            email,
            phone
        FROM customers
        WHERE
            name LIKE
            <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
            OR
            email LIKE
            <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
        ORDER BY id DESC
    </cfquery>
    <cfreturn data>
</cffunction>

   <!-- USERS REGISTER LIST -->
<cffunction name="usersregisterlist" access="public" returntype="struct" output="false">
    <cfset var data = {}>
    <cfquery name="data.users" datasource="#application.datasource#">
        SELECT 
            user_id,
            username,
            mail_id AS mail
        FROM users
        ORDER BY user_id DESC
    </cfquery>
    <cfreturn data>
</cffunction>

<!-- stats -->
    <cffunction name="stats" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.title = "Stats Page">
        <cfreturn data>
    </cffunction>
       
    <cffunction name="logout" access="public" returntype="void" output="false">
     <!-- ================= LOG DATA (IMPORTANT) ================= -->
    <cfset logData = {
        action_type = "LOGGED OUT",
        description = "#session.username# logged out from the session"
    }>
    <!-- ================= INCLUDE LOGGER ================= -->
    <cfinclude template="views/logfile.cfm">
    <!-- logout.cfm -->
<!-- Remove this session from global list -->
<cflock scope="application" type="exclusive" timeout="5">
    <cfif structKeyExists(application, "allSessions")>
        <cfloop from="1" to="#arrayLen(application.allSessions)#" index="i">
            <cfif application.allSessions[i].sessionStartTime EQ session.sessionStartTime>
                <cfset arrayDeleteAt(application.allSessions, i)>
                <cfbreak>
            </cfif>
        </cfloop>
    </cfif>
</cflock>
<!-- Clear and invalidate session -->
<cfset structClear(session)>
<cfset sessionInvalidate()>
    <!-- CACHE CONTROL -->
    <cfheader
        name="Cache-Control"
        value="no-store, no-cache, must-revalidate">

    <cfheader
        name="Pragma"
        value="no-cache">

    <cfheader
        name="Expires"
        value="0">
    
    <!-- REDIRECT -->
<cflocation url="/CRM/Views/loginform.cfm" addtoken="false">
    </cffunction>
</cfcomponent>