#!/bin/bash

# Source
# https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/
# https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/

kubectl apply -f storage-class.yaml
# On each machine
sudo mkdir /mnt/data

kubectl apply -f mysql-client.yaml
kubectl apply -f mysql-configmap.yaml
kubectl apply -f mysql-services.yaml
kubectl delete -f mysql-statefulset.yaml
kubectl apply -f mysql-statefulset.yaml

# Watch
kubectl get pods -l app=mysql --watch

# ssh
kubectl exec -it mysql-client -- bin/sh
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql-0.mysql

CREATE DATABASE dzhw;

use dzhw;

CREATE TABLE `users` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `email` varchar(50) NOT NULL,
    `date_of_birth` date NOT NULL,
    `city` varchar(80) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;

insert into users values
('1','John','jdoe@gmail.com','1986-07-06','Munich'),
('2','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('3','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('4','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('5','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('6','John','jdoe@gmail.com','1986-07-06','Munich'),
('7','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('8','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('9','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('10','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('11','John','jdoe@gmail.com','1986-07-06','Munich'),
('12','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('13','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('14','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('15','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('16','John','jdoe@gmail.com','1986-07-06','Munich'),
('17','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('18','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('19','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('20','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('21','John','jdoe@gmail.com','1986-07-06','Munich'),
('22','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('23','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('24','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('25','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('26','John','jdoe@gmail.com','1986-07-06','Munich'),
('27','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('28','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('29','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('30','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('31','John','jdoe@gmail.com','1986-07-06','Munich'),
('32','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('33','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('34','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('35','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('36','John','jdoe@gmail.com','1986-07-06','Munich'),
('37','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('38','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('39','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('40','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('41','John','jdoe@gmail.com','1986-07-06','Munich'),
('42','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('43','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('44','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('45','Xavier','xavier@yahoo.com','1972-10-25','Paris'),
('46','John','jdoe@gmail.com','1986-07-06','Munich'),
('47','Tatiana','tania@yahoo.com','1993-03-14','Moscow'),
('48','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('49','Frea','frs@gmail.com','2000-12-30','Copenhagen'),
('50','Xavier','xavier@yahoo.com','1972-10-25','Paris');
