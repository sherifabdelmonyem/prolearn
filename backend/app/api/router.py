
from fastapi import APIRouter

from app.routers.router_manager import RouterManager

router = APIRouter()

manager = RouterManager()


@router.get("/route/{task}")
async def route_task(task: str):

    agent = manager.route(task)

    return {
        "task": task,
        "selected_agent": agent
    }
