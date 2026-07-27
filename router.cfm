<cfsetting enablecfoutputonly="no">
<!-- DEFAULT PAGE -->
<cfset fuse = structKeyExists(url, "fuse") ? url.fuse : "home">

<!-- DATA STRUCT -->
<cfset data = {} />

<cfoutput>

    <!-- HOME PAGE -->
    <cfif fuse EQ "home">

        <cfset data = application.controller.home() />
        <cfinclude template="views/home.cfm" />

    <!-- PROFILE PAGE -->
    <cfelseif fuse EQ "profile">

        <cfset data = application.controller.profile() />
        <cfinclude template="views/profile.cfm" />

    <!-- EDIT PAGE -->
    <cfelseif fuse EQ "edit">
        <cfset data = application.controller.edit() />
        <cfinclude template="views/edit.cfm" />

<!-- UPDATE PROFILE -->
    <cfelseif fuse EQ "editvalidation">
        <cfset application.controller.editvalidation() />

<!-- DELETE PROFILE -->
<cfelseif fuse EQ "deleteprofile">
    <cfset application.controller.deleteProfile() />

    <!-- SUBMIT FORM -->
    <cfelseif fuse EQ "submitform">       
        <cfset data = application.controller.submitform() />
        <cfinclude template="views/submitform.cfm" />
        
    <!-- SUBMIT VALIDATION -->
    <cfelseif fuse EQ "submitvalidation">
    <cfset application.controller.submitvalidation() />

   <!-- VIEW REQUEST -->
<cfelseif fuse EQ "viewrequest">
    <!-- CALL CONTROLLER + STORE RETURN DATA -->
    <cfset data = application.controller.viewrequest() />
    <!-- LOAD VIEW -->
    <cfinclude template="views/viewrequest.cfm" />

    <!-- DOWNLOAD REPORT --> 
<cfelseif fuse EQ "downloadreport">
     <cfset data = application.controller.downloadreport()>
      <cfinclude template="views/downloadreport.cfm">

<!-- UPDATE FORM -->
 <cfelseif fuse EQ "updateform">
     <cfset data = application.controller.updateform()>
      <cfinclude template="views/updateform.cfm">

  
<!-- UPDATE VALIDATION -->
<cfelseif fuse EQ "updatevalidation">
    <cfset application.controller.updatevalidation()>

<!-- DELETE VALIDATION -->
 <cfelseif fuse EQ "deletevalidation">
     <cfset application.controller.deletevalidation()>    

  
    <!-- VIEW LOGS -->
    <cfelseif fuse EQ "viewlogs">

        <cfset data = application.controller.viewlogs() />
        <cfinclude template="views/viewlogs.cfm" />

    <!-- CUSTOMERS -->
    <cfelseif fuse EQ "customers">
        <cfset data = application.controller.customers() />
        <cfinclude template="views/customers.cfm" />

    <!-- CUSTOMERS PDF -->
<cfelseif fuse EQ "customerspdf">
    <cfset data = application.controller.customerspdf() />
    <cfinclude template="views/customerspdf.cfm" />

    <!-- REGISTER USERS -->
    <cfelseif fuse EQ "usersregisterlist">

        <cfset data = application.controller.usersregisterlist() />
        <cfinclude template="views/usersregisterlist.cfm" />

    <cfelseif fuse EQ "stats">    
        <cfinclude template="views/stats.cfm" />

    
    <!-- LOGIN PAGE -->
    <cfelseif fuse EQ "loginform">
    <cfinclude template="views/loginform.cfm" />  

     <!-- LOGOUT -->
    <cfelseif fuse EQ "logout">
    <cfset application.controller.logout() /> 
 
    <!-- PAGE NOT FOUND -->
    <cfelse>

        <h2>Page Not Found</h2>

    </cfif>

</cfoutput>