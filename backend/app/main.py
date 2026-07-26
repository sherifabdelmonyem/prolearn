
from fastapi import FastAPI

from app.api.router import router

app = FastAPI(
    title="ProLearn API",
    description="AI Voice Learning Platform",
    version="1.0.0"
)

app.include_router(router)


@app.get("/")
async def root():
    return {
        "project": "ProLearn",
        "status": "running",
        "version": "1.0.0"
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy"
    }