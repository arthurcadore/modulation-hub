# Use the latest Python image from Microsoft's devcontainers with the specified version
FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# Update apt, install octave, and clean up
RUN apt-get update --no-cache \
  && apt-get install -y --no-cache octave \
  && apt-get clean --no-cache \
  && rm -rf /var/lib/apt/lists/*

# Install pip octave kernel and jupyter
RUN pip install --no-cache octave_kernel \
  && pip install --no-cache jupyter
