module Weather
  def date_formate_converter(date_string)
    # In date_string, date is in 2007-2-3 formate
    # this function will convert it into march 2, 2007
    temp = date_string.split('-')
    time = Time.new(temp[0], temp[1], temp[2])
    time.strftime('%B %d, %Y')
  end

  def yearly_report(year, folder_path)
    unless File.directory? folder_path
      puts 'Folder Not Found'
      return
    end

    # Store all files in an array and then extract the required files from the array
    all_files = Dir.entries(folder_path)
    req_files = []

    all_files.each do |file|
      req_files.push(file) if file.include? year
    end

    # Terminate the program if wrong year is entered
    if req_files.length.zero?
      puts 'Wrong Year Entered'
      return
    end

    days = ['', '', ''] # Array of highest_temp, lowest_temp and max_humidity days
    highest_temp = -100
    lowest_temp = 100
    max_humidity = -100

    # Now traverse each line of each file and find the required data
    req_files.each do |file|
      complete_path = "#{folder_path}/#{file}"
      fd = File.open(complete_path, 'r')
      lines = fd.readlines
      lines.delete_at(0) # remove first line of file

      # Converting the line string to a array for ease
      lines.each do |line|
        line_arr = line.split(',')

        # index 1 of line_arr holds Max Temp
        if line_arr[1].to_i > highest_temp.to_i
          days[0] = line_arr[0] # index 0 of line_arr holds Date
          highest_temp = line_arr[1].to_i
        end

        # index 3 of line_arr holds Min Temp
        if line_arr[3].to_i < lowest_temp.to_i
          days[1] = line_arr[0]
          lowest_temp = line_arr[3].to_i
        end

        # index 7 of line_arr holds Max Humidity
        if line_arr[7].to_i > max_humidity.to_i
          days[2] = line_arr[0]
          max_humidity = line_arr[7].to_i
        end
      end
    end

    puts "Highest temp: #{highest_temp}C on #{date_formate_converter(days[0])}"
    puts "Lowest temp: #{lowest_temp}C on #{date_formate_converter(days[1])}"
    puts "Highest Humid: #{max_humidity}% on #{date_formate_converter(days[2])}"
  end

  def monthly_report(file_path)
    unless File.file? file_path
      puts 'File Not Found'
      return
    end

    highest_avg_temp = -100
    lowest_avg_temp = 100
    avg_humidity = 0
    n = 0
    date = ''

    fd = File.open(file_path, 'r')
    lines = fd.readlines
    lines.delete_at(0) # remove first line of file

    lines.delete_at(0) if file_path.include? 'lahore'
    lines.delete_at(-1) if file_path.include? 'lahore'

    lines.each do |line|
      line_arr = line.split(',')

      date = line_arr[0] if n == 5

      unless line_arr[2].empty?
        # puts line_arr[2]
        highest_avg_temp = line_arr[2].to_i if line_arr[2].to_i > highest_avg_temp.to_i
        lowest_avg_temp = line_arr[2].to_i if line_arr[2].to_i < lowest_avg_temp.to_i
      end
      avg_humidity += line_arr[8].to_i
      n += 1
    end

    avg_humidity /= n
    puts date_formate_converter(date).to_s
    puts "Highest Average temp: #{highest_avg_temp}C"
    puts "Lowest Average temp: #{lowest_avg_temp}C"
    puts "Average Humid: #{avg_humidity}% "
  end

  def bar_chart(file_path, is_bonus)
    unless File.file? file_path
      puts 'File Not Found'
      return
    end

    fd = File.open(file_path, 'r')
    lines = fd.readlines
    lines.delete_at(0) # remove first line of file

    day = 1

    puts date_formate_converter(lines[0].split(',')[0]).to_s # Extracting the month name
    lines.each do |line|
      line_arr = line.split(',')

      # Here I combine the task 3 and bonus task
      # day 1-14 is task 3, Day 15 to onwards is bonus task
      max_t = line_arr[1].to_i
      min_t = line_arr[3].to_i
      print "#{day} "

      if is_bonus.zero?
        max_t.times { print '+'.red }
        puts " #{max_t}C"
        print "#{day} "
        min_t.times { print '+'.blue }
        puts " #{min_t}C"
      else
        min_t.times { print '+'.blue }
        max_t.times { print '+'.red }
        print " #{min_t}C - #{max_t}C\n"
      end

      day += 1
    end
  end
end
