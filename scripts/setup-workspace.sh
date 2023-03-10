#!/bin/bash

echo '== Update system =='
sudo apt-get update

echo '== Install libgmp3 =='
sudo apt-get install libgmp3-dev -y

echo '== Install mysql client =='
sudo apt-get install mysql-client libmysqlclient-dev -y

echo '== Install latest rails =='
gem install rails

echo '== Bundle install =='
bundle install

echo '== Wait for mysql service =='
cs wait service mysql

echo '== Run all migrations =='
rails db:migrate

echo '== DONE =='
