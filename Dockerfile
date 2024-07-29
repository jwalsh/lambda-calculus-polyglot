# Use the official PostgreSQL image
FROM postgres:13

# Set environment variables
ENV POSTGRES_DB=${PGDATABASE}
ENV POSTGRES_USER=${PGUSER}
ENV POSTGRES_PASSWORD=${PGPASSWORD}

# Copy initialization scripts
COPY ./ai_code_generation_seed.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port
EXPOSE 5432