# Use the latest Python image from Microsoft's devcontainers with the specified version
FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# update apt, install octave, and clean up
RUN apt-get update \
  && apt-get install -y octave \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# install pip octave kernel and jupyter
RUN pip install octave_kernel \
  && pip install jupyter 
