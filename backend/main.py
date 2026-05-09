from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend import book_service

app = FastAPI()

# Enable CORS for frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/books")
def create_book(payload: dict):
    """Add a book to the library."""
    success = book_service.add_book(payload["title"])
    return {"success": success}


@app.get("/books")
def list_books():
    """Get all books and their borrowing status."""
    return book_service.get_books()


@app.delete("/books/{title}")
def remove_book(title: str):
    """Remove a book from the library."""
    success = book_service.remove_book(title)
    return {"success": success}


@app.post("/borrow")
def borrow_book(payload: dict):
    """Borrow a book for a user."""
    success = book_service.borrow_book(payload["title"], payload["user"])
    return {"success": success}


@app.post("/return")
def return_book(payload: dict):
    """Return a borrowed book."""
    success = book_service.return_book(payload["title"])
    return {"success": success}


@app.get("/books/{title}/available")
def check_availability(title: str):
    """Check if a book is available."""
    available = book_service.is_available(title)
    return {"available": available}


@app.post("/clear")
def clear_library():
    """Clear all books from the library."""
    book_service.clear()
    return {"success": True}
