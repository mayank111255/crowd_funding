if (Rails.env.eql?('production'))
  working_directory "/home/mayank/crowd_funding/current/"

  pid "/home/mayank/crowd_funding/current/pids/unicorn.pid"

  stderr_path "/home/mayank/crowd_funding/current/log/unicorn.log"
  stdout_path "/home/mayank/crowd_funding/current/log/unicorn.log"

  listen "/tmp/unicorn.[crowd_funding].sock"
  listen "/tmp/unicorn.myapp.sock"

  worker_processes 2

  timeout 30
end