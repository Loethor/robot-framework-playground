# Robot Framework Playground

A minimal full-stack Book Library application built with FastAPI, featuring a simple web UI and automated tests using Robot Framework and Selenium.

# Overview

This project is a small end-to-end system to practice:

- REST API design (FastAPI)
- Frontend integration (HTML + JavaScript)
- API testing (Robot Framework + RequestsLibrary)
- UI testing (Robot Framework + SeleniumLibrary)

# Architecture

frontend/        HTML + JS UI
backend/         FastAPI application
tests/
    api/         API-level Robot Framework tests
    ui/          UI Selenium tests

# Installation

1. **Clone the repository**

```bash
git clone <repo-url>
cd book-library
```

2. **Create virtual environment**
```bash
python -m venv .venv
source .venv/bin/activate   # Linux
.venv\Scripts\activate      # Windows
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

# Run the application

```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000
```

## Open in browser

```http://localhost:8000/```


# Testing

You can run all tests with:
```bash
robot ./tests
```

## API tests

```bash
robot tests/api
```

## UI Tests (Selenium)

```bash
robot tests/ui
```

# Project Goals

This project was built to practice:

 - Robot Framework
 - API-first development
 - Test-driven thinking
 - UI automation basics
 - Clean separation of backend and frontend
 - Raspberry Pi deployment of small services

## License

This project is for educational purposes.