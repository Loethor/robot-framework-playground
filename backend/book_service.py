_books = {}


def add_book(title):
    title = title.strip()

    if not title:
        return {"success": False, "reason": "empty_title"}

    if title in _books:
        return {"success": False, "reason": "already_exists"}

    _books[title] = None
    return {"success": True}


def get_books():
    return _books.copy()


def clear_library():
    _books.clear()
    return {"success": True}
