install:
	docker-compose run web mix deps.get
	docker-compose run web mix ecto.create
	docker-compose run test mix ecto.create
	cd assets && npm install && cd ..
run:
	docker-compose up

compose-test:
	docker-compose run web mix test

compose-kill:
	docker-compose kill