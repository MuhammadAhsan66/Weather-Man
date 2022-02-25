require 'colorize'
require './weather_report'
include Weather

def main
  # Firstly check the corectness of arguments
  if ARGV.length != 3
    puts 'Incorrect Arguments'
    puts 'Use this format: ruby weather_man.rb {-e | -a | -c} {year | year/month} {path_to_file | path_to_fileFolder}'
    return
  end

  # call function as per the requirment
  case ARGV[0]
  when '-e'
    yearly_report(ARGV[1], ARGV[2])
  when '-a'
    monthly_report(ARGV[2])
  when '-c'
    bar_chart(ARGV[2])
  else
    puts 'Incorrect Arguments'
    puts 'Use this format: ruby weather_man.rb {-e | -a | -c} {year | year/month} {path_to_file | path_to_fileFolder}'
  end
end

main
