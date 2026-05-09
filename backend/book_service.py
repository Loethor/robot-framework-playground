_books = {}


def add_book(title):
    if title in _books:
        return False

    _books[title] = None
    return True


def get_books():
    return _books
