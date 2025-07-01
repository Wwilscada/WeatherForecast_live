FROM python:3.10-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y curl gnupg unixodbc-dev gcc g++ && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Set work directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Expose port and start
EXPOSE 8097
CMD ["gunicorn", "--bind", "0.0.0.0:7738", "main:app"]
