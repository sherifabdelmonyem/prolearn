from sqlalchemy.orm import Session

from app.models.classroom import Classroom


class ClassroomRepository:

    @staticmethod
    def get_all(db: Session):
        return (
            db.query(Classroom)
            .order_by(Classroom.id)
            .all()
        )

    @staticmethod
    def get_by_id(
        db: Session,
        classroom_id: int,
    ):
        return (
            db.query(Classroom)
            .filter(
                Classroom.id == classroom_id
            )
            .first()
        )

    @staticmethod
    def create(
        db: Session,
        classroom: Classroom,
    ):
        db.add(classroom)
        db.commit()
        db.refresh(classroom)
        return classroom

    @staticmethod
    def delete(
        db: Session,
        classroom_id: int,
    ):
        classroom = (
            db.query(Classroom)
            .filter(
                Classroom.id == classroom_id
            )
            .first()
        )

        if classroom:
            db.delete(classroom)
            db.commit()

        return classroom