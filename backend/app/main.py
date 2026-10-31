import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.core.logging import setup_logging
from app.core.middleware import log_requests
from app.core.settings import settings

from app.database.init_db import init_db

# ==========================================================
# Routers (NEW SYSTEM ONLY)
# ==========================================================

from app.routers.auth_router import (
    router as auth_router,
)

from app.routers.learning_session_router import (
    router as learning_session_router,
)

from app.routers.content_router import (
    router as content_router,
)

from app.routers.subject_router import (
    router as subject_router,
)

from app.routers.classroom_router import (
    router as classroom_router,
)

from app.routers.student_router import (
    router as student_router,
)

logger = setup_logging()

# ==========================================================
# FastAPI
# ==========================================================

app = FastAPI(
    title=settings.app_name,
    version=settings.version,
    description="ProLearn AI Platform",
)

# ==========================================================
# Middleware (CORS & Logging)
# ==========================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.middleware("http")(log_requests)

# ==========================================================
# Upload Folder
# ==========================================================

os.makedirs(
    "uploads",
    exist_ok=True,
)

os.makedirs(
    "uploads/audio",
    exist_ok=True,
)

app.mount(
    "/uploads",
    StaticFiles(directory="uploads"),
    name="uploads",
)

# ==========================================================
# API Routers
# ==========================================================

app.include_router(auth_router)
app.include_router(classroom_router)
app.include_router(subject_router)
app.include_router(student_router)
app.include_router(learning_session_router)
app.include_router(content_router)


# ==========================================================
# Events
# ==========================================================

@app.on_event("startup")
async def startup():
    init_db()
    logger.info("Database initialized")
    logger.info("ProLearn started")


@app.on_event("shutdown")
async def shutdown():
    logger.info("Server stopped")


# ==========================================================
# Health
# ==========================================================

@app.get("/")
async def root():
    return {
        "project": settings.app_name,
        "version": settings.version,
        "status": "running",
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy",
    }