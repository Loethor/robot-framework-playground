async function loadBooks() {
    const response = await fetch("/books")
    const books = await response.json()

    const list = document.getElementById("books")
    list.innerHTML = ""

    for (const title in books) {
        const item = document.createElement("li")
        item.textContent = title
        list.appendChild(item)
    }
}

async function addBook() {
    const input = document.getElementById("title")

    await fetch("/books/" + input.value, {
        method: "POST"
    })

    input.value = ""

    loadBooks()
}


async function clearLibrary() {
    await fetch("/books", {
        method: "DELETE"
    })

    loadBooks()
}

loadBooks()