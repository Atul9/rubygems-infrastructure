#
# Cookbook Name:: rubygems-sensu
# Recipe:: database
#

sensu_check 'check_postgres_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'postgres -D'"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(notification: "[#{node.chef_environment}] postgres is not running", occurrences: 3)
end

sensu_check 'check_postgres_connection' do
  command "perl /etc/sensu/plugins/check_postgres.pl --action connection -db rubygems_#{node.chef_environment}"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(occurrences: 3)
end

sensu_check 'check_postgres_backends' do
  command "perl /etc/sensu/plugins/check_postgres.pl --action backends -db rubygems_#{node.chef_environment}"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(occurrences: 3)
end