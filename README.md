<h1 align="center">survivors-api</h1>
<p>
</p>

> API for ZSSN (Zombie Survival Social Network)

## Setup choices

I dockerized this API because i don't know nothing about evaluator machine, so i recommend user docker.
I used some gems like interactor and shoulda-matchers to target best practices in development like `skinny controller and fatty models`. I did all asked features in gist and write tests to cover all source code, you can see coverage executing tests (see section bellow) and open `index.html` in coverage directory.

## Dependencies

First, you need to got `Docker` and `docker-compose` installed on your machine to run this project. Access [here](https://docs.docker.com/compose/install/#install-compose) to get instructions of how install theses dependencies.

But if you prefer use your local database, all you have to do is change include adpater gem of your preference in Gemfile, and change `database.yml` file.

```sh
default: &default
  adapter: postgresql # <-- your adapter here
  encoding: unicode
  host: db            # <-- normally localhost
  username: postgres  # <-- username
  password:           # <-- password
```

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

## Tests

```sh
docker-compose run survivors-api rspec
```

## Access API documentation

`localhost:3000/apipie`

## Author

- Github: [@andreealencar](https://github.com/andreealencar)
- Linkedin: [@andreealencar](https://www.linkedin.com/in/andreealencar/)
