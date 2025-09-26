# 基础镜像
FROM python:3.12-slim

# 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git

# 拉取 llama_deploy 源码（可根据需要切换分支或 tag）
ARG LLAMA_DEPLOY_VERSION=main
ARG GIT_CLONE_OPTIONS=--depth=1
RUN git clone ${GIT_CLONE_OPTIONS} --branch=${LLAMA_DEPLOY_VERSION} https://github.com/run-llama/llama_deploy.git /opt/llama_deploy

WORKDIR /opt/llama_deploy

# 创建虚拟环境并安装 llama_deploy
RUN python3 -m venv --system-site-packages /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install --no-cache-dir .

# 复制启动脚本（如有不同可自定义）
COPY ./docker/run_apiserver.py /opt/run_apiserver.py

# 容器参数
ENV LLAMA_DEPLOY_APISERVER_HOST=0.0.0.0
ENV LLAMA_DEPLOY_APISERVER_PORT=4501

EXPOSE 4501

ENTRYPOINT ["python", "/opt/run_apiserver.py"]
