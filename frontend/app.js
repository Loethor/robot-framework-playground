const BASE_URL = "http://127.0.0.1:8000";

const addButton = document.getElementById("add-button");
const bookInput = document.getElementById("book-input");

const borrowButton = document.getElementById("borrow-button");
const borrowBookInput = document.getElementById("borrow-book-input");
const borrowUserInput = document.getElementById("borrow-user-input");

const returnButton = document.getElementById("return-button");
const returnBookInput = document.getElementById("return-book-input");

const removeButton = document.getElementById("remove-button");
const removeBookInput = document.getElementById("remove-book-input");

const bookList = document.getElementById("book-list");


// Fetch and display all books
async function fetchBooks() {
    const response = await fetch(`${BASE_URL}/books`);
    const books = await response.json();
    renderBooks(books);
}


// Render books in the list
function renderBooks(books) {
    bookList.innerHTML = "";

    if (Object.keys(books).length === 0) {
        bookList.innerHTML = "<li>No books in the library.</li>";
        return;
    }

    for (const [title, borrower] of Object.entries(books)) {
        const li = document.createElement("li");
        const status = borrower === null
            ? "✓ Available"
            : `✗ Borrowed by ${borrower}`;

        li.innerHTML = `<strong>${title}</strong> - ${status}`;
        bookList.appendChild(li);
    }
}


// Add a new book
async function addBook() {
    const title = bookInput.value.trim();

    if (!title) {
        alert("Please enter a book title.");
        return;
    }

    const response = await fetch(`${BASE_URL}/books`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title })
    });

    const data = await response.json();
    if (data.success) {
        bookInput.value = "";
        fetchBooks();
    } else {
        alert("Failed to add book. It may already exist.");
    }
}


// Borrow a book
async function borrowBook() {
    const title = borrowBookInput.value.trim();
    const user = borrowUserInput.value.trim();

    if (!title || !user) {
        alert("Please enter both book title and your name.");
        return;
    }

    const response = await fetch(`${BASE_URL}/borrow`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title, user })
    });

    const data = await response.json();
    if (data.success) {
        borrowBookInput.value = "";
        borrowUserInput.value = "";
        fetchBooks();
    } else {
        alert("Failed to borrow book. It may not exist or is already borrowed.");
    }
}


// Return a book
async function returnBook() {
    const title = returnBookInput.value.trim();

    if (!title) {
        alert("Please enter a book title.");
        return;
    }

    const response = await fetch(`${BASE_URL}/return`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title })
    });

    const data = await response.json();
    if (data.success) {
        returnBookInput.value = "";
        fetchBooks();
    } else {
        alert("Failed to return book. It may not exist or is not borrowed.");
    }
}


// Remove a book
async function removeBook() {
    const title = removeBookInput.value.trim();

    if (!title) {
        alert("Please enter a book title.");
        return;
    }

    const response = await fetch(`${BASE_URL}/books/${title}`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" }
    });

    const data = await response.json();
    if (data.success) {
        removeBookInput.value = "";
        fetchBooks();
    } else {
        alert("Failed to remove book. It may not exist or is borrowed.");
    }
}


// Event listeners
addButton.addEventListener("click", addBook);
borrowButton.addEventListener("click", borrowBook);
returnButton.addEventListener("click", returnBook);
removeButton.addEventListener("click", removeBook);

// Allow Enter key to submit forms
bookInput.addEventListener("keypress", (e) => e.key === "Enter" && addBook());
borrowBookInput.addEventListener("keypress", (e) => e.key === "Enter" && borrowBook());
returnBookInput.addEventListener("keypress", (e) => e.key === "Enter" && returnBook());
removeBookInput.addEventListener("keypress", (e) => e.key === "Enter" && removeBook());

// Initial load
fetchBooks();