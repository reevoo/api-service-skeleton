#!/usr/bin/env puma

workers Integer(ENV["WEB_CONCURRENCY"] || 2)
min_threads = Integer(ENV["WEB_MIN_THREADS"] || 1)
max_threads = Integer(ENV["WEB_MAX_THREADS"] || 5)
threads min_threads, max_threads
preload_app!

on_worker_boot do
  FooService::DB.disconnect
end
