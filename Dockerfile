FROM prefecthq/prefect:2.16-python3.10

# Install additional packages
COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt

COPY dbt/ /dbt/
COPY meltano/ /meltano/
COPY flows/ /flows/

WORKDIR /meltano

# RUN meltano install --clean

WORKDIR /
