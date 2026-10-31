import time

from fastapi import Request

from app.core.logging import setup_logging

logger = setup_logging()


async def log_requests(request: Request, call_next):
    start_time = time.time()

    response = await call_next(request)

    duration = round((time.time() - start_time) * 1000, 2)

    logger.info(
        f"{request.method} {request.url.path} "
        f"Status={response.status_code} "
        f"Time={duration} ms"
    )

    return response

