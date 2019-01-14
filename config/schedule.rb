env :PATH, ENV['PATH']

every :minute do
  runner 'LoadTopItemsJob.perform_later'
  runner 'LoadShowItemsJob.perform_later'
  runner 'LoadNewItemsJob.perform_later'
  runner 'LoadJobItemsJob.perform_later'
  runner 'LoadAskItemsJob.perform_later'
end
