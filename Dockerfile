FROM python:3.6
WORKDIR /home
COPY requirements.txt /home
RUN pip install -r ./requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple/
COPY app.py /home
COPY .keras/ /root/.keras
COPY .keras/ /home/.keras
EXPOSE 2400
CMD ["python", "app.py"]
