
# Setting Up MariaDB with Docker Compose

This guide will walk you through setting up a MariaDB container using Docker Compose. Docker Compose is a tool for defining and running multi-container Docker applications.

## Prerequisites

- Docker installed on your machine
- Docker Compose installed on your machine

## Step-by-Step Instructions

### Step 1: Create a Docker Compose File

Create a file named `docker-compose.yml` in your project directory with the following content:

```yaml
version: '3.1'

services:
  mariadb:
    image: mariadb:latest
    container_name: mariadb-container
    environment:
      MARIADB_ROOT_PASSWORD: example_root_password
      MARIADB_DATABASE: example_db
      MARIADB_USER: example_user
      MARIADB_PASSWORD: example_password
    ports:
      - "3306:3306"
    volumes:
      - mariadb_data:/var/lib/mysql

volumes:
  mariadb_data:
```

### Explanation:
- **version:** Specifies the Docker Compose version.
- **services:** Defines the services to be run.
- **mariadb:** The name of the MariaDB service.
- **image:** Specifies the Docker image to use for MariaDB.
- **container_name:** Names the container (optional).
- **environment:** Environment variables for configuring MariaDB.
  - `MARIADB_ROOT_PASSWORD`: The root password for MariaDB.
  - `MARIADB_DATABASE`: The name of a database to be created.
  - `MARIADB_USER`: A user to be created with access to the database.
  - `MARIADB_PASSWORD`: The password for the created user.
- **ports:** Maps the container's port 3306 to the host machine's port 3306.
- **volumes:** Defines a named volume to persist MariaDB data.

### Step 2: Start the MariaDB Container

Navigate to your project directory in the terminal and run the following command:

```sh
docker-compose up -d
```

This command will download the MariaDB image (if not already available) and start the MariaDB container in detached mode.

### Step 3: Verify the Setup

You can verify that the MariaDB container is running by executing:

```sh
docker ps
```

This command will list all running containers. You should see `mariadb-container` in the list.

### Step 4: Connecting to MariaDB

To connect to your MariaDB instance, you can use any MySQL client with the following credentials:

- **Host:** `localhost`
- **Port:** `3306`
- **User:** `example_user`
- **Password:** `example_password`
- **Database:** `example_db`

You can also connect from within the container using:

```sh
docker exec -it mariadb-container mysql -u example_user -p
```

When prompted, enter the password `example_password`.

## Stopping the MariaDB Container

To stop the container, run:

```sh
docker-compose down
```

This command will stop and remove the container, but the data will persist in the `mariadb_data` volume.

## Conclusion

By following these steps, you should have a running MariaDB instance in a Docker container, managed with Docker Compose. This setup is suitable for development and testing purposes.

For more information, visit the [official Docker documentation](https://docs.docker.com/compose/) and the [MariaDB Docker Hub page](https://hub.docker.com/_/mariadb).
