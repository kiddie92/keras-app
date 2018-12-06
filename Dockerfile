FROM python:3.6
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r ./requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple/
COPY app.py /app
CMD ["python", "app.py"]
