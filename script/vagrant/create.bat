@echo off
if not exist tmp mkdir tmp

if not exist tmp\bootstrap-salt.sh powershell -Command "Invoke-WebRequest https://bootstrap.saltstack.com -OutFile tmp/bootstrap-salt.sh"

if not exist tmp\salt mkdir tmp\salt
copy configuration\minion.yaml tmp\salt\minion.conf

vagrant up
vagrant ssh --command /vagrant/script/vagrant/vagrant.sh
pause
