function toggleSidebar() {
        var sidebar = document.getElementById("mySidebar");
        if (sidebar.style.width === "250px") {
            closeSidebar();
        } else {
            openSidebar();
        }
    }

    function openSidebar() {
        document.getElementById("mySidebar").style.width = "250px";
    }

    function closeSidebar() {
        document.getElementById("mySidebar").style.width = "0";
    }