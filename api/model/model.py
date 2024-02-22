from pydantic import BaseModel


class InputData(BaseModel):
    number_of_courses:int
    time_study: float
class OutputData(BaseModel):
    marks: float
