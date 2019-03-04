env :PATH, ENV['PATH']

every 2.minute do
  runner 'LoadTopItemsJob.perform_later'
  runner 'LoadNewItemsJob.perform_later'
end

every 10.minute do 
  runner 'LoadShowItemsJob.perform_later'
  runner 'LoadJobItemsJob.perform_later'
  runner 'LoadAskItemsJob.perform_later'
end