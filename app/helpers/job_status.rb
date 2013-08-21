def job_is_complete(jid)
  waiting = Sidekiq::Queue.new
  working = Sidekiq::Workers.new
  pending = Sidekiq::ScheduledSet.new
  return {status: false} if pending.find { |job| job.jid == jid }
  return {status: false} if waiting.find { |job| job.jid == jid }
  return {status: false} if working.find { |worker, info| info["payload"]["jid"] == jid }
  {status: true}
end