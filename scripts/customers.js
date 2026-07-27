const api = "/CRM/controller.cfc?method=customersApi";
let currentPage = 1;
let pageSize = 5;

// ESCAPE HTML
// ===========================================
function escapeHTML(text) {

    if (!text) return "";

    return text.replace(/[&<>"']/g, function (m) {

        return {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#039;"
        }[m];
    });
}

// LOAD CUSTOMERS
// ===========================================
async function loadCustomers() {
    const search =
        document.getElementById("searchBox")?.value || "";
    try {
        console.log("Current Page:", currentPage);
        const res = await fetch(
            `${api}&action=getCustomers&page=${currentPage}&pageSize=${pageSize}&search=${encodeURIComponent(search)}`
        );
        const text = await res.text();
        console.log("LOAD RESPONSE:", text);
        const result = JSON.parse(text);
        const tbody =
            document.getElementById("customerTable");
        tbody.innerHTML = "";
        if (!result.data || result.data.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6"
                        style="text-align:center;">
                        No customers found
                    </td>
                </tr>
            `;
            return;
        }
        result.data.forEach(c => {
            tbody.innerHTML += `
                <tr>
                    <td>${c.id}</td>
                    <td>${escapeHTML(c.username)}</td>
                    <td>${escapeHTML(c.name)}</td>
                    <td>${escapeHTML(c.email)}</td>
                    <td>${escapeHTML(c.phone)}</td>
                    <td>
                        <button
                            class="action-btn btn-edit"
                            onclick="editCustomer(${c.id})">
                            Edit
                        </button>
                        <button
                            class="action-btn btn-delete"
                            onclick="deleteCustomer(${c.id})">
                            Delete
                        </button>
                    </td>
                </tr>
            `;
        });

        updatePagination(result.total);
    } catch (err) {
        console.error("LOAD ERROR:", err);
        alert("Error loading customers");
    }
}
// PAGINATION
// ===========================================
function updatePagination(totalRecords) {
    const totalPages =
        Math.ceil(totalRecords / pageSize);
    const p =
        document.getElementById("pagination");
    let html = `<div class="pagination-container">`;
    // PREVIOUS
    if (currentPage > 1) {
        html += `
            <button class="page-btn"
                onclick="gotoPage(${currentPage - 1})">
                Previous
            </button>
        `;
    }

    // PAGE NUMBERS
    for (let i = 1; i <= totalPages; i++) {
        html += `
            <button
                class="page-btn ${i === currentPage ? 'active-page' : ''}"
                onclick="gotoPage(${i})">
                ${i}
            </button>
        `;
    }
    // NEXT
    if (currentPage < totalPages) {
        html += `
            <button class="page-btn"
                onclick="gotoPage(${currentPage + 1})">
                Next
            </button>
        `;
    }

    html += `</div>`;
    p.innerHTML = html;
}

function gotoPage(page) {
    currentPage = page;
    loadCustomers();
}
// SAVE CUSTOMER
// ===========================================
async function saveCustomer(e) {
    e.preventDefault();
    const name =
        document.getElementById("name").value.trim();
    const email =
        document.getElementById("email").value.trim();
    const phone =
        document.getElementById("phone").value.trim();
    try {
        // EMAIL EXISTS CHECK
        let check = await fetch(
            `${api}&action=emailExists&email=${encodeURIComponent(email)}&returnformat=json`
        );
        check = await check.json();
        if (check.exists) {
            showEmailPopup();
            return;
        }

        // SAVE DATA
        let formData = new FormData();
        formData.append("action", "saveCustomer");
        formData.append("name", name);
        formData.append("email", email);
        formData.append("phone", phone);
        let res = await fetch(
            `${api}&returnformat=json`,
            {
                method: "POST",
                body: formData
            }
        );

        const result = await res.json();
        if (result.success) {
            alert(result.message);
            resetForm();
            loadCustomers();
        } else {
            alert(result.message || "Save failed");
        }

    } catch (err) {
        console.error("SAVE ERROR:", err);
        alert("Error saving customer");
    }
}

// EDIT CUSTOMER
// ===========================================
async function editCustomer(id) {
    try {
        const res = await fetch(
    `${api}&action=getCustomer&id=${id}&returnformat=json`
);
        const text = await res.text();
        console.log("EDIT RESPONSE:", text);
        const c = JSON.parse(text);
        document.getElementById("edit_id").value = c.id;
        document.getElementById("edit_name").value = c.name;
        document.getElementById("edit_email").value = c.email;
        document.getElementById("edit_phone").value = c.phone;
        document.getElementById("editModal").style.display = "flex";
    } catch (err) {
        console.error("EDIT ERROR:", err);
        alert("Error loading customer");
    }
}

// CLOSE MODAL
function closeModal() {
    document.getElementById("editModal").style.display = "none";
}

// UPDATE CUSTOMER
async function updateCustomer() {
    const id =
        document.getElementById("edit_id").value;
    const name =
        document.getElementById("edit_name").value.trim();
    const email =
        document.getElementById("edit_email").value.trim();
    const phone =
        document.getElementById("edit_phone").value.trim();
    try {

        // CHECK EMAIL
        let checkRes = await fetch(
            `${api}&action=emailExists&email=${encodeURIComponent(email)}&id=${id}&returnformat=json`
        );
        let check = await checkRes.json();
        if (check.exists) {
            showEmailPopup();
            return;
        }

        // UPDATE DATA
        let formData = new FormData();
        formData.append("action", "saveCustomer");
        formData.append("id", id);
        formData.append("name", name);
        formData.append("email", email);
        formData.append("phone", phone);
        let res = await fetch(
            `${api}&returnformat=json`,
            {
                method: "POST",
                body: formData
            }
        );
        const result = await res.json();
        if (result.success) {
            alert(result.message);
            closeModal();
            loadCustomers();
        } else {
            alert(result.message || "Update failed");
        }

    } catch (err) {
        console.error("UPDATE ERROR:", err);
        alert("Error updating customer");
    }
}

// DELETE CUSTOMER
async function deleteCustomer(id) {
    if (!confirm("Delete this customer?")) {
        return;
    }
    try {

        const res = await fetch(
    `${api}&action=deleteCustomer&id=${id}&returnformat=json`
);
        const text = await res.text();
        console.log("DELETE RESPONSE:", text);
        const result = JSON.parse(text);
        alert(result.message);
        loadCustomers();
    } catch (err) {
        console.error("DELETE ERROR:", err);
        alert("Error deleting customer");
    }
}

// RESET FORM
function resetForm() {
    document.getElementById("customerForm").reset();
    document.getElementById("id").value = "";
}

// EMAIL POPUP
function showEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "flex";
}

function closeEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "none";
}

// CLEAR SEARCH
function clearSearch() {
    document.getElementById("searchBox").value = "";
    loadCustomers();
}

// INIT
window.onload = function () {
    loadCustomers();
};

function downloadpdf() {
    const search =
        document.getElementById("searchBox").value.trim();
    window.open(
        `index.cfm?fuse=customerspdf&search=${encodeURIComponent(search)}`,
        "_blank"
    );
}


