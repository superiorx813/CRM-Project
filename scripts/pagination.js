const rowsPerPage = 10;
const table = document.getElementById("Table");
const tbody = table.getElementsByTagName("tbody")[0];
const rows = tbody.getElementsByTagName("tr");
const pagination = document.getElementById("pagination");
let currentPage = 1;
const totalPages = Math.ceil(rows.length / rowsPerPage);
const maxVisiblePages = 5;
/* TRACK PAGE GROUP */
let currentGroup = 0;
/* DISPLAY ROWS */
function displayRows(page){
    const start = (page - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    for(let i = 0; i < rows.length; i++){
        if(i >= start && i < end){
            rows[i].style.display = "";
        }
        else{
            rows[i].style.display = "none";
        }
    }
}
/* CREATE PAGINATION */
function createPaginationButtons(){
    pagination.innerHTML = "";
    /* PREV BUTTON */
    const prevBtn = document.createElement("button");
    prevBtn.innerText = "Prev";
    prevBtn.disabled = currentGroup === 0;
    prevBtn.onclick = function(){
        if(currentGroup > 0){
            currentGroup--;
            currentPage = currentGroup * maxVisiblePages + 1;
            displayRows(currentPage);
            createPaginationButtons();
        }
    };

    pagination.appendChild(prevBtn);
    /* PAGE RANGE */
    const startPage = currentGroup * maxVisiblePages + 1;
    let endPage = startPage + maxVisiblePages - 1;
    if(endPage > totalPages){
        endPage = totalPages;
    }

    /* PAGE BUTTONS */
    for(let i = startPage; i <= endPage; i++){
        const btn = document.createElement("button");
        btn.innerText = i;
        if(i === currentPage){
            btn.classList.add("active");
        }
        btn.onclick = function(){
            currentPage = i;
            displayRows(currentPage);
            createPaginationButtons();
        };

        pagination.appendChild(btn);
    }

    /* NEXT BUTTON */
    const nextBtn = document.createElement("button");
    nextBtn.innerText = "Next";
    nextBtn.disabled = endPage >= totalPages;
    nextBtn.onclick = function(){
        if(endPage < totalPages){
            currentGroup++;
            currentPage = currentGroup * maxVisiblePages + 1;
            displayRows(currentPage);
            createPaginationButtons();
        }
    };
    pagination.appendChild(nextBtn);
}

/* INITIAL LOAD */
displayRows(currentPage);
createPaginationButtons();