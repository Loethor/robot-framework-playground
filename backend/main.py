from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from fastapi import HTTPException

from book_service import get_books, add_book, clear_library
import os

app = FastAPI()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FRONTEND_DIR = os.path.join(BASE_DIR, "../frontend")
FRONTEND_PATH = os.path.join(FRONTEND_DIR, "index.html")


@app.get("/books")
def books():
    return get_books()


@app.get("/")
def root():
    return FileResponse(FRONTEND_PATH)


@app.post("/books/{title}")
def create_book(title: str):
    result = add_book(title)

    if not result["success"]:
        if result["reason"] == "empty_title":
            raise HTTPException(status_code=400, detail=result)
        if result["reason"] == "already_exists":
            raise HTTPException(status_code=409, detail=result)

    return result


@app.delete("/books")
def clear():
    return clear_library()


app.mount("/static", StaticFiles(directory=FRONTEND_DIR), name="static")
