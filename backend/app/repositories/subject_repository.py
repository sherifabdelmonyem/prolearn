from sqlalchemy.orm import Session

from app.models.lesson import Lesson
from app.models.subject import Subject


class SubjectRepository:

    @staticmethod
    def get_subjects(db: Session):

        return db.query(Subject).all()

    @staticmethod
    def get_lessons(
        db: Session,
        subject_id: int,
    ):

        return (
            db.query(Lesson)
            .filter(
                Lesson.subject_id == subject_id
            )
            .all()
        )