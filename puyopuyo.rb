#encoding: utf-8
if __FILE__ == $0
  class NilClass
    def [](args)
      nil
    end
  end

  FLUSH    = "*"
  INDENT   = "                         "
  @counter = 0
  @width   = 6

  def to_2d(_board, width, _2d=[])
    _2d << _board.slice!(0..width)
    to_2d(_board, width, _2d) unless _board.empty?
    _2d
  end

  def puts_field
    puts ""
    @field.each do |line|
      puts %Q|#{INDENT}#{line.join("")}|
    end
  end

  def draw
    system "clear"
    puts_field
    puts "#{INDENT}#{@counter += 1}れんさ!!"
    sleep 0.7
    @field.each_with_index do |line, y|
      line.each_with_index do |v, x|
        if v == FLUSH
          (1..y).reverse_each do |pos|
            @field[pos][x] = @field[pos-1][x]
          end
          @field[0][x] = " "
        end
      end
    end
    system "clear"
    puts_field
    puts ""
    sleep 0.7
  end

  def backtracking(top, left, matcher, counter=0)
    @field[top][left] = FLUSH
    _upper = top  - 1
    _lower = top  + 1
    _left  = left - 1
    _right = left + 1

    backtracking(_upper, left, matcher, counter+1) if @field[_upper][left] == matcher && _upper >= 0
    backtracking(_lower, left, matcher, counter+1) if @field[_lower][left] == matcher && _lower < @height
    backtracking(top,   _left, matcher, counter+1) if @field[top][_left]   == matcher && _left  >= 0
    backtracking(top,  _right, matcher, counter+1) if @field[top][_right]  == matcher && _right < @width
  end

  def prepend
    system "clear"
    8.times{puts ""}
    puts "                    Happy Programing!!"
    sleep 3
    system "clear"
    8.times{puts ""}
    puts "          PuyoPuyo 19times chain reaction purge!!"
    sleep 3
    system "clear"
    8.times{puts ""}
    puts "#{INDENT}Let's Go!!"
    sleep 3
    system "clear"
    sleep 0.5
    puts_field
    sleep 0.5
    system "clear"
    sleep 0.5
    puts_field
    sleep 0.5
    system "clear"
    sleep 0.5
    puts_field
    sleep 0.5
    system "clear"
  end

  def play
    @height.times do |top|
      @width.times do |left|
        next if @field[top][left] == FLUSH || @field[top][left] == " "

        snapshot = Marshal.load(Marshal.dump(@field))
        backtracking(top, left, @field[top][left])
        if @field.flatten.select{|v| v==FLUSH}.length >= 4
          draw
          play
        else
          @field = snapshot
        end
      end
    end
  end

  def append
    system "clear"
    8.times{puts ""}
    puts "#{INDENT}全消し!!"
    7.times{puts ""}
  end

  open(File.expand_path('data/puyo_wall.txt')) do |f|
    line    = f.read.gsub(/\r\n/, "")
    @field  = to_2d(line.length.times.inject([]){|a, i| a << line[i]}, @width-1)
    @height = @field.length
  end

  prepend
  play
  append
end
