from sqlalchemy.orm import Session

from app.models.student import Student


class StudentRepository:

    @staticmethod
    def get_all(db: Session):
        return db.query(Student).all()

    @staticmethod
    def get_by_classroom(
        db: Session,
        classroom_id: int,
    ):
        return (
            db.query(Student)
            .filter(
                Student.classroom_id == classroom_id
            )
            .all()
        )

    @staticmethod
    def get_by_id(
        db: Session,
        student_id: int,
    ):
        return (
            db.query(Student)
            .filter(
                Student.id == student_id
            )
            .first()
        )

    @staticmethod
    def create(
        db: Session,
        student: Student,
    ):
        db.add(student)
        db.commit()
        db.refresh(student)
        return student

    @staticmethod
    def delete(
        db: Session,
        student_id: int,
    ):
        student = (
            db.query(Student)
            .filter(
                Student.id == student_id
            )
            .first()
        )

        if student:
            db.delete(student)
            db.commit()

        return student