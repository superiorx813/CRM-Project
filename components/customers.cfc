<cfcomponent output="false">
    <!-- ========================= -->
    <!-- EMAIL EXISTS -->
    <!-- ========================= -->
    <cffunction name="emailExists"
        access="remote"
        returnformat="json"
        output="false">
        <cfargument name="email" required="true">
        <cfargument name="id" required="false" default="0">
        <cftry>
            <cfquery name="q" datasource="#application.datasource#">
                SELECT id
                FROM customers
                WHERE email =
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
                AND id !=
                <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfreturn {
                "exists" = (q.recordCount GT 0)
            }>
            <cfcatch>
                <cfreturn {
                    "exists" = false,
                    "message" = cfcatch.message
                }>
            </cfcatch>
        </cftry>
    </cffunction>

<!-- ========================= -->
<!-- GET CUSTOMERS -->
<!-- ========================= -->
<cffunction name="getCustomers"
    access="remote"
    returntype="any"
    returnformat="json"
    output="false">
    <cfargument name="search" default="">
    <cfargument name="page" default="1">
    <cfargument name="pageSize" default="5">
    <!-- CLEAN INPUTS -->
    <cfset var localPage = max(1, val(arguments.page))>
    <cfset var localPageSize = max(1, val(arguments.pageSize))>
    <cfset var localStart = (localPage - 1) * localPageSize>
    <cfset var searchTerm = "%" & trim(arguments.search) & "%">
    <cfset var result = []>
    <cftry>
        <!-- DATA QUERY -->
        <cfquery name="q" datasource="#application.datasource#">
            SELECT
                id,
                username,
                name,
                email,
                phone
            FROM customers
            WHERE
                name LIKE <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
                OR
                email LIKE <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
            ORDER BY id DESC
            LIMIT <cfqueryparam value="#localPageSize#" cfsqltype="cf_sql_integer">
            OFFSET <cfqueryparam value="#localStart#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!-- TOTAL COUNT -->
        <cfquery name="totalQ" datasource="#application.datasource#">
            SELECT COUNT(*) AS total
            FROM customers
            WHERE
                name LIKE <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
                OR
                email LIKE <cfqueryparam value="#searchTerm#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!-- BUILD ARRAY -->
        <cfset var i = 0>
        <cfloop query="q">
            <cfset i = i + 1>
            <cfset arrayAppend(result, {
                "row_num" = localStart + i,
                "id" = q.id,
                "username" = q.username,
                "name" = q.name,
                "email" = q.email,
                "phone" = q.phone
            })>
        </cfloop>

        <!-- RETURN JSON -->
        <cfreturn {
            "data" = result,
            "total" = totalQ.total,
            "page" = localPage,
            "pageSize" = localPageSize
        }>
    <cfcatch>
        <cfreturn {
            "success" = false,
            "message" = cfcatch.message,
            "detail" = cfcatch.detail
        }>
    </cfcatch>
    </cftry>
</cffunction>
   
    <!-- ========================= -->
    <!-- GET SINGLE CUSTOMER -->
    <!-- ========================= -->
    <cffunction name="getCustomer"
        access="remote"
        returnformat="json"
        output="false">
        <cfargument name="id" required="true">
        <cftry>
            <cfquery name="q" datasource="#application.datasource#">
                SELECT
                    ROW_NUMBER() OVER (ORDER BY id) AS row_num,
                    id,
                    username,
                    name,
                    email,
                    phone
                FROM customers
                WHERE id =
                <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfif q.recordCount EQ 0>
                <cfreturn {
                    "success" = false,
                    "message" = "Customer not found"
                }>
            </cfif>
            <cfreturn {
                "success" = true,
                "row_num" = q.row_num,
                "id" = q.id,
                "username" = q.username,
                "name" = q.name,
                "email" = q.email,
                "phone" = q.phone
            }>
            <cfcatch>
                <cfreturn {
                    "success" = false,
                    "message" = cfcatch.message,
                    "detail" = cfcatch.detail
                }>
            </cfcatch>
        </cftry>
    </cffunction>


    <!-- ========================= -->
    <!-- SAVE CUSTOMER -->
    <!-- ========================= -->
    <cffunction name="saveCustomer"
        access="remote"
        returnformat="json"
        output="false">
        <cfargument name="id" default="">
        <cfargument name="name" required="true">
        <cfargument name="email" required="true">
        <cfargument name="phone" required="true">
        <cftry>
            <!-- INSERT -->
            <cfif arguments.id EQ "" OR arguments.id EQ 0>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO customers (
                        username,
                        name,
                        email,
                        phone
                    )
                    VALUES (
                        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
                <cfset msg = "Customer added successfully">
            <!-- UPDATE -->
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    UPDATE customers
                    SET
                        username =
                        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                        name =
                        <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                        email =
                        <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                        phone =
                        <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
                    WHERE id =
                    <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfset msg = "Customer updated successfully">
            </cfif>
            <cfreturn {
                "success" = true,
                "message" = msg
            }>
            <cfcatch>
                <cfreturn {
                    "success" = false,
                    "message" = cfcatch.message,
                    "detail" = cfcatch.detail,
                    "sqlState" = cfcatch.sqlState,
                    "nativeErrorCode" = cfcatch.nativeErrorCode
                }>
            </cfcatch>
        </cftry>
    </cffunction>

    <!-- ========================= -->
    <!-- DELETE CUSTOMER -->
    <!-- ========================= -->
    <cffunction name="deleteCustomer"
        access="remote"
        returnformat="json"
        output="false">
        <cfargument name="id" required="true">
        <cftry>
            <!-- DELETE -->
            <cfquery datasource="#application.datasource#">
                DELETE FROM customers
                WHERE id =
                <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <!-- RENUMBER IDS -->
            <cfquery datasource="#application.datasource#">
                SET @rownum := 0
            </cfquery>
            <cfquery datasource="#application.datasource#">
                UPDATE customers
                SET id = (@rownum := @rownum + 1)
                ORDER BY id
            </cfquery>
            <!-- RESET AUTO_INCREMENT -->
            <cfquery name="qNextId" datasource="#application.datasource#">
                SELECT IFNULL(MAX(id),0)+1 AS nextId
                FROM customers
            </cfquery>
            <cfquery datasource="#application.datasource#">
                ALTER TABLE customers
                AUTO_INCREMENT =
                <cfqueryparam value="#qNextId.nextId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfreturn {
                "success" = true,
                "message" = "Customer deleted successfully"
            }>
            <cfcatch>
                <cfreturn {
                    "success" = false,
                    "message" = cfcatch.message,
                    "detail" = cfcatch.detail
                }>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>