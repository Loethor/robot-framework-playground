_books = {}


def add_book(title):
    title = title.strip()

    if not title:
        return {"status": "empty_title"}

    if title in _books:
        return {"status": "already_exists"}

    _books[title] = None
    return {"status": "success"}


def borrow_book(title: str, person_name: str):
    title = title.strip()
    person_name = person_name.strip()

    if not title:
        return {"status": "empty_title"}

    if not person_name:
        return {"status": "empty_person_name"}

    if title not in _books:
        return {"status": "not_found"}

    if _books[title] is not None:
        return {"status": "already_borrowed"}

    _books[title] = person_name
    return {"status": "success"}


def get_books():
    return _books.copy()


def clear_library():
    _books.clear()
    return {"status": "success"}
