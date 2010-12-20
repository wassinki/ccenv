require 'breakpoint'

Then /^(?:I )?wait$/ do
  puts "Press Enter to continue"
  STDIN.gets
end

Then /^(?:I )?debug$/ do
  puts "Entering debug mode. Type return followed by Enter to continue"
  breakpoint
end

Then /^(?:I )?wait (\d+) (\w+)$/ do |duration, unit|
  # for example wait 1 minute, then sleep 1.minutes.to_i results in => sleep(60)
  t = duration.to_i.__send__(unit).to_i
  print "Wait #{t} seconds: " 
  t.times do |i|
    print "."
    $stdout.flush
    sleep(1)
  end
  puts  
end
