# keras-app
> 使用python flask 以及 keras建立一个简单的image recognition的工具，主要参考了[这里](https://medium.com/analytics-vidhya/deploy-your-first-deep-learning-model-on-kubernetes-with-python-keras-flask-and-docker-575dc07d9e76)
> 觉得有点意思就实现了一下，里面设计到python编程、docker、k8s的使用，image recognition模型不涉及训练，使用的是开源模型，下次自己train个模型出来看看效果^_^。
> 代码托管在[github](https://github.com/kiddie92/keras-app)。

## 测试一下代码是否可用
```bash
# 安装依赖模块，南七技校的pip源比较好用
pip install -r requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple/ 
# 运行代码
python app.py  
# 找个图片辨认一下
curl -X POST -F image=@dog.jpg 'http://127.0.0.1:2400/predict
```

> 首次运行代码后，需要等待一段时间，因为要下载图片识别的模型


## 制作docker镜像
```bash
sudo docker build -t keras-app:latest .
```
出现如下提示则镜像制作成功
```bash
Successfully built pyyaml gast absl-py termcolor MarkupSafe
...
...
Removing intermediate container 3a21aa77c06c
Successfully built fc03d48b4096
```
查看一下镜像信息：
```bash
[conan@localhost deeplearning_flask]$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
keras-app           latest              fc03d48b4096        43 minutes ago      1.7 GB
```
> 1.7G.. [捂脸]  应该还可以优化一下...

## 测试docker镜像

```bash
# 运行
sudo docker run --name image-recon -d -p 2400:2400 keras-app:latest
# 测试
curl -X POST -F image=@dog.jpg 'http://127.0.0.1:2400/predict'
# 打包带走
sudo docker save keras-app:latest > keras-app.tar
```

## 在kubernetes上调度
使用k8s集群部署应用，推荐使用yaml文件，前置条件是把刚刚的镜像push到k8s使用的镜像仓库中
这里使用简单一点的deployment方式来部署`imagerecon_deployment_test_for_fun.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: imagerecon-deployment
  labels:
    app: imagerecon
spec:
  replicas: 1
  selector:
    matchLabels:
      app: imagerecon
  template:
    metadata:
      labels:
        app: imagerecon
    spec:
      containers:
      - name: imagerecon
        image: keras-app:latest
        ports:
        - containerPort: 2400
```
部署
```bash
kubectl create -f imagerecon_deployment_test_for_fun.yaml
# 查看
kubectl get pods --show-labels
```

## 参考资料

https://medium.com/analytics-vidhya/deploy-your-first-deep-learning-model-on-kubernetes-with-python-keras-flask-and-docker-575dc07d9e76