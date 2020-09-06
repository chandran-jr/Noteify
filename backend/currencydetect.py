import tensorflow.keras
from PIL import Image, ImageOps
import numpy as np
import speech_recognition as sr
import pyttsx3

# Disable scientific notation for clarity
np.set_printoptions(suppress=True)

currency = ["two thousand rupee note", 'five hundred rupee note','two hundred rupee note', 'one hundred rupee note', 'one hundred rupee note','fifty rupee note','fifty rupee note']


# Load the model
model = tensorflow.keras.models.load_model('keras_model.h5')

total = 0

while 1:
    
    def userInput():
        r = sr.Recognizer()
        with sr.Microphone() as source:
            print("Listening...")
            audio = r.listen(source)
            query = r.recognize_google(audio)
        return query
    
    
    def speak(string):
        eng = pyttsx3.init()
        eng.say(string)
        eng.runAndWait()
        
        
    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)
    speak("please click an image of the currency")
    imgfile = input("Enter image name")
    
    image = Image.open(imgfile)

    size = (224, 224)
    image = ImageOps.fit(image, size, Image.ANTIALIAS)

#turn the image into a numpy array
    image_array = np.asarray(image)

# display the resized image
    image.show()

# Normalize the image
    normalized_image_array = (image_array.astype(np.float32) / 127.0) - 1

# Load the image into the array
    data[0] = normalized_image_array

# run the inference
    prediction = model.predict(data)

    prediction = np.array(prediction)
    index=0

    for i in range(0,7):
        if prediction[0,i]>0.6:
            index=i
            

    result = (currency[index])
    
    if(index==0):
        total = total+2000
    elif(index==1):
        total = total+500
    elif(index==2):
        total = total+200
    elif(index==3):
        total = total+100
    elif(index==4):
        total = total+100
    elif(index==5):
        total = total+50
    else:
        total = total+50
        
 
    print(result)
    print("Total:")
    print(total)
    
    speak(result)
    speak("your total is now rupees")
    speak(total)
    
    speak("if u want to continue say yes else say no ")
    inp = userInput().lower()
    if inp=='no':
        speak("exiting app")
        print("App Exited.")
        break
    else:
        speak("continuing app")


