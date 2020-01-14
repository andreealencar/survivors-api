<h1 align="center">survivors-api</h1>
<p>
</p>

> API for ZSSN (Zombie Survival Social Network)

## Dependencies

First, you need to got `Docker` and `docker-compose` installed on your machine to run this project. Access [here](https://docs.docker.com/compose/install/#install-compose) to get instructions of how install theses dependencies.

## Install

After properly install `docker-compose`, you can use the command bellow to build:
```sh
docker-compose buid
```

Then create dabata

```sh
docker-compose run survivors-api rails db:drop db:create db:migrate db:seed
```

## Usage

```sh
docker-compose up
```

## Author

- Github: [@andreealencar](https://github.com/andreealencar)
- Linkedin: [@andreealencar](https://www.linkedin.com/in/andreealencar/)
