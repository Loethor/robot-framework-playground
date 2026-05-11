from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from fastapi import HTTPException

from backend.book_service import get_books, add_book, borrow_book, clear_library

import os

app = FastAPI()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

FRONTEND_DIR = os.path.join(BASE_DIR, "../frontend")
FRONTEND_PATH = os.path.join(FRONTEND_DIR, "index.html")

STATUS_TO_HTTP = {
    "empty_title": 400,
    "empty_person_name": 400,
    "not_found": 404,
    "already_borrowed": 409,
}


@app.get("/")
def root():
    return FileResponse(FRONTEND_PATH)


@app.get("/books")
def books():
    return {"status": "success", "data": get_books()}


@app.post("/books/{title}")
def create_book(title: str):
    result = add_book(title)

    status = result["status"]

    if status != "success":
        raise HTTPException(status_code=STATUS_TO_HTTP.get(status, 400), detail=result)

    return result


@app.post("/borrow/{title}/{person_name}")
def borrow(title: str, person_name: str):
    result = borrow_book(title, person_name)

    status = result["status"]

    if status != "success":
        raise HTTPException(status_code=STATUS_TO_HTTP.get(status, 400), detail=result)

    return result


@app.delete("/books")
def clear():
    return clear_library()


app.mount("/static", StaticFiles(directory=FRONTEND_DIR), name="static")
