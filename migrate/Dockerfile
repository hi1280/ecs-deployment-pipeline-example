FROM public.ecr.aws/bitnami/python:3.9.7

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    default-libmysqlclient-dev \
    build-essential \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV WORKDIR /app/

WORKDIR ${WORKDIR}

COPY Pipfile Pipfile.lock ${WORKDIR}

RUN pip install pipenv --no-cache-dir && \
    pipenv install --system --deploy && \
    pip uninstall -y pipenv virtualenv-clone virtualenv

COPY . $WORKDIR

CMD ["db-migrate"]