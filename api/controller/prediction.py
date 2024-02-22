
import joblib

from model.model import InputData, OutputData



model = joblib.load("../model/model.joblib")
def predict(data:InputData)->OutputData:
    output = model.predict([[data.number_of_courses,data.time_study]])
    if output[0]<0:
        output[0]=0
    return OutputData(marks=output[0])
