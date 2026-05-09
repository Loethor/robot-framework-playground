_books = {}


def add_book(title):
    """
    Add a book to the library.

    Returns:
        True if added successfully.
        False if the book already exists.
    """
    if title in _books:
        return False
    _books[title] = None
    return True


def remove_book(title):
    """
    Remove a book from the library.

    A borrowed book cannot be removed.
    """
    if title not in _books:
        return False
    if _books[title] is not None:
        return False
    del _books[title]
    return True


def borrow_book(title, user):
    """
    Borrow a book for a specific user.
    """
    if title not in _books:
        return False
    if _books[title] is not None:
        return False
    _books[title] = user
    return True


def return_book(title):
    """
    Return a borrowed book.
    """
    if title not in _books:
        return False
    if _books[title] is None:
        return False
    _books[title] = None
    return True


def is_available(title):
    """
    Check whether a book is available.
    """
    return title in _books and _books[title] is None


def get_books():
    """
    Return all books and their borrowing status.
    """
    return _books.copy()


def clear():
    """
    Reset the library state.
    """
    _books.clear()
