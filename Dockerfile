FROM jupyter/datascience-notebook:python-3.11

USER root

# Apply any new security updates to the base image
RUN apt-get -qq update \
    && apt-get dist-upgrade -y \
    && apt-get autoremove

# Prepare a working directory
WORKDIR /home/jovyan

# Pre-install non-apt dependencies into a conda environment
RUN mkdir -p notebooks
ADD environment.yaml ./notebooks/environment.yaml
RUN conda env create --name notebooks --file ./notebooks/environment.yaml

# Install all the notebook files from this repository
COPY ./ ./notebooks/

# Run the Jupyter Server, ensuring that the conda environment
# gets activated along the way
USER jovyan
RUN echo "conda activate notebooks" >> /home/jovyan/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

ENTRYPOINT ["conda", "run", "--no-capture-output", "--name", "notebooks"]
CMD ["start.sh", "jupyter", "lab"]
