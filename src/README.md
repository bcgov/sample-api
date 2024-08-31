# How To Use

This is a sample APi that uses FastAPI. If you like to use this withouth docker you need install the dependencies on the `requirements.txt` files using PIP. Like so:

```console
pip install -r requirements.txt
```

Then run the code using:

```console
cd sample_api; fastapi dev ./main.py
```

However, you can run the code using Docker by building the image and then running the container:

Building the container:

```console
docker build -t sample_api .
```

Run the container:
```console
docker run -p 8000:8000 sample_api 
```

Open http://0.0.0.0:8000/docs to see documentation.

**Note: If you are on Windows you need click on "Yes" when the warning prompted.