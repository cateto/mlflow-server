FROM python:3.7
LABEL maintainer="cateto <u2skind@gmail.com>"
ARG MLFLOW_VERSION=1.22.0

WORKDIR /mlflow/
RUN pip install --no-cache-dir mlflow==$MLFLOW_VERSION
RUN pip install --no-cache-dir pysftp
RUN pip install --no-cache-dir pymysql
RUN pip install google-cloud-logging==3.1.1 protobuf==3.19.0
EXPOSE 5000

ENV BACKEND_URI mysql+pymysql://${mysql.user}:${mysql.password}@${mysql.host}:3306/mlflow
ENV ARTIFACT_ROOT sftp://${sftp.user}:${sftp.password}@${sftp.host}:22/root/mlflow/mlruns

CMD protoc --version
CMD export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
CMD mlflow server --backend-store-uri ${BACKEND_URI} --default-artifact-root ${ARTIFACT_ROOT} --host 0.0.0.0 --port 5000
