from fastapi import FastAPI
from controller.prediction import predict

from model.model import InputData




app = FastAPI()

@app.post("/api/perfomance")
def performance(data:InputData):
    return predict(data)