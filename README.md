# Robot Framework Playground

This project demonstrates how to use a simple Python library as a Robot Framework test library without classes.

## Structure

- `src/book_library.py` — Python library with module-level functions for managing books.
- `tests/library_tests.robot` — Robot Framework test suite using the library.

## Usage

1. **Install dependencies**
   ```sh
   pip install -r requirements.txt
   ```

2. **Run tests**
   ```sh
   robot tests/
   ```


## Features
- Add, remove, borrow, and return books
- Check book availability
- All keywords are available as module-level functions

---

Feel free to extend the library and add more tests!