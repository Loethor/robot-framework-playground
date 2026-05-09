from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

from book_service import get_books, add_book

app = FastAPI()


@app.get("/books")
def books():
    return get_books()


@app.post("/books/{title}")
def add(title: str):
    success = add_book(title)
    return {"success": success}


@app.get("/")
def root():
    return FileResponse("../frontend/index.html")


app.mount("/static", StaticFiles(directory="../frontend"), name="static")
