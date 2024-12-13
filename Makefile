all : build

build :
	@mkdir -p /home/abdmessa/data
	@mkdir -p /home/abdmessa/data/mariadb
	@mkdir -p /home/abdmessa/data/wordpress
	@sudo docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml up -d --build

mariadb :
	@sudo docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml up --build mariadb

wordpress :
	@sudo docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml build wordpress

nginx :
	@sudo docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml build nginx

logs :
	@sudo docker-compose --env-file ./srcs/.env -f srcs/docker-compose.yml logs mariadb
	@sudo docker-compose --env-file ./srcs/.env -f srcs/docker-compose.yml logs wordpress
	@sudo docker-compose --env-file ./srcs/.env -f srcs/docker-compose.yml logs nginx

down :
	@sudo docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml down

clean : down
	@sudo docker system prune -af
	@sudo rm -rf /home/abdmessa/data

fclean : clean
	@sudo docker volume rm srcs_mariadb
	@sudo docker volume rm srcs_wordpress
re : clean all

.PHONY : all build up logs down clean