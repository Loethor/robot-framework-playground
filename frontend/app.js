async function loadBooks() {
    const response = await fetch("/books")
    const result = await response.json()

    const books = result.data

    const list = document.getElementById("books")
    list.innerHTML = ""

    for (const title in books) {
        const borrower = books[title]

        const li = document.createElement("li")

        const text = document.createElement("span")

        if (borrower === null) {
            text.textContent = `${title} (available)`
        } else {
            text.textContent = `${title} (borrowed by ${borrower})`
        }

        const borrowButton = document.createElement("button")
        borrowButton.textContent = "Borrow"

        borrowButton.onclick = async () => {
            const user = prompt("Your name:")

            if (!user) return

            const response = await fetch(
                `/borrow/${title}/${user}`,
                { method: "POST" }
            )

            const result = await response.json().catch(() => null)

            if (!response.ok) {
                alert(result?.detail?.status || "error")
                return
            }

            loadBooks()
        }

        li.appendChild(text)
        li.appendChild(document.createTextNode(" "))
        li.appendChild(borrowButton)

        list.appendChild(li)
    }
}


async function addBook() {
    const input = document.getElementById("title")

    const title = input.value.trim()

    if (!title) return

    const response = await fetch(`/books/${title}`, {
        method: "POST"
    })

    const result = await response.json().catch(() => null)

    if (!response.ok) {
        alert(result?.detail?.status || "error")
        return
    }

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